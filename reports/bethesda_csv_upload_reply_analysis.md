# 베데스다 CSV 업로드 회신 분석 및 수정 보고서

작성일: 2026-05-12  
대상: `Sensor_monitor` -> 베데스다 iCReaT DCT 서버 CSV 전송 전환

## 1. 결론 요약

베데스다 측 답변 기준으로 서버 엔드포인트는 신규 추가될 예정입니다. 다만 기존 강원대 규격의 `userID` 단일 식별자 방식은 베데스다 운영 방식과 맞지 않으므로, `studyId`, `subjectId`를 추가해 전송해야 합니다.

현재 `Sensor_monitor`는 `csvfile`, `userID`, `battery`, `timestamp` 4개 필드만 보냅니다. 베데스다 연동용으로는 아래 5개 필드가 가장 자연스럽습니다.

| 필드명 | 타입 | 설명 |
|---|---|---|
| `csvfile` | file | 센서별 30분 병합 CSV 파일 |
| `battery` | form field | 워치 배터리 잔량. 현재 앱에서는 multipart 일반 form field로 전달하며, 값은 워치에서 받은 배터리 숫자값을 그대로 사용 |
| `timestamp` | string | 전송 시각, Unix epoch 초 단위 |
| `studyId` | string | 베데스다 Study ID |
| `subjectId` | string | 베데스다 Subject ID |

베데스다 답변의 `scvFile`, `timeStamp`, “총 4개 필드” 표현은 오타 또는 표현 실수로 보입니다. 그래도 메일에서는 위 5개 필드명으로 구성하면 되는지 다시 확인하는 것이 좋습니다.

## 2. Q별 정리

### Q1. CSV 업로드 엔드포인트

베데스다 측은 CSV 업로드 엔드포인트를 추가해주겠다고 답했습니다. 다만 iCReaT가 여러 과제에서 운영되므로 `studyId`, `subjectId`가 꼭 필요하다고 했습니다.

우리 쪽 회신 방향:

- 기존 `userID` 대신 `studyId`, `subjectId`를 포함해 전송하겠다고 답변
- 필드는 `csvfile`, `battery`, `timestamp`, `studyId`, `subjectId` 총 5개로 이해했다고 확인
- 신규 엔드포인트 URL과 성공/실패 응답 형식 요청

### Q2. 인증 방식

Q2에서 `(b) Dct-Session-Id`, `(c) API Key/Bearer Token`을 물어본 것은 우리 쪽에 해당 구현이 있어서가 아니라, 베데스다 서버에 이미 적용된 인증 체계가 있을 수 있어 강건하게 확인한 것입니다.

베데스다 측은 `(b)`, `(c)` 방식이 구현된 적 없다고 답했습니다. 우리 쪽도 기존 강원대 서버와 동일한 `(a) 무인증 multipart POST` 방식이 가장 익숙하므로, 1차 PPG 데이터 수집은 무인증 방식으로 계속 진행하겠다고 회신하면 됩니다.

### Q3. 사용자 식별자

기존 강원대 서버에서는 `userID`에 authCode 예: `AA00`를 넣었습니다. 베데스다 전환 후에는 `userID/authCode`가 아니라 `studyId`, `subjectId`가 핵심 식별자입니다.

따라서 `Sensor_monitor`도 기존 로그인 ID 하나만 저장하는 구조에서 Study ID와 Subject ID를 저장하는 구조로 바뀌어야 합니다.

### Q4. 적재 확인

우리 쪽 의도는 로그 조회 API를 새로 요청하는 것이 아니라, 테스트 전송 후 데이터가 정상 적재되었는지만 베데스다 담당자분이 확인해주시면 된다는 의미입니다.

회신에서는 “별도 조회 API 구현까지 요청드리는 것은 아니고, 초기 연동 테스트 시 정상 적재 여부만 확인해주시면 충분합니다”라고 정리하면 됩니다.

## 3. Study ID / Subject ID를 어디서 얻는지

베데스다 측이 언급한 바코드 기능은 `pbcr_source`에 QR 스캔 흐름으로 구현되어 있습니다. QR 코드 안에 JSON 문자열이 들어 있고, 앱이 이 JSON에서 Study ID와 Subject ID를 꺼냅니다.

관련 파일:

- `pbcr_source/lib/3_view/login/qr/qr_scan_view_model.dart`
- `pbcr_source/lib/0_data/dto/auth/qr_scan_result_res.dart`
- `pbcr_source/lib/3_view/login/login_view_model.dart`
- `pbcr_source/lib/2_repository/pref_repository.dart`

