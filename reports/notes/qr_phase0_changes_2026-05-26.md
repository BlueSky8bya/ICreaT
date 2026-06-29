# Sensor Monitor – 베데스다 업로드 전환(Phase 0) 코드 수정 보고서

- 작성일: 2026-05-26
- 대상: Sensor_monitor (가천대 HCI Lab, Android/Kotlin)
- 목적: **내일 오후 베데스다 신규 multipart 엔드포인트 연동 테스트**에 맞춰, 앱 전송 규격을
  `userID` 단일 식별자 → `studyId` + `subjectId`로 전환하고, 무인증(a) 정책에 맞게 로그인 단계를 우회.
- 범위: QR 스캔 도입 전 단계(Phase 0). studyId/subjectId는 임시 하드코딩으로 검증하고,
  추후 Phase 1에서 QR 스캔 값으로 대체.

---

## 1. 메일 합의 → 코드 반영 매핑

| 베데스다/가천대 합의 (2026-05-12) | 코드 반영 |
|---|---|
| multipart 필드: csvfile, **studyId, subjectId**, battery, timestamp | `postFile` 멀티파트 필드 교체 (②) |
| 기존 `userID` 제거 | 전 구간에서 studyId/subjectId로 치환 (①②③) |
| 무인증(a), 로그인/세션 API 없음 | 네트워크 로그인 제거, 바로 진입 (②④) |
| timestamp = Unix epoch 초 | 기존 `epochTime`(초) 유지 |
| 성공 = HTTP 200 | OkHttp `response.isSuccessful`(2xx) 그대로 사용 |
| QR 도입 전 임시 하드코딩 테스트값 | `DeviceInfo.TEST_STUDY_ID / TEST_SUBJECT_ID` (①) |

---

## 2. 수정한 파일 (5개)

### ① DeviceInfo.kt — 식별자 필드 전환
[common/DeviceInfo.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/DeviceInfo.kt)
- `_uID` 제거 → `_studyId`, `_subjectId` 신설.
- `lateinit var` → 기본값 있는 `var`로 변경하여 미초기화 크래시 방지.
- 테스트용 하드코딩 상수 추가:
  ```kotlin
  const val TEST_STUDY_ID = "TEST_STUDY"        // ← 베데스다 제공값으로 교체
  const val TEST_SUBJECT_ID = "TEST_SUBJECT"    // ← 베데스다 제공값으로 교체
  ```
- `init(deviceID, studyId, subjectId, battery)` 시그니처로 변경. `setStudyId/setSubjectId` 추가.

### ② ServerConnection.kt — 전송 규격·URL·로그인 우회
[common/ServerConnection.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt)
- `REQUEST_URL`을 신규 **HTTPS** 플레이스홀더로 교체 (구 강원대 `http://114.70.120.121:443/...` 제거):
  ```kotlin
  // 담당자 확정값으로 교체. 예: https://icreatdct.btsd.io/api/sensor/uploadCsv
  private const val REQUEST_URL = "https://icreatdct.btsd.io/REPLACE_WITH_BETHESDA_ENDPOINT"
  ```
- 기존 네트워크 `login()`(구 서버 `registUser` 호출) **제거** → `enterSensor()`로 대체.
  베데스다는 로그인 API가 없으므로 네트워크 호출 없이 SensorActivity로 진입(studyId/subjectId extra 전달).
- `postFile` 멀티파트 필드 변경:
  ```kotlin
  // 변경 전
  .addFormDataPart("userID", userID)
  // 변경 후
  .addFormDataPart("studyId", studyId)
  .addFormDataPart("subjectId", subjectId)
  ```
  시그니처: `postFile(file, studyId, subjectId, battery, timestamp, onResult)`

### ③ AcceptService.kt — 30분 사이클 업로드 호출부
[service/AcceptService.kt:248](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/service/AcceptService.kt#L248)
- `DeviceInfo._uID` → `_studyId`, `_subjectId` 사용.
- `postFile(...)` 호출 인자 5개로 변경, 업로드 로그에 STUDY/SUBJECT 표기.

### ④ LoginActivity.kt — 로그인 단계 우회
[activity/LoginActivity.kt:145](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/activity/LoginActivity.kt#L145)
- 로그인 버튼이 네트워크 `login()` 대신 `ServerConnection.enterSensor(deviceID, context=this)` 호출.
- 권한/배터리 최적화 가이드(1~3단계) 로직은 그대로 유지.

### ⑤ SensorActivity.kt — 진입 시 식별자 주입
[activity/SensorActivity.kt:52](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/activity/SensorActivity.kt#L52)
- `DeviceInfo.init`을 새 시그니처에 맞춰 `studyId`/`subjectId` extra로 초기화(누락 시 테스트 하드코딩 값 fallback).

> ①·④와 강하게 결합되어 함께 수정. 그 외 파일/로직(병합·재전송·sended 이동)은 변경 없음.

---

## 3. 전송 페이로드 (변경 전 → 후)

```
[변경 전]  POST http://114.70.120.121:443/forUser/postCurrentData/
  multipart: csvfile, userID, battery, timestamp

[변경 후]  POST https://icreatdct.btsd.io/<신규 경로>
  multipart: csvfile, studyId, subjectId, battery, timestamp
```

---

## 4. 내일 테스트 전 "값만 끼우면 되는" 항목 (베데스다 회신 필요)

1. **엔드포인트 URL** → `ServerConnection.REQUEST_URL`의 `REPLACE_WITH_BETHESDA_ENDPOINT` 교체
2. **테스트용 studyId / subjectId** → `DeviceInfo.TEST_STUDY_ID / TEST_SUBJECT_ID` 교체
3. **성공/실패 응답코드·body 규격** 확인 (성공 200 가정, isSuccessful로 처리 중)

## 5. 테스트 절차

1. (값 수신 후) curl 단독 검증:
   ```bash
   curl -i -X POST "https://icreatdct.btsd.io/<신규 경로>" \
     -F "csvfile=@PpgGreen_260511_1430.csv;type=text/csv" \
     -F "studyId=<테스트값>" -F "subjectId=<테스트값>" \
     -F "battery=87" -F "timestamp=$(date +%s)"
   ```
   샘플 CSV는 `sensor_data.zip`의 각 센서 `sended/` 하위 파일 사용.
2. 위 1·2번 값 반영 후 디버그 빌드 → 로그인 버튼 진입 → 30분 사이클(또는 수동 트리거) 종단간 전송.
3. 앱 로그 `[UPLOAD] 전송 성공` 및 베데스다 로그 테이블 적재 확인(담당자 협조, Q4).

## 6. 비고 / 잔여 작업

- 자동 로그인 캐시(`login.txt`)는 `studyId|subjectId` 형태로 저장하나, Phase 0에서는 진입 게이트로만 사용.
- 미사용 import(ServerConnection의 SimpleDateFormat/Date/Locale, LoginActivity의 Toast/CacheManager)는
  컴파일 경고 수준이며 기능 영향 없음. Phase 1 정리 예정.
- **Phase 1(차기)**: ZXing 등 QR 라이브러리 + CAMERA 권한 + QrScanActivity 추가.
  QR(JSON `{stdy_no, subject_id, ...}`) 스캔 결과를 `enterSensor(studyId, subjectId)`에 전달 → 하드코딩 제거.
- 인증(b/c, Dct-Session-Id·API Key)은 후속 논의. 전송부에 헤더 추가가 쉬운 구조로 유지.
