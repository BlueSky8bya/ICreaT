# 베데스다 메일 부연 설명: multipart 전송 및 샘플 데이터

작성일: 2026-05-12

## 1. 메일에 추가할 짧은 설명

기존 서버 전송 규격과 Sensor Monitor 모바일 앱의 OkHttp multipart Kotlin 소스는 아래와 같이 정리했습니다. 기존 서버는 Java가 아니라 Python/Django REST Framework 기반이며, 모바일 앱은 OkHttp의 `multipart/form-data` 방식으로 CSV 파일과 메타 필드를 함께 전송하고 있습니다.

샘플로 첨부드리는 `sensor_data.zip`에는 센서별 원본 CSV와 `sended` 폴더가 포함되어 있습니다. 현재 앱은 센서 데이터를 약 5분 단위 CSV 조각으로 저장하고, 매시 00분/30분에 센서별 조각 파일들을 하나의 30분 단위 CSV로 병합한 뒤 서버 전송을 시도합니다.

서버가 성공 응답을 주면 앱은 해당 업로드가 성공한 것으로 판단하고 병합 CSV를 `sended` 폴더로 이동한 뒤 병합에 사용된 원본 조각 CSV들을 삭제합니다. 실패 응답이거나 네트워크 오류가 발생하면 실패한 병합 CSV는 삭제하고 원본 조각 CSV는 보존합니다. 따라서 다음 전송 시점에는 보존된 조각 CSV와 새로 쌓인 조각 CSV를 다시 병합해 전송을 재시도할 수 있습니다. `sended` 폴더의 파일들은 서버 전송이 성공한 30분 단위 병합 CSV 샘플로 보시면 됩니다.

## 2. 현재 모바일 앱 전송 필드

파일:

- `Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt`

현재 필드:

| 필드명 | 설명 |
|---|---|
| `csvfile` | CSV 파일 |
| `userID` | 기존 사용자 식별자 |
| `battery` | 배터리 잔량. 현재 앱에서는 multipart 일반 form field로 전달하며, 값은 워치에서 받은 배터리 숫자값을 그대로 사용 |
| `timestamp` | 전송 시각. Unix epoch 초 단위 문자열 |

핵심 코드:

```kotlin
val requestBody = MultipartBody.Builder()
    .setType(MultipartBody.FORM)
    .addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
    .addFormDataPart("userID", userID)
    .addFormDataPart("battery", battery)
    .addFormDataPart("timestamp", timestamp)
    .build()
```

베데스다 전환 시에는 `userID` 대신 `studyId`, `subjectId`를 추가해 아래 형태로 바꾸는 것으로 이해하고 있습니다.

```kotlin
.addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
.addFormDataPart("studyId", studyId)
.addFormDataPart("subjectId", subjectId)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

## 3. 기존 서버 수신 방식

파일:

- `SLBM_hyuk-main_0730/forSurvey/DMF_ver3/forUser/views.py`

기존 서버는 Python/Django REST Framework의 `MultiPartParser`로 수신합니다.

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

기존 서버 응답은 모바일 앱에서 OkHttp의 `response.isSuccessful` 값으로 판정합니다. OkHttp 기준으로는 HTTP 200~299 응답이 성공으로 처리됩니다. 다만 기존 서버 규격과 맞추려면 업로드 성공 시 HTTP 200을 반환하는 형태가 가장 명확합니다. HTTP 400 이상 응답 또는 네트워크 오류는 앱에서 실패로 처리됩니다.

## 4. `sended` 폴더 동작 상세

관련 파일:

- `Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/service/AcceptService.kt`

동작 흐름:

1. 워치에서 수신한 센서 데이터가 센서별 CSV 조각으로 저장됩니다.
2. 앱의 타이머가 1분마다 현재 시간을 확인합니다.
3. 모바일과 워치가 연결된 상태에서 분 값이 `00` 또는 `30`이면 `sendCSV()`가 실행됩니다.
4. `sendCSV()`는 센서별 폴더의 CSV 조각들을 모아 30분 단위 병합 CSV를 생성합니다.
5. 앱은 생성된 병합 CSV를 서버로 업로드합니다.
6. 서버가 HTTP 200 성공 응답을 주면 병합 CSV를 같은 센서 폴더 하위의 `sended` 폴더로 이동합니다.
7. `sended` 이동까지 성공하면 병합에 사용된 원본 조각 CSV들을 삭제합니다.
8. 실패 응답 또는 네트워크 오류가 발생하면 실패한 병합 CSV는 삭제하고 원본 조각 CSV는 삭제하지 않고 보존합니다.

따라서 서버 개발/테스트 시에는 `sensor_data.zip` 안의 `sended` 하위 CSV를 전송 성공 상태의 30분 병합 샘플로 참고하시면 됩니다.

예시:

```text
sensor_data/PpgGreen/sended/PpgGreen_260330_1900.csv
sensor_data/HeartRate/sended/HeartRate_260330_1900.csv
sensor_data/Accelerometer/sended/Accelerometer_260330_1900.csv
```

## 5. 샘플 데이터 구성

첨부 파일:

- `Sensor_monitor/sensor_data.zip`

대략적인 구성:

| 항목 | 개수 |
|---|---:|
| 전체 엔트리 | 175 |
| CSV 파일 | 172 |
| `sended` 폴더 내 30분 병합 CSV | 143 |
| 로그 파일 | 3 |

포함 센서:

```text
Accelerometer
Gravity
Gyroscope
HeartRate
Light
PpgGreen
StepCount
```

단일 값 센서는 `time,value` 형식이고, 3축 센서는 `time,x,y,z` 형식입니다.
