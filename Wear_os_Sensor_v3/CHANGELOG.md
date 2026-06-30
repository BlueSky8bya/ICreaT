# Wear_os_Sensor_v3/ 변경 아카이브

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

## 2026-06-30 — PPG 녹색 LED STOP 시 OFF 수정 (옛 standalone repo에서 이식)
- 이유: 워치 STOP 버튼으로 종료해도 PPG 녹색 LED가 켜진 채 남음. 원인 = `stopService`(STOP 버튼)는 `onStartCommand`를 거치지 않고 바로 `onDestroy`로 진입하는데, 기존 정리(`ppg.destroy()`)는 `stopForground()`에만 있어 호출되지 않음. 또한 이 수정이 모노레포가 아니라 **옛 독립 저장소 `github.com/BlueSky8bya/Wear_os_Sensor_v3.git`(커밋 a0b5a0b)** 에 올라가 있어 모노레포엔 누락.
- 목적: ① `PpgUtil.destroy()`를 멱등화 — 리스너 해제(녹색 LED OFF)·`ppgTrackers.clear()`·서비스 disconnect를 try/catch + null-safe로. ② `SensorService`에 `@Volatile cleaned` 가드를 둔 멱등 `cleanup()` 신설, `onDestroy()`에서 호출 → STOP/stopSelf 등 **모든 종료 경로**에서 LED OFF 보장. `stopForground()`는 broadcast + `stopSelf()`만 하고 실제 정리는 onDestroy로 일원화.
- 파일: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/util/PpgUtil.kt`, `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/SensorService.kt`
- 비고: 옛 standalone repo와 모노레포가 갈라져 있어(특히 `MainActivity.kt` 209줄 차이 — 모노레포의 startup 크래시 수정 보유) **통째 동기화 금지**, 이 2개 파일만 외과적 이식. a0b5a0b의 PpgUtil/SensorService는 PPG hunk 외 모노레포와 동일함을 확인 후 적용. **후속: 옛 repo로의 push 중단하고 이후 작업은 모노레포로 일원화 필요**(분기 누적 위험).

## 2026-06-30 — 워치 셋업 자동화 스크립트(setup_watch.ps1) 추가
- 이유: 앱은 시스템 설정 화면을 스크롤/토글할 수 없어 '사용하지 않을 때 앱 일시정지' 토글을 코드로 끌 수 없음(크로스 앱 UI 조작 금지). 대상자 워치마다 설치 후 권한·일시정지·배터리 최적화를 수동 설정하면 번거롭고 누락 위험.
- 목적: ADB로 설치~설정을 한 번에. ① gradlew installDebug 설치 ② pm grant로 런타임 권한 직접 부여(앱 '권한' 화면 불필요) ③ appops `AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore`로 앱 일시정지 해제 ④ deviceidle whitelist로 배터리 최적화 제외 ⑤ 검증 출력.
- 파일: `setup_watch.ps1`
- 비고: 무선 페어링(adb pair, 1회성 코드)은 자동화 불가 — 최초 1회 수동 후 `-Serial <IP:PORT>` 전달. 옵션: `-SkipInstall`(설정만). Samsung Health [Dev mode] 등 시스템 API 미지원 항목은 여전히 수동. 실기기 미검증(기기 offline 상태) — online 시 1회 동작 확인 필요.

## 2026-06-30 — startup 전구간 로그 삽입 + 앱 일시정지(hibernation) 해제 유도 재시도
- 이유: 앞서 설정 자동실행이 진입을 깨졌을 때(b0ef2e9에서 제거) log.txt로 어느 단계에서 깨졌는지 짚기 어려웠음. 진단 가능한 상태로 만든 뒤 '사용하지 않을 때 앱 활동 일시정지' 해제 유도(2번 방식)를 다시 시도.
- 목적:
  - (로그) MainActivity onCreate 각 단계·권한 요청/결과·설정 유도 전과정에 `Log.i(TAG="WearStartup")` 삽입. ConnectFragment onCreateView/searchBluetoothDevice도 동일 태그로 묶음 → logcat `-s WearStartup` 한 필터로 진입 흐름 추적. ExceptionHandler를 기존 기본 핸들러로 체이닝 + full stacktrace를 우리 태그로 기록(기존 printStackTrace는 추적 약했음, nullability 경고도 해소).
  - (2번 방식 재시도) 깨졌던 원인 회피: ① 첫 프레임 전 동기 실행 금지 → 권한 콜백(onRequestPermissionsResult) 후, 또는 요청할 권한이 없으면 decorView.post로 지연. ② raw 인텐트(ACTION_AUTO_REVOKE_PERMISSIONS) 대신 `IntentCompat.createManageUnusedAppRestrictionsIntent`로 라우팅 위임. ③ `PackageManagerCompat.getUnusedAppRestrictionsStatus`로 상태 확인해 이미 해제/미지원이면 설정 화면 안 띄움. 모든 단계 try/catch + 로그로 진입 차단 방지.
- 파일: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/MainActivity.kt`, `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/ConnectFragment.kt`
- 비고: compileDebugKotlin BUILD SUCCESSFUL 확인. 실기기 검증 필요 — 설치 후 `adb logcat -s WearStartup:* AndroidRuntime:E -d > log.txt`로 새 로그 수집. Wear OS는 설정 UI가 폰과 달라 hibernation 화면 라우팅이 기기별로 다를 수 있으니 실제 이동 화면 확인 필요. core-ktx 1.9.0 헬퍼·Guava ListenableFuture 사용(기존 의존성).

