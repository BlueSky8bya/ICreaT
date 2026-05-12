import os
import shutil
import pandas as pd
import json
import time
import logging
from pymongo import MongoClient
from datetime import datetime, timezone
from tqdm import tqdm
from time import sleep

from datetime import datetime, timezone, date  # 기존 import에 date 추가

# 폴더 이름 포맷 (예: 01_10_2025)
DATE_FOLDER_FMT = "%d_%m_%Y"

# 업로드 대상 기간 (포함 범위)
# RANGE_START = date(2025, 1, 12)
# RANGE_END   = date(2026, 1, 16)
RANGE_START = date(2002, 10, 27)
RANGE_END   = date(2026, 4, 22)

def folder_in_range(folder_name: str) -> bool:
    """
    폴더명이 DATE_FOLDER_FMT 형식일 때만 True/False 판단.
    형식이 다르면 False 로 간주하여 스킵.
    """
    try:
        d = datetime.strptime(folder_name, DATE_FOLDER_FMT).date()
    except ValueError:
        return False
    return RANGE_START <= d <= RANGE_END

# -------------------------------
# MongoDB 연결 설정
# -------------------------------
client = MongoClient(
    "mongodb://localhost:27017/",  # 실제 환경에 맞게 계정/호스트 수정 필요
    authSource="mentalHealth"                 # 인증 DB 지정
)
db = client['mentalHealth']  # 사용할 DB 이름

# -------------------------------
# 경로 및 파일 설정
# -------------------------------
BASE_PATH = "/mnt/ssd1/wearables/uploads"       # 센서 데이터가 저장된 최상위 경로
UPLOADED_PATH = "/mnt/ssd1/wearables/uploaded"  # 업로드 완료 파일 이동 경로
SKIP_FILE = "test_mail_list.csv" # 스킵할 이메일 리스트 CSV
start_time = datetime.now().strftime("%Y%m%d_%H%M%S")
LOG_PATH = './logs/upload_logs'
EMAIL_LOG_PATH = './logs/upload_email_logs'
os.makedirs(LOG_PATH, exist_ok=True)
os.makedirs(EMAIL_LOG_PATH, exist_ok=True)
LOG_FILE = os.path.join(LOG_PATH, f"upload_log_{RANGE_START}_to_{RANGE_END}.txt")
EMAIL_LOG_FILE = os.path.join(EMAIL_LOG_PATH, f"uploaded_emails_{RANGE_START}_to_{RANGE_END}.json")
BATCH_SIZE = 5000

def load_uploaded_emails():
    if not os.path.exists(EMAIL_LOG_FILE):
        return set()
    with open(EMAIL_LOG_FILE, "r", encoding="utf-8") as f:
        return set(json.load(f))

def save_uploaded_email(email):
    emails = load_uploaded_emails()
    emails.add(email)
    with open(EMAIL_LOG_FILE, "w", encoding="utf-8") as f:
        json.dump(sorted(list(emails)), f, indent=2, ensure_ascii=False)

# ==========================
# 테스트용 JSON 저장 함수
# ==========================
def save_records_to_json(records, file_path="test_upload.json"):
    """
    업로드 대신 JSON 파일로 저장하는 함수 (append 모드)
    """
    with open(file_path, "a", encoding="utf-8") as f:
        for rec in records:
            f.write(json.dumps(rec, ensure_ascii=False) + "\n")

# -------------------------------
# 센서 타입 → MongoDB 컬렉션 매핑
# -------------------------------
DATA_TYPE_MAP = {
    "Accelerometer": "watch_accelerometer",
    "Gravity": "watch_gravity",
    "Gyroscope": "watch_gyroscope",
    "HeartRate": "watch_heart_rate",
    "Light": "watch_light",
    "PpgGreen": "watch_ppg_green",
    "StepCount": "watch_step_count"
}

# -------------------------------
# 로깅 설정
# -------------------------------
logging.basicConfig(
    filename=LOG_FILE,              # 로그 파일명
    level=logging.INFO,             # 로그 레벨
    format="%(asctime)s %(levelname)s %(message)s"  # 로그 출력 포맷
)

