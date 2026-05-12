# 실행 중인 서비스

## 1. API 서버 (screen)

웨어러블 앱에서 CSV 데이터를 수신하는 Django REST API 서버

### 실행
```sh
cd forSurvey/DMF_ver3
python3 manage.py runserver 0.0.0.0:7778 >> server.log 2>&1
```
> Swagger UI: `http://{서버IP}:7778/swagger`

---

### `POST /forUser/postCurrentData/`
웨어러블 앱 → 서버로 CSV 데이터 업로드

**Content-Type:** `multipart/form-data`

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `csvfile` | FILE | ✅ | 워치에서 수집된 .csv 파일 |
| `userID` | STRING | ✅ | 사용자 ID (ex. `AA00`) — DB `users.authCode` 필드와 매칭 |
| `battery` | INTEGER | ✅ | 배터리 잔량 |
| `timestamp` | STRING | ✅ | Unix epoch **초단위** 정수 문자열 (ex. `1672498800`) |

> ⚠️ `timestamp`는 `"2023-01-01"` 같은 날짜 문자열 형식 불가 — 파싱 오류 발생

**파일 저장 경로:** `uploads/{userID}/{dd_mm_yyyy}/{filename}.csv`

**응답 코드:**

| 코드 | 의미 |
|------|------|
| 200 | 성공 |
| 401 | 이미 존재하는 파일 (중복 전송) |
| 403 | 필수 파라미터 누락 |
| 405 | DB에 해당 user의 deviceID 없음 |
| 406 | DB 접속 오류 |

---

### `GET /forUser/registUser/`
앱 최초 실행 시 deviceID, regID 등록 (Query Parameter)

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `userID` | STRING | 사용자 ID |
| `deviceID` | STRING | 기기 난수값 |
| `regID` | STRING | 등록 난수값 |
| `timestamp` | STRING | Unix epoch 초단위 |

---

## 2. 데일리 적재 크론 (crontab)

전날 업로드된 CSV를 MongoDB에 적재하는 스크립트. 매일 00:30 자동 실행.

### 크론 설정
```sh
30 0 * * * cd /path/to/file2db && /path/to/python watch_upload_daily.py
```

### 동작 흐름
1. `uploads/{email}/{dd_mm_yyyy}/` 에서 **전날** 날짜 폴더의 CSV 탐색
2. 파일명 키워드로 센서 타입 판별 → MongoDB 컬렉션 선택
3. BATCH_SIZE(5000) 단위로 `insert_many` 업로드
4. 업로드 완료 파일은 `uploaded/{email}/{dd_mm_yyyy}/` 로 이동

### 센서 타입 → MongoDB 컬렉션

| 파일명 키워드 | 컬렉션 | CSV 컬럼 |
|---|---|---|
| Accelerometer | `watch_accelerometer` | time, x, y, z |
| Gravity | `watch_gravity` | time, x, y, z |
| Gyroscope | `watch_gyroscope` | time, x, y, z |
| HeartRate | `watch_heart_rate` | time, value |
| Light | `watch_light` | time, value |
| PpgGreen | `watch_ppg_green` | time, value |
| StepCount | `watch_step_count` | time, value |

> `time` 컬럼은 epoch **밀리초** 단위 → ISO8601 UTC로 변환하여 MongoDB에 저장  
> `test_mail_list.csv` 에 등록된 이메일은 업로드 스킵

### 로그

| 파일 | 내용 |
|------|------|
| `file2db/logs/upload_logs/upload_log_daily_{날짜}.txt` | 파일별 적재 결과 |
| `file2db/logs/upload_email_logs/uploaded_emails_daily_{날짜}.json` | 당일 처리 완료된 이메일 목록 (재실행 시 중복 방지용) |

### 관련 파일

| 파일 | 역할 |
|------|------|
| `watch_upload_daily.py` | 크론 진입점 — 전날 1일치 데이터 처리 |
| `watch_upload.py` | 공통 상수·유틸 함수 정의 (수동 일괄 적재 시 직접 실행) |
| `test_mail_list.csv` | 업로드 스킵할 테스트 계정 이메일 목록 (`test_mail_list` 컬럼) |