QR 데이터 DTO:

```dart
@JsonKey(name: 'stdy_no')
final String studyNo;

@JsonKey(name: 'subject_id')
final String subjectId;
```

로그인 화면 반영 코드:

```dart
tcProjectId.text = qrScanResult.studyNo;
tcSubjectId.text = qrScanResult.subjectId;
```

동작 흐름:

1. 로그인 화면에서 QR 코드 스캔 버튼을 누름
2. `QrScanViewModel`이 카메라로 QR 코드 문자열을 읽음
3. QR 문자열이 JSON인지 검사
4. JSON이면 `QrScanResultRes.fromJson(json)`으로 파싱
5. `stdy_no` -> `studyNo`, `subject_id` -> `subjectId`로 매핑
6. 로그인 화면의 프로젝트 ID / 대상자 ID 입력칸에 자동 입력
7. SharedPreferences에 `login_project_id`, `login_subject_id`로 저장
8. 로그인 성공 후 `PrefRepository`에 `PREF_KEY_PROJECT_ID`, `PREF_KEY_SUBJECT_ID`로 저장

예상 QR JSON 형태:

```json
{
  "stdy_no": "T200006",
  "subject_id": "SUBJ001",
  "organ_cd": "ORG001",
  "pat_name": "ABC"
}
```

즉, 베데스다 서버로 보낼 `studyId`, `subjectId`는 QR 코드 안의 `stdy_no`, `subject_id` 값으로 이해하면 됩니다.

`Sensor_monitor` 적용 방법은 두 가지입니다.

1. 빠른 구현: 로그인 화면에 Study ID, Subject ID 입력칸을 추가해 수동 입력
2. 운영 친화 구현: `pbcr_source`처럼 QR 스캔 기능을 추가해 자동 입력

베데스다 담당자분이 해당 기능을 언급했으므로 장기적으로는 2번이 더 적합합니다. 다만 현재 `Sensor_monitor`에는 QR/바코드 라이브러리가 없으므로 의존성 추가와 카메라 권한 처리가 필요합니다.

현 시점에서는 QR 스캔 기능까지 바로 구현하기보다, 베데스다 측에 테스트용으로 사용할 수 있는 남는 `studyId`, `subjectId` 한 쌍을 요청하고 앱에 임시 하드코딩해서 엔드포인트 연동을 먼저 검증하는 것이 현실적입니다. 이후 서버 전송이 안정화되면 QR 스캔 또는 수동 입력 저장 구조를 추가하는 순서가 좋습니다.

## 4. 현재 코드 기준 수정 포인트

### 현재 업로드 URL

파일:

- `Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt`

현재 값:

```kotlin
private const val REQUEST_URL = "http://114.70.120.121:443/forUser/postCurrentData/"
```

베데스다 신규 엔드포인트가 확정되면 `https://icreatdct.btsd.io/...` 경로로 변경해야 합니다.

### 현재 multipart 전송 코드

현재 앱:

```kotlin
.addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
.addFormDataPart("userID", userID)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

베데스다 전환 후보:

```kotlin
.addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
.addFormDataPart("studyId", studyId)
.addFormDataPart("subjectId", subjectId)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

### 현재 업로드 호출부

파일:

- `Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/service/AcceptService.kt`

현재는 `DeviceInfo._uID`를 `userID`로 보내고 있습니다.

```kotlin
val userID = DeviceInfo._uID
ServerConnection.postFile(destFile, userID, battery, epochTime.toString()) { ... }
```

변경 후에는 `DeviceInfo._studyId`, `DeviceInfo._subjectId` 또는 별도 저장소에서 값을 읽어 보내야 합니다.

## 5. 기존 Python 서버 및 공유 자료 정리

베데스다에 설명할 때, 기존 강원대 서버는 Python 기반으로 구성되어 있다고 안내하는 것이 좋습니다. 현재 확인된 수신 엔드포인트는 Python Django REST Framework 코드이며, `MultiPartParser`로 `multipart/form-data` 요청을 받습니다.

베데스다에서 요청한 “기존 샘플이나 multipart/form-data 쪽 Java 소스”에 대해 확인한 결과, 실제 Java 서버 소스는 없고 다음 자료가 공유 가능합니다.

- Android Kotlin/OkHttp multipart 전송 코드
- Python/Django multipart 수신 코드
- `Sensor_monitor/sensor_data.zip` 샘플 센서 데이터 압축 파일

Android Kotlin 코드는 Java와 동일한 OkHttp 계열이라 베데스다 측에서 Java 구현 시 참고하기 좋습니다.