## 2026-06-30 — 첫 실행 크래시 2종 수정 (마스킹 BT 주소 + BLUETOOTH_CONNECT 권한)
- 이유: `BluetoothConnect.searchDevice()`에서 2종 FATAL 크래시 확인(logcat 덤프 log.txt). ① 페어링 기기 객체를 `connected.toString()`으로 주소 문자열화 후 `getRemoteDevice()`로 재생성 → Android 12+/Wear OS가 `toString()`을 마스킹 주소(`XX:XX:XX:XX:70:FC`)로 반환해 `IllegalArgumentException: ... is not a valid Bluetooth address`(00:47/00:53/00:54/01:06). ② `bondedDevices`/기기명 접근이 BLUETOOTH_CONNECT 런타임 권한을 요구하는데 권한 허용 전 `ConnectFragment.onCreateView`가 호출 → `SecurityException: Need android.permission.BLUETOOTH_CONNECT ... getBondedDevices`(00:56). 둘 다 진입 직후 앱이 죽어 스플래시/버튼 멈춤의 실제 근본 원인.
- 목적: ① 불필요한 주소 왕복 제거, `getParingBluetoothDevice()`가 반환한 `BluetoothDevice`를 그대로 사용. ② `searchDevice()` 전체를 try/catch로 감싸 권한 미허용·BT 접근 실패 시 크래시 대신 "error" 반환 → ConnectFragment가 Search 상태로 안전 폴백.
- 파일: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/util/connect/BluetoothConnect.kt`
- 비고: 워치 ADB online 상태에서 `gradlew installDebug`로 첫 실행 정상 진입 확인 필요(현 log.txt는 수정 전 옛 코드 기록이라 검증 불가 — 재설치 후 새 logcat 필요). 워치 logcat 덤프 `log.txt`는 .gitignore에 추가(루트). 권한이 거부된 경우 BT 전송 자체는 동작 안 함 — 권한 보장 흐름은 MainActivity 런타임 권한 요청과 정합 필요(후속 검토).

## 2026-06-30 — 설정 자동실행 제거 (엉뚱한 라우팅·진입 깨짐 해결)
- 이유: `guideSystemSettingsOnce()`가 `ACTION_AUTO_REVOKE_PERMISSIONS`·배터리 최적화 설정 화면을 startActivity로 자동 실행 → Wear OS에서 엉뚱한 설정 화면으로 라우팅되고 첫 진입이 깨짐(로딩 아이콘도 안 뜸). (참고: `adb logcat -d`는 읽기 전용 덤프라 원인 아님.)
- 목적: 시스템 설정 화면 자동 실행을 전부 제거. onCreate는 스플래시→ConnectFragment→헬스init→런타임 권한 요청만 수행. 배터리/일시중지는 자동 토글이 OS상 불가하므로 수동 안내로 남김(추후 앱 내 버튼 등 안전한 방식으로 재검토).
- 파일: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/MainActivity.kt`
- 비고: 유지된 개선 = 첫 실행 ConnectFragment 항상 표시(버튼 회귀 수정) + 런타임 권한 1회 통합 요청. 제거 = 설정 화면 자동 실행. 빌드·설치로 확인 필요.

