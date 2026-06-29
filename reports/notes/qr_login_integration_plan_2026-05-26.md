# Sensor Monitor – QR 로그인(Study/Subject 매칭) 접목 보고서

- 작성일: 2026-05-26
- 대상: Sensor_monitor (가천대 HCI Lab, Android/Kotlin)
- 참조 앱: pbcr_source (iCReaT DCT, Flutter) – 베데스다 담당자(문외환)가 언급한 "작년에 개발된 바코드 매칭 앱"
- 근거 메일: 2026-05-12 베데스다 회신 + 가천대 회신 (Q1~Q4 합의)

---

## 1. 배경 및 목표

베데스다 측 회신(Q1)에서 iCReaT는 여러 과제에서 운영되므로 CSV 업로드 시
**Study ID / Subject ID가 필수**이며, 이 두 식별자는 작년 개발 앱처럼 **QR(바코드) 스캔으로
앱에 매칭**하는 구조를 권고받았다.

따라서 Sensor_monitor의 로그인/전송 구조를 다음과 같이 전환한다.

- 기존: 단일 `userID`(이메일·authCode) 입력 → multipart 필드 `userID`
- 변경: `studyId` + `subjectId`를 **QR 스캔으로 획득** → multipart 필드 `studyId`, `subjectId`

목표는 **(A) QR 스캔 기능 추가 전 임시 하드코딩으로 엔드포인트 검증**,
**(B) 검증 통과 후 QR 스캔 기반 매칭으로 정식 전환**의 2단계 진행이다.

---

## 2. 현황 분석

### 2.1 참조 앱(pbcr_source)의 QR 매칭 구조 — 그대로 차용할 "규격"

QR 스캔/파싱 로직은 [qr_scan_view_model.dart](pbcr_source/lib/3_view/login/qr/qr_scan_view_model.dart)와
[login_view_model.dart](pbcr_source/lib/3_view/login/login_view_model.dart)에 구현되어 있다. 핵심은 다음 3가지다.

1. **QR 내용은 JSON 문자열**이다. 파싱 실패(비-JSON)는 무시한다.
2. QR JSON 스키마는 [qr_scan_result_res.dart](pbcr_source/lib/0_data/dto/auth/qr_scan_result_res.dart) 기준:

   ```json
   {
     "stdy_no":     "<Study ID>",
     "subject_id":  "<Subject ID>",
     "organ_cd":    "<기관 코드>",
     "pat_name":    "<대상자명>"
   }
   ```

3. 스캔 성공 시 매핑은 `handleQrCode()`에서:
   - `projectId(Study) = stdy_no`
   - `subjectId        = subject_id`
   - SharedPreferences에 저장(다음 실행 시 자동 복원)

> 시사점: Sensor_monitor가 인식할 QR 포맷을 **위 JSON 스키마와 동일하게 맞추면**,
> iCReaT가 발급/출력하는 동일 QR을 두 앱이 공유할 수 있다. 베데스다와 별도 포맷 협의가 불필요해진다.
> (Sensor_monitor는 `stdy_no`, `subject_id` 두 필드만 사용하고 `organ_cd`, `pat_name`은 무시/표시용으로 처리)

### 2.2 Sensor_monitor 현재 구조 (전환 대상)

