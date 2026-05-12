# 2026-05-13 과제 미팅 보고 계획

## 1. 발표 목표

이번 보고의 핵심은 `Sensor Monitor` 앱의 기존 CSV 업로드 구조를 베데스다 iCReaT DCT 서버에 맞춰 전환하기 위한 사전 정리와 협의 진행 상황을 공유하는 것입니다.

강조할 메시지는 세 가지입니다.

1. 기존 앱/서버의 CSV 업로드 구조를 코드 기준으로 확인했다.
2. 베데스다 측 답변을 바탕으로 필요한 변경사항을 정리했다.
3. 바로 구현 가능한 부분과 베데스다 확인이 필요한 부분을 분리했다.

## 2. 발표 흐름

### 1분: 배경 설명

기존 `Sensor Monitor` 앱은 강원대 서버로 센서 CSV 파일을 전송하고 있었고, 이번 작업은 이 전송 대상을 베데스다 iCReaT DCT 서버로 전환하는 것입니다.

기존 방식은 `multipart/form-data` 기반이며, 앱에서 CSV 파일과 함께 `userID`, `battery`, `timestamp`를 전송하고 있었습니다.

### 2분: 베데스다 회신 내용 요약

베데스다 측에서는 CSV 업로드 엔드포인트를 추가해주겠다고 답변했습니다.

다만 iCReaT는 여러 과제에서 운영되기 때문에 기존 `userID` 하나만으로는 부족하고, `studyId`, `subjectId`가 추가로 필요하다고 했습니다.

따라서 현재 이해한 전송 필드는 아래 5개입니다.

1. `csvfile`
2. `battery`
3. `timestamp`
4. `studyId`
5. `subjectId`

메일에서는 필드명 철자까지 포함해 다시 확인 요청할 예정입니다.

### 2분: 인증 방식 정리

처음에는 혹시 베데스다 서버에 이미 세션 헤더나 API Key 방식이 있을 수 있어 `Dct-Session-Id`, API Key, Bearer Token 가능성을 확인했습니다.

베데스다 측 답변상 해당 방식은 아직 구현되어 있지 않다고 했고, 우리 쪽도 기존 서버와 동일한 무인증 `multipart/form-data` 방식이 가장 익숙합니다.

따라서 1차 목표는 인증 구현이 아니라 PPG를 포함한 센서 데이터 업로드 연동을 먼저 성공시키는 것입니다.

### 3분: 코드 기준 확인 내용

모바일 앱 쪽에서는 OkHttp `MultipartBody.FORM`으로 파일을 전송하고 있습니다.

현재 앱 전송 코드의 핵심은 다음 구조입니다.

```kotlin
.addFormDataPart("csvfile", file.name, ...)
.addFormDataPart("userID", userID)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

베데스다 전환 시에는 아래 형태로 바꾸면 될 것으로 보고 있습니다.

```kotlin
.addFormDataPart("csvfile", file.name, ...)
.addFormDataPart("studyId", studyId)
.addFormDataPart("subjectId", subjectId)
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

기존 서버는 Java가 아니라 Python/Django REST Framework 기반이었고, `MultiPartParser`로 `request.FILES['csvfile']`, `request.POST`를 읽는 구조였습니다.

### 3분: 센서 CSV 생성/전송 흐름 설명

앱은 워치에서 받은 센서 데이터를 약 5분 단위 CSV 조각으로 저장합니다.

매시 00분/30분에 센서별 조각 CSV를 하나의 30분 단위 CSV로 병합하고, 이 병합 CSV를 서버로 전송합니다.

응답 처리 흐름은 아래처럼 정리했습니다.

1. 서버가 HTTP 200을 반환하면 업로드 성공으로 판단
2. 성공한 병합 CSV는 `sended` 폴더로 이동
3. 병합에 사용된 원본 조각 CSV는 삭제
4. 실패하면 병합 CSV는 삭제
5. 원본 조각 CSV는 보존해서 다음 00분/30분에 다시 병합/재전송

이 구조로 바꿔야 `sended` 폴더가 “서버 전송 성공 파일 보관 위치”라는 의미를 명확히 가질 수 있습니다.

### 2분: Study ID / Subject ID 처리 계획

베데스다 측은 기존 앱에 QR 코드로 Study ID와 Subject ID를 매칭하는 기능이 있다고 안내했습니다.

`pbcr_source`를 확인한 결과 QR 코드 JSON에서 아래 값을 읽는 구조였습니다.

- `stdy_no` -> Study ID
- `subject_id` -> Subject ID

다만 현재 `Sensor Monitor`에 QR 스캔 기능을 바로 추가하려면 카메라 권한, QR 라이브러리, UI 수정이 필요합니다.

