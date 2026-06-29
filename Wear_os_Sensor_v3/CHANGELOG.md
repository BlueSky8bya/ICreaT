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