| 영역 | 현재 구현 | 위치 |
|---|---|---|
| 로그인 입력 | 단일 텍스트(이메일/authCode) 1개 | [LoginActivity.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/activity/LoginActivity.kt), [activity_login.xml](Sensor_monitor/app/src/main/res/layout/activity_login.xml) |
| 로그인 호출 | `ServerConnection.login(authcode, deviceID, …)` → 200이면 캐시 저장 후 SensorActivity 진입 | [ServerConnection.kt:32](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt#L32) |
| 식별자 보관 | `DeviceInfo._uID` (싱글톤), 자동로그인 캐시 `login.txt` | [DeviceInfo.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/DeviceInfo.kt), [CacheManager.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/CacheManager.kt) |
| 업로드 전송 | multipart: `csvfile`, `userID`, `battery`, `timestamp` | [ServerConnection.kt:82](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt#L82) |
| 업로드 호출부 | `DeviceInfo._uID` 사용 → `postFile(...)` | [AcceptService.kt:249](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/service/AcceptService.kt#L249) |
| 의존성 | OkHttp 3.10.0, minSdk 24, targetSdk 33. **QR/CameraX 라이브러리 없음, 카메라 권한 없음** | [app/build.gradle](Sensor_monitor/app/build.gradle) |

**차이점 요약:** 참조 앱은 Flutter(`qr_code_scanner_plus`)라 코드를 그대로 복사할 수는 없다.
**"QR=JSON 규격"과 "스캔 후 studyId/subjectId 채움" 흐름만 차용**하고, 구현은 Android 네이티브 라이브러리로 새로 작성한다.

---

## 3. 베데스다 합의 전송 규격 (이번 전환의 종착점)

메일 합의 기준 multipart/form-data 5개 필드(무인증, 성공 시 HTTP 200):

```kotlin
.addFormDataPart("csvfile", file.name, RequestBody.create(MediaType.parse("text/csv"), file))
.addFormDataPart("studyId", studyId)        // 신규
.addFormDataPart("subjectId", subjectId)    // 신규
.addFormDataPart("battery", battery)
.addFormDataPart("timestamp", timestamp)
```

- 기존 `userID` 필드는 제거.
- 엔드포인트 URL은 베데스다 확정 대기 (`https://icreatdct.btsd.io/<신규 경로>`). HTTP→**HTTPS** 전환.
- 단위/응답 body 형식은 베데스다 확정값에 맞춰 반영.

> ⚠️ 미확정 의존 항목: ① 신규 엔드포인트 URL, ② 성공/실패 응답코드·body, ③ 테스트용 studyId/subjectId 값.
> 이 보고서의 Phase 0/1 코드 작업은 위 3개 확정 전에도 병행 가능하나, 실제 연동 검증은 확정 후 진행.

---

## 4. 단계별 진행 방안

### Phase 0 — 임시 하드코딩으로 엔드포인트 단독 검증 (QR 추가 전)

목적: QR UI 작업과 무관하게 **베데스다 신규 multipart 엔드포인트가 동작하는지 먼저 검증**.

1. `DeviceInfo`에 `_studyId`, `_subjectId` 필드 추가, 베데스다가 제공할 **테스트용 값으로 하드코딩 초기화**.
2. `ServerConnection.postFile()`의 multipart를 §3 규격(studyId/subjectId)으로 교체, URL을 신규 HTTPS로 교체.
3. `AcceptService`의 호출부를 `userID` → `studyId/subjectId`로 교체.
4. (선택) `ServerConnection.login()`은 베데스다에 로그인 API가 없으므로 **무인증 정책상 호출 생략 또는 우회**.
   - 현재 자동 진입은 login 200에 의존하므로, Phase 0에서는 로그인 단계를 건너뛰고 바로 SensorActivity 진입하도록 임시 처리.
5. 검증: 디버그 빌드로 30분 사이클 1회 또는 수동 트리거 전송 → 200 수신 및 베데스다 측 로그 테이블 적재 확인(담당자 협조, Q4).

> Phase 0는 메일에서 가천대가 요청한 "QR 추가 전 임시 하드코딩 테스트용 studyId/subjectId" 시나리오와 정확히 일치한다.

### Phase 1 — QR 스캔 기반 매칭으로 정식 전환

1. **QR 라이브러리 추가** (§6).
2. **QrScanActivity 신설**: 카메라 미리보기 + QR 디코드 → §2.1 JSON 파싱 → `stdy_no`, `subject_id` 추출.
   - 참조 앱과 동일하게 **비-JSON QR은 무시**, 중복 콜백 방지 플래그 사용.
3. **LoginActivity 개편**: 단일 ID 입력 → "QR 스캔" 버튼 중심으로. 스캔 결과를
   `DeviceInfo._studyId/_subjectId`에 채우고 SharedPreferences/캐시에 저장(자동 복원).
4. 하드코딩 제거, Phase 0의 전송 코드는 그대로 재사용(값 출처만 하드코딩→QR로 변경).
5. 디버그 빌드 종단간 테스트(워치→앱→베데스다), 적재 확인.

---

## 5. Sensor_monitor 구체 변경 지점

| # | 파일 | 변경 내용 | Phase |
|---|---|---|---|
| 1 | [DeviceInfo.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/DeviceInfo.kt) | `_uID` → `_studyId`, `_subjectId`로 대체(또는 추가). `init()` 시그니처 수정 | 0 |
| 2 | [ServerConnection.kt:82](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt#L82) `postFile` | multipart 필드 `userID` 제거, `studyId`+`subjectId` 추가. `REQUEST_URL`을 신규 HTTPS로 | 0 |
| 3 | [AcceptService.kt:249](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/service/AcceptService.kt#L249) | `_uID` 참조 → `_studyId/_subjectId`로 교체, `postFile` 인자 변경 | 0 |
| 4 | [ServerConnection.kt:32](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/ServerConnection.kt#L32) `login` | 무인증 정책에 맞춰 로그인 단계 우회/제거 또는 단순 진입 처리 | 0 |
| 5 | 신규 `QrScanActivity.kt` + 레이아웃 | 카메라 프리뷰·QR 디코드·JSON 파싱(§2.1 스키마) | 1 |
| 6 | [LoginActivity.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/activity/LoginActivity.kt) / [activity_login.xml](Sensor_monitor/app/src/main/res/layout/activity_login.xml) | 단일 입력 UI → QR 스캔 버튼/결과 표시. 결과를 DeviceInfo·캐시에 저장 | 1 |
| 7 | [SensorActivity.kt:51](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/activity/SensorActivity.kt#L51) | `getStringExtra("ID")` → studyId/subjectId extra로 교체 | 1 |
| 8 | [CacheManager.kt](Sensor_monitor/app/src/main/java/com/gachon_HCI_Lab/user_mobile/common/CacheManager.kt) | `login.txt` 단일값 → studyId/subjectId(JSON 또는 2파일)로 확장 | 1 |
| 9 | [AndroidManifest.xml](Sensor_monitor/app/src/main/AndroidManifest.xml) | `CAMERA` 권한 + QrScanActivity 등록 | 1 |
| 10 | [app/build.gradle](Sensor_monitor/app/build.gradle) | QR 라이브러리 의존성 추가 | 1 |

---

## 6. 라이브러리/권한 (Phase 1)

- 현재 카메라 권한·QR 라이브러리 모두 없음. minSdk 24, targetSdk 33 호환 라이브러리 선택.
- 권장: **ZXing 계열** `com.journeyapps:zxing-android-embedded`
  (별도 스캔 액티비티 실행이 간단, 기존 OkHttp/UI 구조 변경 최소) 또는 **ML Kit Barcode Scanning**.
- 추가 권한: `android.permission.CAMERA` (런타임 권한 요청 흐름은 기존 권한 가이드 로직에 단계로 편입 가능).

---

## 7. 리스크 및 확인 필요 사항

1. **베데스다 미확정 3종**: 엔드포인트 URL / 응답 규격 / 테스트용 studyId·subjectId — Phase 0 검증 착수 전 회신 필요.
2. **QR 발급 주체**: iCReaT가 출력하는 QR 포맷이 §2.1 JSON과 동일한지 확인. 다르면 Sensor_monitor 파서를 실제 포맷에 맞춤.
3. **자동 로그인/캐시 일관성**: 기존 `login.txt` 기반 자동 진입을 studyId/subjectId 2값 구조로 안전하게 마이그레이션(앱 업데이트 시 기존 캐시 무효화 처리).
4. **무인증 → 추후 인증**: 메일상 (b)Dct-Session-Id, (c)API Key는 후속 논의. 전송부를 헤더 추가가 쉬운 구조로 작성해 두면 확장 용이.
5. **HTTP→HTTPS**: OkHttp 3.10.0에서 TLS/도메인 인증서 정상 동작 확인(구버전 TLS 이슈 점검).

---

## 8. 체크리스트

- [ ] 베데스다: 신규 엔드포인트 URL·응답 규격·테스트용 studyId/subjectId 회신 수신
- [ ] iCReaT QR 실제 포맷이 §2.1 JSON 스키마와 일치하는지 확인
- [ ] Phase 0: DeviceInfo/ServerConnection/AcceptService 5필드 전환 + 하드코딩 검증, 적재 확인
- [ ] Phase 1: QR 라이브러리·CAMERA 권한·QrScanActivity·LoginActivity 개편
- [ ] Phase 1: 캐시/자동로그인 마이그레이션
- [ ] 디버그 빌드 30분 사이클 종단간 테스트 + 베데스다 적재 확인(Q4)
