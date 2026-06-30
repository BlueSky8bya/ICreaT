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

## 깃헙 레포 라우팅 (워치 수정 시 필수)
워치 앱은 **두 레포로 갈라져 관리**된다. 사용자가 수정 요청 **서두에 라벨을 먼저 말한다** — 그 라벨에 맞춰 push 대상을 라우팅한다.

| 라벨 | 정체 | push 대상 |
|---|---|---|
| **공통 수정** | 기준(디폴트) 워치 앱 | standalone `https://github.com/BlueSky8bya/Wear_os_Sensor_v3.git` **+ 모노레포에도 반영**(양쪽 동기) |
| **DCT 전용 수정** | iCReaT DCT 과제 전용 분기 | 모노레포 `https://github.com/BlueSky8bya/ICreaT.git`의 `Wear_os_Sensor_v3/` **only** (standalone 금지) |

- **왜:** standalone이 기준 앱, 모노레포 안 폴더는 과제용 분기 사본. 공통 개선은 양쪽, 과제 전용은 모노레포에만 둬 base 앱 오염 방지.
- **어떻게:** 편집은 항상 모노레포 작업본(`c:/projects/ICreaT/Wear_os_Sensor_v3/`)에서. standalone push는 ① 임시 클론 ② 변경 파일만 복사(경로 prefix `Wear_os_Sensor_v3/` 제거) ③ 커밋·push ④ 임시 클론/remote 정리. EOL: standalone `autocrlf=true`(저장 LF)라 복사 시 git이 정규화 — 노이즈 없음. 두 레포는 히스토리 루트가 달라 cherry-pick 불가 → 파일 단위 이식.
- **라벨 없으면** 추측 금지 — 공통인지 DCT 전용인지 물어본다.
- 모노레포 전용 파일(`CLAUDE.md`/`CHANGELOG.md`/`.idea/`)은 standalone에 올리지 않는다. (`setup_watch.ps1`은 공통이라 양쪽 보유)

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
