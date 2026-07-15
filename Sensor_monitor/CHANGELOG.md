# Sensor_monitor/ 변경 아카이브

> append-only. 최신 항목 맨 위. 컨텍스트 창이 차도 여기서 "왜/언제/무엇" 복원.
>
> 항목 형식:
> ```
> ## YYYY-MM-DD — <한 줄 제목>
> - 이유: 왜 바꿨나
> - 목적: 무엇을 달성하나
> - 파일: 건드린 파일 목록
> - 비고: 후속/주의 (선택)
> ```

---

## 2026-07-15 — BT 리스닝 소켓 누수 + 수신 스레드 중복 생성 수정 (워치 초록불·모바일 NONE 버그)
- 이유: `createSeverSocket()`이 이전 `BluetoothServerSocket`을 닫지 않고 재생성 + `onStartCommand`마다 `AcceptThread` 무조건 신규 생성 + 스레드 사망 시 소켓 미정리 → 프로세스에 유령 SDP 레코드 누적. 워치가 같은 UUID 조회 시 accept() 없는 죽은 채널에 RFCOMM 연결 성공 → 워치는 초록불(수집 중)인데 모바일 상태는 NONE, 그래프 없음, 워치는 재연결 진동 반복. 모바일 앱 재시작으로만 복구. 디폴트 Sensor_monitor 로그(260711 14:28~14:35, THREAD_START 4회 중첩)로 확인, 코드 동일해 DCT도 같은 잠복 버그.
- 목적: 유령 리스너 원천 차단 — ① 리스너 재생성 전 이전 소켓 close ② 스레드 종료 finally에서 클라이언트/리스닝 소켓 정리 ③ companion `runningThread`로 살아있는 스레드 재사용(중복 생성 방지) ④ `onDestroy`에서 소켓 close로 블록된 스레드 종료. 항상 리스너 1개 유지 → 워치가 언제나 살아있는 채널에 연결.
- 파일: `service/BluetoothConnect.kt`, `service/AcceptThread.kt`, `service/AcceptService.kt`
- 비고: 디폴트(standalone) `Sensor_monitor` 707e45a와 동일 수정 이식 (공통 수정, 양쪽 동기 완료). 워치 앱은 수정 불필요 — 재연결 루프는 정상 동작.

## 2026-07-09 — QR 로그인 Phase 1: QR 스캔으로 studyId/subjectId 매칭
- 이유: Phase 0은 하드코딩 테스트 ID(C250005/121-001)로 진입 — 실 대상자 매칭 불가. 베데스다 권고(2026-05-12 메일 Q1)는 pbcr(작년 바코드 매칭 앱)처럼 QR 스캔으로 Study/Subject ID 매칭. `qr_login_integration_plan_2026-05-26.md` Phase 1 실행.
- 목적: pbcr과 동일 QR JSON 규격(`stdy_no`/`subject_id`/`organ_cd`/`pat_name`) 공유 — iCReaT 발급 QR을 두 앱이 그대로 사용. zxing-android-embedded `ScanContract`로 스캔(별도 Activity 불필요, CAMERA 런타임 권한 자체 처리) → LoginActivity가 파싱해 `enterSensor(studyId, subjectId)` 호출. **화면엔 QR 스캔 버튼만** — 스캔 성공 즉시 자동 로그인, 캐시(`login.txt` `"studyId|subjectId"`, 포맷 불변) 있으면 재실행 시 화면 조작 없이 자동 진입. 별도 "시작" 버튼 없음. 비-JSON/필드누락 QR 무시. `enterSensor` TEST 기본값 제거(스캔 없이 테스트 ID 업로드 위험 차단). SensorActivity fallback을 extras→캐시→TEST 순으로 강화. pat_name은 표시용만, 미저장(개인정보).
- 파일: `app/build.gradle`, `app/src/main/AndroidManifest.xml`, `app/src/main/res/layout/activity_login.xml`, `activity/LoginActivity.kt`, `activity/PortraitCaptureActivity.kt`(신규 — zxing 기본 가로 화면을 세로 고정으로 교체), `activity/SensorActivity.kt`, `common/ServerConnection.kt`, `test_qr/`(신규 — 테스트 QR PNG(C250005/121-001) + 생성 스크립트 `make_test_qr.py`, 실행 `py`, `qrcode[pil]` 필요)
- 비고: iCReaT 실제 발급 QR이 위 JSON 스키마와 일치하는지 미확인(계획 문서 §7-2) — 다르면 `LoginActivity.handleQrResult()` 파서만 수정. 실기기 스캔 테스트 필요. DeviceInfo TEST 상수는 최후 fallback용으로 유지. 캐시 존재 시 자동 진입이라 **대상자 변경은 캐시 삭제(`pm clear` 또는 앱 데이터 삭제) 필요** — 재스캔 UI 필요해지면 SensorActivity에 "대상자 변경" 진입점 추가 고려.

