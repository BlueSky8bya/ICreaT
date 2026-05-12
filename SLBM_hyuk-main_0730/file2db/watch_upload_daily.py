"""
전날 하루치 웨어러블 데이터를 MongoDB에 업로드하는 데일리 스크립트.

crontab 설정 예시 (매일 00:30 실행):
  30 0 * * * cd /mnt/ssd1/wearables/file2db && /usr/bin/python3 watch_upload_daily.py
"""
import os
import json
import logging
from datetime import date, timedelta
import pandas as pd
from tqdm import tqdm

# ---- 대상 날짜: 실행일 기준 전날 ----
TARGET_DATE = date.today() - timedelta(days=1)
DATE_FOLDER = TARGET_DATE.strftime("%d_%m_%Y")

# ---- 로그 경로 (watch_upload import 전에 먼저 설정 → basicConfig 충돌 방지) ----
LOG_PATH = './logs/upload_logs'
EMAIL_LOG_PATH = './logs/upload_email_logs'
os.makedirs(LOG_PATH, exist_ok=True)
os.makedirs(EMAIL_LOG_PATH, exist_ok=True)
LOG_FILE = os.path.join(LOG_PATH, f"upload_log_daily_{TARGET_DATE}.txt")
EMAIL_LOG_FILE = os.path.join(EMAIL_LOG_PATH, f"uploaded_emails_daily_{TARGET_DATE}.json")

logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)

# ---- watch_upload에서 재사용 (순수 함수 및 공통 상수/연결) ----
from watch_upload import (
    epoch_to_iso,
    DATA_TYPE_MAP,
    db,
    BASE_PATH,
    UPLOADED_PATH,
    SKIP_FILE,
    BATCH_SIZE,
    move_to_uploaded,
    get_uid_from_email,
)


def log_print(msg: str):
    logging.info(msg)


def load_uploaded_emails() -> set:
    if not os.path.exists(EMAIL_LOG_FILE):
        return set()
    with open(EMAIL_LOG_FILE, "r", encoding="utf-8") as f:
        return set(json.load(f))


def save_uploaded_email(email: str):
    emails = load_uploaded_emails()
    emails.add(email)
    with open(EMAIL_LOG_FILE, "w", encoding="utf-8") as f:
        json.dump(sorted(list(emails)), f, indent=2, ensure_ascii=False)


def process_single_email(email: str, skip_emails: set, uploaded_emails: set):
    if email in skip_emails:
        log_print(f"스킵 대상: {email}")
        return
    if email in uploaded_emails:
        log_print(f"이미 업로드 완료 (건너뜀): {email}")
        return

    email_path = os.path.join(BASE_PATH, email)
    if not os.path.isdir(email_path):
        log_print(f"email dir 없음: {email_path}")
        return

    uid = get_uid_from_email(email)
    if not uid:
        log_print(f"UID 없음: {email}")
        return

    date_path = os.path.join(email_path, DATE_FOLDER)
    if not os.path.isdir(date_path):
        log_print(f"날짜 폴더 없음 (데이터 없음): {email}/{DATE_FOLDER}")
        save_uploaded_email(email)
        return

    for file in sorted(os.listdir(date_path)):
        if not file.endswith(".csv"):
            continue

        data_type = None
        for key in DATA_TYPE_MAP:
            if key.lower() in file.lower():
                data_type = key
                break

        if data_type not in DATA_TYPE_MAP:
            continue

        collection = db[DATA_TYPE_MAP[data_type]]
        file_path = os.path.join(date_path, file)

        bad_header = False
        try:
            data = pd.read_csv(file_path, on_bad_lines="skip")
            if data.empty:
                continue
        except Exception as e:
            log_print(f"읽기 실패: {file_path} - {e}")
            continue

        first_col = str(data.columns[0]).strip()
        second_col = str(data.columns[1]).strip() if len(data.columns) > 1 else ""
        if first_col.lower().startswith("unnamed") or first_col.replace(".", "", 1).isdigit():
            bad_header = True
        elif second_col.lower().startswith("unnamed") or second_col.replace(".", "", 1).isdigit():
            bad_header = True

        if bad_header:
            if data_type in ["Accelerometer", "Gravity", "Gyroscope"]:
                data = pd.read_csv(file_path, header=None, names=["time", "x", "y", "z"], on_bad_lines="skip")
            else:
                data = pd.read_csv(file_path, header=None, names=["time", "value"], on_bad_lines="skip")
            log_print(f"헤더 비정상 감지 → names 적용 재로드: {file_path}")

            if data_type in ["Accelerometer", "Gravity", "Gyroscope"]:
                for col in ["time", "x", "y", "z"]:
                    data[col] = pd.to_numeric(data[col], errors="coerce")
                data = data.dropna(subset=["time", "x", "y", "z"])
            else:
                for col in ["time", "value"]:
                    data[col] = pd.to_numeric(data[col], errors="coerce")
                data = data.dropna(subset=["time", "value"])

        records = []
        for _, row in data.iterrows():
            try:
                ts = int(row['time'])
                timestamp = epoch_to_iso(ts)
                if data_type in ["Accelerometer", "Gravity", "Gyroscope"]:
                    rec = {
                        "uid": uid, "type": data_type, "time": timestamp,
                        "X": row['x'], "Y": row['y'], "Z": row['z']
                    }
                else:
                    rec = {
                        "uid": uid, "type": data_type, "time": timestamp,
                        "data": row['value']
                    }
                records.append(rec)
            except Exception as e:
                log_print(f"행 파싱 실패: {file_path} - {e}")

        if records:
            upload_success = True
            try:
                for i in range(0, len(records), BATCH_SIZE):
                    batch = records[i:i + BATCH_SIZE]
                    collection.insert_many(batch, ordered=False)
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


if __name__ == "__main__":
    log_print(f"대상 날짜: {TARGET_DATE} (폴더: {DATE_FOLDER})")

    skip_df = pd.read_csv(SKIP_FILE)
    skip_emails = set(skip_df['test_mail_list'].dropna().astype(str).str.strip())
    uploaded_emails = load_uploaded_emails()

    email_dirs = [d for d in sorted(os.listdir(BASE_PATH))
                  if os.path.isdir(os.path.join(BASE_PATH, d))]

    log_print(f"총 {len(email_dirs)}개 이메일 디렉토리 발견")
    log_print(f"스킵 대상 {len(skip_emails)}개 이메일 로드 완료")

    for email in tqdm(email_dirs, desc="이메일 업로드 진행", unit="email"):
        log_print(f"이메일 업로드 시작: {email}")
        process_single_email(email, skip_emails, uploaded_emails)

    log_print(f"{TARGET_DATE} 전체 업로드 완료!")
