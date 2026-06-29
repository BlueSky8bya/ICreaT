# Wear_os_Sensor_v3/ — 워치 센서 앱

> 루트 `../CLAUDE.md` 먼저. 이 파일은 Wear_os_Sensor_v3/ 전용.

## 역할
Wear OS 워치 앱. 워치 센서 수집·전송. 패키지 `com.gachon_HCI_Lab.wear_os_sensor`.

## 스택
Kotlin / Gradle. 소스 루트: `app/src/main/java/com/gachon_HCI_Lab/wear_os_sensor/`.

## 핵심 경로
| 경로 | 역할 |
|---|---|
| `MainActivity.kt` | 진입 |
| `MainFragment.kt` / `ConnectFragment.kt` / `SensorListFragment.kt` | 화면 |
| `model/SDKSensor.kt` / `SensorModel.kt` / `Constant.kt` | 센서 모델·상수 |
| `recyclerView/SensorAdapter.kt` / `Item.kt` | 목록 |
| `app/src/main/AndroidManifest.xml` | 권한/구성 (최근 수정됨) |

## 작업 메모
- 폰 앱(`../Sensor_monitor/`)과 데이터 흐름 연동. 식별자/업로드 변경은 폰 앱과 정합 확인.
- 빌드 구성 변경(`app/build.gradle`, manifest)은 CHANGELOG에 이유 명시.

## 하네스 라우팅
- 클래스/센서 모델 위치 → `cavecrew-investigator`.
- 넓은 스윕 → `Explore` "medium".
- 1~2 파일 수정 → `cavecrew-builder`.
- diff 리뷰 → `cavecrew-reviewer`.

## 아카이브 규칙 (필수)
코드 변경 시:
1. 인라인 주석 태그: `// [YYYY-MM-DD] 이유: <왜> | 목적: <무엇>`
2. `CHANGELOG.md`에 항목 추가.
민감 파일(keystore, google-services.json) 커밋 금지.