def log_print(msg: str):
    """ 콘솔에도 출력하고 동시에 로그 파일에도 기록 """
    # print(msg)
    logging.info(msg)

def move_to_uploaded(file_path: str):
    """ 업로드 완료된 파일을 UPLOADED_PATH로 동일한 디렉토리 구조로 이동 """
    rel_path = os.path.relpath(file_path, BASE_PATH)
    dest_path = os.path.join(UPLOADED_PATH, rel_path)
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    shutil.move(file_path, dest_path)
    log_print(f"파일 이동: {file_path} → {dest_path}")

# -------------------------------
# UID 조회 함수
# -------------------------------
def get_uid_from_email(email: str):
    """
    MongoDB users 컬렉션에서 email → uid를 매핑
    uid 없으면 None 반환
    """
    user = db.users.find_one({"email": email}, {"uid": 1})
    return user.get("uid") if user else None

# -------------------------------
# epoch(ms) → ISO8601 변환
# -------------------------------
def epoch_to_iso(epoch: int):
    """
    밀리초 단위 epoch timestamp를 ISO8601 UTC 문자열로 변환
    예: 1696151234567 → "2023-10-01T12:34:56.789Z"
    """
    dt = datetime.fromtimestamp(epoch / 1000, tz=timezone.utc)
    return dt.isoformat(timespec='milliseconds').replace('+00:00', 'Z')