## 2026-06-30 — 스플래시 멈춤(로고만 뜸) 수정
- 이유: 직전 변경에서 `guideSystemSettingsOnce()`(배터리·일시중지 설정 인텐트)를 onCreate 동기 경로에서 호출 → 권한이 이미 허용된 상태(업데이트 설치)면 첫 프레임 그리기 전에 설정 액티비티로 튀어, 스플래시 로고에서 멈추고 시작 화면 진입 안 됨.
- 목적: onCreate에서 ConnectFragment를 **먼저** commit해 첫 프레임을 그리고, 시스템 설정 유도는 `window.decorView.post{}`(그리기 후) 또는 권한 콜백에서만 실행. 헬스 init catch도 `IllegalStateException`→`Exception`으로 넓혀 어떤 실패도 스플래시 멈춤으로 이어지지 않게 함.
- 파일: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/MainActivity.kt`
- 비고: 기능(권한 통합·설정 유도·버튼 표시)은 직전 항목과 동일, 실행 순서만 안전화. 빌드·설치로 확인 필요.

## 2026-06-30 — 첫 실행 버튼 회귀 수정 + 권한/설정 통합 유도
- 이유: 앱 진입 시 버튼 화면(ConnectFragment)이 안 뜨고 터치도 안 됨. 원인 = MainActivity가 ConnectFragment를 `isLocationServiceRunning()` true(=SensorService foreground 실행 중)일 때만 추가 → 첫 실행/서비스 미실행 시 빈 화면. 또한 초기세팅이 앱 목록을 수동으로 들어가 권한을 하나씩 켜야 해 번거로웠음.
- 목적: (1) 콜드 스타트에 ConnectFragment를 **항상** 표시(서비스 상태는 Fragment가 스스로 판단). (2) 런타임 권한(BODY_SENSORS·ACTIVITY_RECOGNITION·BLUETOOTH_CONNECT·BLUETOOTH_SCAN·POST_NOTIFICATIONS)을 **첫 실행에 한 번에** 요청. (3) 권한 처리 후 "미사용 시 앱 일시중지 해제(자동 권한 회수)"·"배터리 최적화 제외"를 유도 인텐트로 1회 안내.
- 파일: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/MainActivity.kt`
- 비고: targetSdk 34 유지(Play Console 요구). 삼성 헬스 [Dev mode]는 시스템 토글이라 API 없음 → 수동 단계로 남김. health 타입 FGS는 API 34에서 startForeground 시 BODY_SENSORS 필요 → 진입 시 선요청으로 완화(Start 시 크래시 방지). 빌드 검증은 기기 빌드·설치로 확인 필요(이 환경엔 Kotlin 컴파일러 없음).

> 직전: targetSdk 33→34, `foregroundServiceType="health"`+`FOREGROUND_SERVICE_HEALTH` 추가(Play 요구). 이는 [git 47c3f4f]에 커밋됨.
