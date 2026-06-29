# Sensor CSV Upload API 연동 가이드

## 1. 개요

외부 앱에서 워치 센서 CSV 파일을 베데스다 iCReaT DCT 서버로 업로드하기 위한 API입니다.

- 인증: 없음
- 요청 형식: `multipart/form-data`
- 파일 단위: 센서별 CSV 파일 1개당 POST 1회
- 성공 기준: HTTP `200`

## 2. 요청 정보

### Endpoint

```text
POST https://icreatdct.btsd.io/iCReaT_DCT/invoke/DCT/Sensor/uploadCsv
```

### Multipart Form Fields

| 필드명 | 타입 | 필수 | 설명 |
|---|---:|:---:|---|
| `csvfile` | File | Y | 센서 CSV 파일 |
| `studyId` | Text | Y | Study ID. 현재 `dct_subject_login.STDYNO` 기준 |
| `subjectId` | Text | Y | Subject ID. 현재 `dct_subject_login.PATSTDYID` 기준 |
| `battery` | Text | Y | 워치 배터리 잔량 |
| `timestamp` | Text | Y | 전송 시각. Unix epoch 초 단위 문자열 |

## 3. 파일 규칙

서버는 CSV 파일명에 포함된 키워드로 센서 종류를 판별합니다.

지원 센서:

```text
Accelerometer
Gravity
Gyroscope
HeartRate
Light
PpgGreen
StepCount
```

파일명 예시:

```text
PpgGreen_260330_190548.csv
HeartRate_260330_190548.csv
Accelerometer_260330_190548.csv
```

## 4. 응답 코드

| HTTP 코드 | 의미 | 처리 기준 |
|---:|---|---|
| `200` | 성공 | 업로드 완료 |
| `401` | 동일 파일명 중복 전송 | 동일 `studyId + subjectId + 파일명`이 이미 등록됨 |
| `403` | 필수 파라미터 누락 또는 요청값 오류 | 필드 누락, timestamp 형식 오류, 미지원 파일명 등 |
| `405` | 등록되지 않은 사용자 ID | `studyId`, `subjectId` 조합이 등록되어 있지 않음 |
| `406` | DB 접속 또는 처리 오류 | 서버 DB 처리 실패 |

## 5. 성공 응답 예시

```http
HTTP/1.1 200 OK
Content-Type: application/json
```

```json
{
  "status": "success",
  "message": "정상 처리되었습니다.",
  "uploadSeq": 1,
  "sensorType": "PpgGreen",
  "fileName": "PpgGreen_260330_190548.csv",
  "duplicate": "N"
}
```

## 6. 실패 응답 예시

### 동일 파일명 중복 전송

```http
HTTP/1.1 401 Unauthorized
Content-Type: application/json
```

```json
{
  "status": "error",
  "message": "동일 파일명이 이미 전송되었습니다."
}
```

### 필수 파라미터 누락

```http
HTTP/1.1 403 Forbidden
Content-Type: application/json
```

```json
{
  "status": "error",
  "message": "subjectId는 필수 파라미터입니다."
}
```

### 등록되지 않은 대상자

```http
HTTP/1.1 405 Method Not Allowed
Content-Type: application/json
```

```json
{
  "status": "error",
  "message": "등록되지 않은 studyId 또는 subjectId입니다."
}
```

## 7. curl 예시

Windows PowerShell:

```powershell
curl.exe -i -X POST "https://icreatdct.btsd.io/iCReaT_DCT/invoke/DCT/Sensor/uploadCsv" `
  -F "csvfile=@C:\Users\BTSD-KYJ\Downloads\PpgGreen_260330_190548.csv;type=text/csv" `
  -F "studyId=C250005" `
  -F "subjectId=121-001" `
  -F "battery=87" `
  -F "timestamp=1774865148"
```

## 8. 테스트 대상자

개발/연동 테스트 시 아래 `studyId`, `subjectId` 조합을 사용할 수 있습니다.

| No | studyId | subjectId |
|---:|---|---|
| 1 | `C250005` | `121-001` |
| 2 | `C250002` | `001-002` |
| 3 | `C250002` | `001-001` |

## 9. 서버 저장 정보

서버는 원본 CSV 파일을 저장하고, 업로드 이력을 DB에 등록합니다.

저장 경로:

```text
{fileStorePath}/sensor_upload/{studyId}/{subjectId}/{yyyyMMdd}/{원본파일명}
```

DB 테이블:

```text
dct_sensor_upload
```

주요 저장 항목:

```text
study_id, subject_id, sensor_type, original_file_nm, file_path,
file_size, content_type, battery, client_timestamp,
upload_status, message, ins_dt, ins_ip
```