그래서 1차 연동 테스트에서는 베데스다 측에 테스트용 Study ID / Subject ID 한 쌍을 요청하고, 앱에 임시 하드코딩해서 업로드 검증을 먼저 진행하려고 합니다.

QR 스캔 기능은 업로드 연동이 안정화된 뒤 추가하는 순서가 현실적입니다.

### 2분: 샘플 데이터 준비 현황

`Sensor_monitor/sensor_data.zip` 샘플 데이터를 준비했습니다.

구성은 대략 아래와 같습니다.

- 전체 엔트리 175개
- CSV 파일 172개
- `sended` 폴더 내 30분 병합 CSV 143개
- 로그 파일 3개
- 포함 센서: `PpgGreen`, `HeartRate`, `Accelerometer`, `Gyroscope`, `Gravity`, `Light`, `StepCount`

베데스다 측 엔드포인트 테스트에는 각 센서 폴더의 `sended` 하위 CSV를 샘플로 쓰면 됩니다.

### 2분: 현재 정리한 산출물

현재 정리한 문서는 아래와 같습니다.

- `bethesda_email_draft.md`: 베데스다 담당자에게 보낼 회신 메일 초안
- `bethesda_multipart_reference.md`: multipart 전송/수신 및 샘플 데이터 부연 설명
- `bethesda_csv_upload_reply_analysis.md`: 베데스다 회신 분석 및 수정 포인트 보고서

코드 쪽에서는 CSV 전송 성공/실패 후 파일 이동 로직도 정리했습니다.

## 3. 다음 진행 계획

1. 베데스다에 회신 메일 발송
2. 신규 업로드 엔드포인트 URL과 응답 형식 수신
3. 테스트용 Study ID / Subject ID 수신
4. `Sensor Monitor` 앱의 전송 URL과 필드 수정
5. curl 또는 Postman으로 단독 업로드 테스트
6. 앱 디버그 빌드로 실제 00분/30분 주기 업로드 테스트
7. 베데스다 담당자와 서버 적재 여부 확인
8. 이후 QR 스캔 또는 수동 입력 방식으로 Study/Subject 매칭 기능 추가

## 4. 미팅에서 확인받으면 좋은 질문

1. 1차 연동은 무인증 방식으로 진행해도 되는지
2. Study ID / Subject ID를 임시 하드코딩해서 먼저 테스트하는 방향에 동의하는지
3. QR 스캔 기능은 1차 업로드 연동 이후 후순위로 두어도 되는지
4. 베데스다 측에 샘플 CSV 전체 ZIP을 공유해도 되는지
5. 서버 성공 응답은 HTTP 200 기준으로 요청해도 되는지

## 5. 발표 톤

너무 세부 코드 설명에 오래 머무르기보다, 아래 톤으로 말하는 것이 좋습니다.

“기존 앱의 전송 구조와 기존 서버 수신 구조를 코드 기준으로 확인했고, 베데스다 측 답변을 반영하면 필드 변경과 Study/Subject 식별자 처리가 핵심입니다. QR 기능은 최종적으로 필요하지만, 1차 목표는 테스트용 식별자를 받아 업로드 엔드포인트를 먼저 검증하는 것입니다.”

## 6. 예상 질문과 답변

Q. 왜 QR 스캔을 바로 구현하지 않나요?  
A. QR 스캔은 카메라 권한, 라이브러리, UI 흐름 수정이 필요합니다. 업로드 엔드포인트 연동 자체가 먼저 검증되어야 하므로, 1차 테스트는 하드코딩된 테스트용 Study/Subject ID로 진행하고 이후 QR 기능을 붙이는 것이 리스크가 낮습니다.

Q. `sended` 폴더는 어떤 의미인가요?  
A. 서버 전송에 성공한 30분 단위 병합 CSV를 보관하는 위치입니다. 실패 시에는 병합본을 삭제하고 원본 조각 CSV를 보존해서 다음 전송 시점에 재병합/재전송할 수 있게 정리했습니다.

Q. 성공 응답은 무엇을 기준으로 하나요?  
A. 앱 코드는 OkHttp `response.isSuccessful`을 쓰기 때문에 기술적으로 HTTP 200~299를 성공으로 보지만, 기존 서버와 맞추기 위해 베데스다에는 성공 시 HTTP 200 반환을 요청할 예정입니다.

Q. 배터리 값은 문자열인가요, 숫자인가요?  
A. 워치에서 받은 배터리 숫자값을 앱이 multipart 일반 form field로 전송합니다. 서버에서는 숫자값으로 파싱해서 저장하면 됩니다.