### 5.1 Android/Kotlin multipart 전송 코드

파일:

- `Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt`

핵심 코드:

```kotlin
fun postFile(file: File, userID: String, battery: String, timestamp: String, onResult: (Boolean) -> Unit) {
    val requestBody = MultipartBody.Builder()
        .setType(MultipartBody.FORM)
        .addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
        .addFormDataPart("userID", userID)
        .addFormDataPart("battery", battery)
        .addFormDataPart("timestamp", timestamp)
        .build()

    val request = Request.Builder().url(REQUEST_URL).post(requestBody).build()
    client.newCall(request).enqueue(...)
}
```

### 5.2 기존 강원대 서버 multipart 수신 코드

파일:

- `SLBM_hyuk-main_0730/forSurvey/DMF_ver3/forUser/views.py`

핵심 코드:

```python
@api_view(['POST'])
@parser_classes([MultiPartParser])
@csrf_exempt
def postCurrentData(request):
    file_ = request.FILES['csvfile']
    data = request.POST
    userID = data.get('userID')
    battery = data.get('battery')
    timestamp = data.get('timestamp')
```

서버는 `csvfile`을 파일로 받고 나머지 필드는 `request.POST`에서 읽습니다. 파일은 `/mnt/ssd1/wearables/uploads/{userID}/{dd_mm_yyyy}/` 하위에 저장합니다.

기존 서버 기술 스택 설명:

- 언어: Python
- 프레임워크: Django REST Framework
- multipart 처리: `MultiPartParser`
- 인증: `@csrf_exempt`, 별도 토큰 인증 없음
- 파일 필드 접근: `request.FILES['csvfile']`
- 메타 필드 접근: `request.POST`

### 5.3 기존 명세 문서

파일:

- `SLBM_hyuk-main_0730/SERVICES.md`

기존 강원대 규격:

| 필드명 | 타입 | 설명 |
|---|---|---|
| `csvfile` | file | 워치에서 수집된 CSV 파일 |
| `userID` | string | 기존 authCode |
| `battery` | form field | 배터리 잔량. 현재 앱에서는 multipart 일반 form field로 전달하며, 값은 워치에서 받은 배터리 숫자값을 그대로 사용 |
| `timestamp` | string | Unix epoch 초 단위 |

베데스다 전환 규격 후보:

| 필드명 | 타입 | 설명 |
|---|---|---|
| `csvfile` | file | 워치에서 수집된 CSV 파일 |
| `studyId` | string | 베데스다 Study ID |
| `subjectId` | string | 베데스다 Subject ID |
| `battery` | form field | 배터리 잔량. 현재 앱에서는 multipart 일반 form field로 전달하며, 값은 워치에서 받은 배터리 숫자값을 그대로 사용 |
| `timestamp` | string | Unix epoch 초 단위 |

### 5.4 샘플 센서 데이터

새로 업로드된 샘플 압축 파일이 확인되었습니다.

파일:

- `Sensor_monitor/sensor_data.zip`

압축 파일 내용:

- 총 175개 엔트리
- `sensor_data/logs/app_debug_log_*.txt`
- `sensor_data/HeartRate/*.csv`
- `sensor_data/Light/*.csv`
- `sensor_data/Accelerometer/*.csv`
- `sensor_data/Gyroscope/*.csv`
- 각 센서 폴더 하위 `sended/`에 30분 병합 전송 샘플 CSV 포함

확인된 샘플 예:

| 파일 | 크기 |
|---|---:|
| `sensor_data/HeartRate/HeartRate_260330_190548.csv` | 6,713 bytes |
| `sensor_data/Light/Light_260330_190548.csv` | 30,925 bytes |
| `sensor_data/Accelerometer/Accelerometer_260330_190548.csv` | 88,461 bytes |
| `sensor_data/Gyroscope/Gyroscope_260330_190548.csv` | 100,634 bytes |
| `sensor_data/HeartRate/sended/HeartRate_260330_1430.csv` | 12,994 bytes |

따라서 베데스다에는 이 ZIP을 샘플 센서 데이터로 공유하면 됩니다. 특히 `sended/` 하위 파일은 실제 업로드 대상으로 쓰이는 30분 병합 CSV 샘플이라 엔드포인트 테스트에 더 적합합니다.

센서별 CSV 컬럼:

| 센서 | 컬럼 |
|---|---|
| Accelerometer | `time,x,y,z` |
| Gravity | `time,x,y,z` |
| Gyroscope | `time,x,y,z` |
| HeartRate | `time,value` |
| Light | `time,value` |
| PpgGreen | `time,value` |
| StepCount | `time,value` |

