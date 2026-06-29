# 베데스다 회신 메일 초안

안녕하세요.  
회신 감사합니다.

말씀 주신 대로 1차 구현은 기존 서버 연동과 동일하게 인증 없이 `multipart/form-data` 방식(a)으로 진행하겠습니다.  
저희가 `Dct-Session-Id`(b)나 API Key(c) 방식을 문의드린 것은 베데스다 서버에 이미 적용된 인증 체계가 있을 가능성을 고려해 확인드린 것이니, 저희 쪽도 우선은 익숙한 무인증 방식으로 PPG를 포함한 여러 데이터 수집 연동에 집중하겠습니다.

필드 구성은 기존 `userID` 대신 `studyId`, `subjectId`를 사용하는 방향으로 이해했습니다.  
구현 전 아래 5개 필드명으로 구성하면 되는지 철자 포함하여 한 번만 확인 부탁드립니다.

1~3은 기존 필드이고, 4~5는 요청 주신 Study/Subject 식별자 필드입니다.

1. `csvfile`: CSV 파일
2. `battery`: 워치 배터리 잔량. 현재 앱에서는 multipart 일반 form field로 전달하며, 값은 워치에서 받은 배터리 숫자값을 그대로 사용
3. `timestamp`: 전송 시각, Unix epoch 초 단위 문자열
4. `studyId`: Study ID
5. `subjectId`: Subject ID

그리고 신규 엔드포인트 URL과 성공/실패 응답 코드 및 응답 body 형식도 확정되면 공유 부탁드립니다.

또한 Study ID / Subject ID는 최종적으로 말씀 주신 QR 코드 스캔 방식으로 앱에 매칭하는 구조가 맞다고 이해했습니다.  
다만 현재 단계에서는 CSV 업로드 엔드포인트 연동을 먼저 검증해야 하므로, QR 스캔 기능을 추가하기 전까지 임시로 앱에 하드코딩해서 사용할 수 있는 테스트용 Study ID와 Subject ID 값을 하나 제공해주실 수 있을까요?  
실운영 대상자가 아닌 테스트용 또는 사용하지 않는 값이면 됩니다.

기존 서버 전송 규격과 Sensor Monitor 모바일 앱의 OkHttp multipart Kotlin 소스는 아래와 같이 간단히 정리드립니다.  
기존 서버는 Java가 아니라 Python/Django REST Framework 기반이며, 모바일 앱은 OkHttp의 `MultipartBody.FORM`으로 CSV 파일과 메타 필드를 함께 전송하고 있습니다.

현재 모바일 앱의 전송 필드는 아래와 같습니다.

```kotlin
.addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
.addFormDataPart("userID", userID)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

베데스다 전환 시에는 아래 형태로 변경하면 되는 것으로 이해하고 있습니다.

```kotlin
.addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
.addFormDataPart("studyId", studyId)
.addFormDataPart("subjectId", subjectId)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

기존 Python 서버에서는 Django REST Framework의 `MultiPartParser`로 아래와 같이 수신하고 있습니다.

```python
file_ = request.FILES['csvfile']
data = request.POST
userID = data.get('userID')
battery = data.get('battery')
timestamp = data.get('timestamp')
```

현재 모바일 앱 코드는 OkHttp의 `response.isSuccessful` 값으로 성공 여부를 판단하고 있습니다.  
OkHttp 기준으로는 HTTP 200~299 응답이 성공으로 처리되지만, 기존 서버 규격과 맞추기 위해 베데스다 서버에서도 업로드 성공 시에는 HTTP 200을 반환해주시는 형태가 가장 명확할 것 같습니다.  
HTTP 400 이상 응답 또는 네트워크 오류는 앱에서 실패로 처리됩니다.

샘플 센서 데이터는 Sensor Monitor의 `sensor_data.zip`으로 준비되어 있어 첨부드리니 확인 부탁드립니다.  
해당 압축 파일에는 센서별 CSV와 `sended` 폴더의 30분 병합 CSV가 포함되어 있습니다.

현재 앱의 CSV 생성/전송 흐름은 다음과 같습니다.

1. 워치에서 수신한 센서 데이터가 약 5분 단위 CSV 조각으로 저장됩니다.
2. 매시 00분/30분에 센서별 조각 CSV들을 하나의 30분 단위 CSV로 병합합니다.
3. 병합 CSV를 서버로 전송합니다.
4. 서버가 HTTP 200 성공 응답을 주면 병합 CSV를 `sended` 폴더로 이동하고, 병합에 사용된 원본 조각 CSV들을 삭제합니다.
5. 실패 응답 또는 네트워크 오류가 발생하면 실패한 병합 CSV는 삭제하고, 원본 조각 CSV는 보존합니다. 이후 다음 00분/30분 전송 시점에 보존된 조각 CSV와 새로 쌓인 조각 CSV를 다시 병합해 재전송을 시도합니다.

따라서 `sended` 폴더는 서버 전송이 성공한 30분 단위 병합 CSV가 보관되는 위치로 이해하시면 됩니다.  
첨부드린 샘플에는 `PpgGreen`, `HeartRate`, `Accelerometer`, `Gyroscope`, `Gravity`, `Light`, `StepCount` 등의 센서 CSV가 포함되어 있으며, 실제 엔드포인트 테스트에는 각 센서 폴더의 `sended` 하위 CSV를 참고하시면 됩니다.

또한 Q4에서 말씀드린 적재 확인은 별도 로그 조회 API 구현을 요청드린 의미는 아니었습니다.  
초기 연동 테스트 시 저희가 전송한 CSV가 베데스다 서버 측에 정상 적재되었는지만 담당자분께서 확인해주시면 충분합니다.

감사합니다.