## 2026-06-30 — 로그인 화면 이메일 입력칸 제거 (무인증 진입)
- 이유: DCT 앱은 베데스다 무인증 정책으로 로그인 화면이 없어야 함. Phase 0 진입은 하드코딩 studyId/subjectId(C250005/121-001)로 "로그인된 셈" 치고 진행하는데, 레이아웃에 옛 "마음수첩 앱 이메일" 입력칸(`tilId`/`id`)이 잔재로 남아 있었음(코드에선 미사용).
- 목적: 이메일 TextInputLayout 제거, 버튼 텍스트 "로그인"→"시작"으로 변경(인증 아님). subtitle 제약을 loginBtn으로 재연결. 정식 로그인은 추후 QR 스캔으로 studyId/subjectId 주입 예정.
- 파일: `app/src/main/res/layout/activity_login.xml`
- 비고: 코드(LoginActivity)는 이미 이메일칸 미참조 — UI만 정리. 진입 흐름(loginBtn→enterSensor→하드코딩 ID)은 불변.

## 2026-06-30 — 모바일 셋업 자동화 스크립트(setup_phone.ps1) 추가
- 이유: 폰마다 설치 후 위치·BT·알림·저장소 권한 + 모든 파일 접근 + 앱 일시정지 해제 + 배터리 최적화 제외를 설정 화면에서 수동으로 하기 번거롭고 누락 위험. 워치용 `setup_watch.ps1`의 모바일 짝.
- 목적: ADB로 설치~설정을 한 번에. ① `gradlew installDebug` 설치 ② `pm grant`로 런타임 권한(위치/BT/알림/저장소) ③ `appops MANAGE_EXTERNAL_STORAGE allow`(센서 CSV Downloads 접근) ④ `appops AUTO_REVOKE...ignore`(일시정지 해제) ⑤ `deviceidle whitelist`(배터리 최적화 제외) ⑥ 검증 출력. 유선 1대면 인자 없이 실행.
- 파일: `setup_phone.ps1`
- 비고: pkg = `com.gachon_HCI_Lab.user_mobile.dct`(.dct 접미사 → 기존 Sensor Monitor와 동시 설치). 저장소 권한은 OS 버전상 미지원이면 실패 무시(MANAGE_EXTERNAL_STORAGE가 핵심). 실기기 미검증 — 유선 연결 상태에서 1회 동작 확인 필요.

## 2026-06-29 — 워치 배터리 로컬 타임라인 CSV + 비정상값 가드
- 이유: 배터리는 매 워치 패킷마다 도착하나, 로컬엔 `app_debug_log_*.txt`에 업로드 시점(30분 단위)에만 묻혀 나와 가독성·해상도 낮음. scale=-1 등 garbage 값 유입 가능성도 있었음.
- 목적: (1) 전용 `Downloads/sensor_data/battery/watch_battery_YYMMDD.csv`(`timestamp,battery`)에 값 변할 때(또는 10분 정체 시 1줄) 기록 — 효율적·가독성. (2) 음수/100초과 비정상값은 무시해 서버·로그 오염 차단.
- 파일: `common/CsvController.kt`(`logBattery()` + 상태 변수), `service/AcceptThread.kt`(`saveBatteryDataFrom` 가드+훅)
- 비고: dedup(값 변화 기준)으로 파일 작게 유지. 비정상값은 `setBattery` 건너뜀 → `hasBattery` false 유지로 업로드 보류와 정합. 서버 전송 로직은 불변(로컬 기록은 부가).

## 2026-06-29 — 배터리: 실측 수신 전 업로드 보류 (가짜 100 차단)
- 이유: `DeviceInfo._battery` 기본값 `"100"`은 placeholder. 업로드는 `mergeTimer`(1분 주기)가 수신과 독립으로 발사하므로, 앱 재시작 후 워치 재연결 전에 디스크 백로그 CSV가 실제 배터리와 무관한 `100`으로 전송될 수 있었음.
- 목적: 기본값을 빈 sentinel(`""`)로 바꾸고 `hasBattery()` 게이트 추가. `sendCSV()` 진입 시 실측 배터리 미수신이면 병합·전송 보류(조각 파일은 디스크 보존 → 워치 연결 후 실측값으로 전송). persistence 없이 "연결 당시 워치 배터리만 전송" 보장.
- 파일: `common/DeviceInfo.kt`(기본값·init 기본인자·`hasBattery()`), `service/AcceptService.kt`(`sendCSV` 보류 게이트)
- 비고: 정상 스트리밍 중엔 매 패킷이 `_battery`를 갱신하므로 영향 없음. 워치가 끝내 재연결 안 되면 백로그는 미전송 보류(가짜 데이터보다 안전). `_battery` 소비처는 `postFile` 뿐이라 빈값이 서버로 새지 않음.

## 2026-06-29 — 앱 차별화: 이름·applicationId 분리 (동시 설치)
- 이유: 기존 단말에 설치된 'Sensor Monitor'와 DCT 연동 테스트용 빌드를 나란히 두어야 함. applicationId가 같으면 기존 앱을 덮어씀.
- 목적: 런처 이름 `Sensor Monitor` → `Sensor Monitor DCT`, applicationId `...user_mobile` → `...user_mobile.dct`. 별도 패키지로 동시 설치.
- 파일: `app/build.gradle`(applicationId), `app/src/main/res/values/strings.xml`(app_name)
- 비고: namespace는 불변 → 코드 패키지/R 클래스 그대로, Kotlin 파일 이동 없음. Firebase/google-services 없음·FileProvider authorities 없음 → applicationId 변경 충돌 없음. 코드의 `packageName` 참조는 런타임 해석이라 새 패키지로 정상 동작.

> 직전 진행 내역은 `../reports/notes/progress_report_2026-05-26.md`, `../reports/notes/qr_phase0_changes_2026-05-26.md` 참조.