예시:

```csv
time,value
1778567400000,82
1778567401000,83
```

## 6. 베데스다 회신 초안

```text
안녕하세요.
회신 감사합니다.

말씀 주신 대로 1차 구현은 기존 강원대 서버 연동과 동일하게 인증 없이 multipart/form-data 방식으로 진행하겠습니다.
저희가 Dct-Session-Id나 API Key 방식을 문의드린 것은 베데스다 서버에 이미 적용된 인증 체계가 있을 가능성을 고려해 확인드린 것이고, 저희 쪽도 우선은 익숙한 무인증 방식으로 PPG 데이터 수집 연동에 집중하겠습니다.

필드 구성은 기존 userID 대신 studyId, subjectId를 사용하는 방향으로 이해했습니다.
다만 구현 전 아래 5개 필드명으로 구성하면 되는지 한 번만 확인 부탁드립니다.

1. csvfile: CSV 파일
2. battery: 워치 배터리 잔량. 현재 앱에서는 multipart 일반 form field로 전달하며, 값은 워치에서 받은 배터리 숫자값을 그대로 사용
3. timestamp: 전송 시각, Unix epoch 초 단위 문자열
4. studyId: Study ID
5. subjectId: Subject ID

그리고 신규 엔드포인트 URL과 성공/실패 응답 코드 및 응답 body 형식도 확정되면 공유 부탁드립니다.

또한 Study ID / Subject ID는 최종적으로는 말씀 주신 QR 코드 스캔 방식으로 앱에 매칭하는 구조가 맞다고 이해했습니다.
다만 현재 단계에서는 CSV 업로드 엔드포인트 연동을 먼저 검증해야 해서, QR 스캔 기능까지 바로 구현하기는 어려울 것 같습니다.
추후 QR 스캔 기능을 추가하기 전까지 임시로 앱에 하드코딩해서 사용할 수 있는 테스트용 Study ID와 Subject ID 값을 하나 제공해주실 수 있을까요?
실운영 대상자가 아닌 테스트용 또는 사용하지 않는 값이면 됩니다.

기존 강원대 서버 전송 규격과 Sensor_monitor의 OkHttp multipart Kotlin 소스는 정리해서 공유드리겠습니다.
샘플 센서 데이터는 Sensor_monitor의 sensor_data.zip으로 준비되어 있어 함께 공유드리겠습니다. 해당 압축 파일에는 센서별 CSV와 실제 전송 대상인 sended 폴더의 30분 병합 CSV가 포함되어 있습니다.
현재 앱은 센서 데이터를 약 5분 단위 CSV 조각으로 저장하고, 매시 00분/30분에 센서별 조각 파일을 30분 단위 CSV로 병합한 뒤 서버 전송을 시도합니다. 서버가 HTTP 200 성공 응답을 주면 병합 CSV를 sended 폴더로 이동하고 병합에 사용된 원본 조각 CSV를 삭제합니다. 실패 응답이나 네트워크 오류가 발생하면 실패한 병합 CSV는 삭제하고 원본 조각 CSV는 보존하여, 다음 전송 시점에 다시 병합 후 전송을 재시도할 수 있도록 합니다.

Q4에서 말씀드린 적재 확인은 별도 로그 조회 API 구현을 요청드린 의미는 아니었습니다.
초기 연동 테스트 시 저희가 전송한 CSV가 베데스다 서버 측에 정상 적재되었는지만 담당자분께서 확인해주시면 충분합니다.

감사합니다.
```

## 7. 우선순위

1. 베데스다에 5개 필드명과 신규 URL 확정 요청
2. 테스트용 Study ID / Subject ID 제공 요청
3. `Sensor_monitor`에 테스트용 Study ID / Subject ID 임시 하드코딩
4. 추후 QR 스캔 또는 수동 입력 저장 구조 추가
5. multipart 업로드 필드 수정
6. curl 단독 검증
7. 30분 주기 실제 앱 종단간 테스트

## 8. 주의 사항

`Sensor_monitor`만 수정하면 끝나는 작업은 아닙니다. 베데스다 서버의 신규 엔드포인트가 준비되어야 실제 테스트가 가능합니다.

Study ID / Subject ID를 잘못 매칭하면 여러 과제 데이터가 섞일 수 있으므로, 기존 `userID`보다 식별자 검증이 더 중요합니다. QR 스캔을 적용하면 수동 입력 오류를 줄일 수 있습니다.