# -------------------------------
# 개별 사용자(이메일) 데이터 업로드
# -------------------------------
def process_single_email(email: str, skip_emails: set, uploaded_emails: set):
    """
    주어진 이메일 사용자 데이터 디렉토리를 읽고,
    CSV 데이터를 MongoDB에 업로드
    """
    # 스킵 대상 이메일이면 건너뛰기
    if email in skip_emails:
        log_print(f"스킵 대상: {email}")
        return
    if email in uploaded_emails:
        log_print(f"이미 업로드 완료된 이메일 (건너뜀): {email}")
        return

    email_path = os.path.join(BASE_PATH, email)
    if not os.path.isdir(email_path):
        log_print(f"email dir 없음: {email_path}")
        return

    # 이메일로 UID 조회
    uid = get_uid_from_email(email)
    if not uid:
        log_print(f"UID 없음: {email}")
        return

    # 날짜 폴더 순회
    for date_folder in sorted(os.listdir(email_path)):
        date_path = os.path.join(email_path, date_folder)
        if not os.path.isdir(date_path):
            continue

        # 추가: 지정한 날짜 범위가 아니면 스킵
        if not folder_in_range(date_folder):
            log_print(f"범위 외 스킵: {email}/{date_folder}")
            continue

        # 날짜 폴더 안의 파일 순회
        for file in sorted(os.listdir(date_path)):
            if not file.endswith(".csv"):
                continue

            data_type = None
            for key in DATA_TYPE_MAP.keys():
                if key.lower() in file.lower():  # 파일명에 포함 여부 확인
                    data_type = key
                    break

            if data_type not in DATA_TYPE_MAP:
                continue  # 매핑에 없는 타입은 무시
            
            collection = db[DATA_TYPE_MAP[data_type]]  # MongoDB 컬렉션 선택
            file_path = os.path.join(date_path, file)

            # # CSV 읽기
            # try:
            #     data = pd.read_csv(file_path, on_bad_lines="skip")
            #     if data.empty:
            #         continue  # 빈 파일이면 건너뜀
            # except Exception as e:
            #     log_print(f"읽기 실패: {file_path} - {e}")
            #     continue
            bad_header = False

            # CSV 읽기
            try:
                data = pd.read_csv(file_path, on_bad_lines="skip")
                if data.empty:
                    continue  # 빈 파일이면 건너뜀
            except Exception as e:
                log_print(f"읽기 실패: {file_path} - {e}")
                continue

            # 첫 번째 컬럼명이 숫자이거나 Unnamed 로 시작하면 헤더가 깨졌다고 판단
            first_col = str(data.columns[0]).strip()
            second_col = str(data.columns[1]).strip() if len(data.columns) > 1 else ""
            if first_col.lower().startswith("unnamed") or first_col.replace(".", "", 1).isdigit():
                bad_header = True
            elif second_col.lower().startswith("unnamed") or second_col.replace(".", "", 1).isdigit():
                bad_header = True

            # 잘못된 헤더면 다시 읽기 (헤더 없는 CSV로 처리)
            if bad_header:
                if data_type in ["Accelerometer", "Gravity", "Gyroscope"]:
                    data = pd.read_csv(file_path, header=None, names=["time", "x", "y", "z"], on_bad_lines="skip")
                else:
                    data = pd.read_csv(file_path, header=None, names=["time", "value"], on_bad_lines="skip")
                log_print(f"헤더 비정상 감지 → names 적용 재로드: {file_path}")

                # 센서별로 숫자형만 필터링
                if data_type in ["Accelerometer", "Gravity", "Gyroscope"]:
                    for col in ["time", "x", "y", "z"]:
                        data[col] = pd.to_numeric(data[col], errors="coerce")
                    log_print(f"drop 전 row 수: {len(data)}")       
                    data = data.dropna(subset=["time", "x", "y", "z"])
                    log_print(f"drop 후 row 수: {len(data)}")
                else:
                    for col in ["time", "value"]:
                        data[col] = pd.to_numeric(data[col], errors="coerce")
                    log_print(f"drop 전 row 수: {len(data)}")  
                    data = data.dropna(subset=["time", "value"])
                    log_print(f"drop 후 row 수: {len(data)}")

            # MongoDB에 넣을 문서(records) 생성
            records = []
            for _, row in data.iterrows():
                try:
                    ts = int(row['time'])               # epoch(ms)
                    timestamp = epoch_to_iso(ts)        # ISO 포맷 변환

                    # 센서 타입별 필드 구성
                    if data_type in ["Accelerometer", "Gravity", "Gyroscope"]: 
                        rec = {
                            "uid": uid,
                            "type": data_type,
                            "time": timestamp,
                            "X": row['x'], "Y": row['y'], "Z": row['z']
                        }
                    else: # HeartRate, Light, PpgGreen, StepCount
                        rec = {
                            "uid": uid,
                            "type": data_type,
                            "time": timestamp,
                            "data": row['value']
                        }
                    records.append(rec)
                except Exception as e:
                    log_print(f"행 파싱 실패: {file_path} - {e}")

            # MongoDB 업로드
            if records:
                upload_success = True
                try:
                    for i in range(0, len(records), BATCH_SIZE):
                        batch = records[i:i + BATCH_SIZE]
                        collection.insert_many(batch, ordered=False)  # 일부 실패해도 나머지 진행
                        # save_records_to_json(batch, f"{data_type}_test_upload.json") # test 용
                        log_print(f"업로드 완료: {file_path} (배치 {i//BATCH_SIZE + 1}, {len(batch)}개)")
                except Exception as e:
                    log_print(f"업로드 실패: {file_path} - {e}")
                    upload_success = False

                if upload_success:
                    try:
                        move_to_uploaded(file_path)
                    except Exception as e:
                        log_print(f"파일 이동 실패: {file_path} - {e}")

    save_uploaded_email(email)
    log_print(f"이메일 업로드 완료 기록: {email}")

# -------------------------------
# 메인 실행부
# -------------------------------
if __name__ == "__main__":
    # 스킵 이메일 목록 로드
    skip_df = pd.read_csv(SKIP_FILE)
    skip_emails = set(skip_df['test_mail_list'].dropna().astype(str).str.strip())

    uploaded_emails = load_uploaded_emails()

    # BASE_PATH 내 이메일 디렉토리 수집
    email_dirs = [d for d in sorted(os.listdir(BASE_PATH))
                  if os.path.isdir(os.path.join(BASE_PATH, d))]

    log_print(f"총 {len(email_dirs)}개 이메일 디렉토리 발견")
    log_print(f"스킵 대상 {len(skip_emails)}개 이메일 로드 완료")

    # 각 이메일별 데이터 처리
    for email in tqdm(email_dirs, desc="이메일 업로드 진행", unit="email"):
        log_print(f"이메일 업로드 시작 기록: {email}")
        process_single_email(email, skip_emails, uploaded_emails)

    log_print("전체 업로드 완료!")
