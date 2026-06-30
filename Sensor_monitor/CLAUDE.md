# Sensor_monitor/ — 폰 센서 모니터 앱

> 루트 `../CLAUDE.md` 먼저. 이 파일은 Sensor_monitor/ 전용.

## 역할
Android 폰 앱. 센서 데이터 수집 → 베데스다 iCReaT DCT 서버 CSV 업로드. QR 로그인 전환 진행 중. 패키지 `com.gachon_HCI_Lab.user_mobile`.

## 스택
Kotlin / Gradle. 소스 루트: `app/src/main/java/com/gachon_HCI_Lab/user_mobile/`.

## 핵심 경로
| 경로 | 역할 |
|---|---|
| `activity/LoginActivity.kt` | 로그인 (QR 통합 대상) |
| `activity/SensorActivity.kt` | 센서 수집 화면 |
| `activity/MainActivity.kt` | 메인 |
| `common/ServerConnection.kt` | **서버 통신 — 베데스다 업로드 핵심** |
| `common/DeviceInfo.kt` | 기기/식별자 |
| `common/BTManager.kt` | 블루투스 |
| `service/AcceptService.kt` | 수신 서비스 |

## 깃헙 레포 라우팅 (폰 앱 수정 시 필수)
폰 앱도 **두 레포로 갈라져 관리**된다. 사용자가 수정 요청 **서두에 라벨을 먼저 말한다** — 그 라벨에 맞춰 push 대상을 라우팅한다. (워치 앱과 동일 규칙 — `../Wear_os_Sensor_v3/CLAUDE.md` 참조)

| 라벨 | 정체 | push 대상 |
|---|---|---|
| **공통 수정** | 기준(디폴트) 폰 앱 | standalone `https://github.com/BlueSky8bya/Sensor_monitor.git` **+ 모노레포에도 반영**(양쪽 동기) |
| **DCT 전용 수정** | iCReaT DCT 과제 전용 분기 | 모노레포 `https://github.com/BlueSky8bya/ICreaT.git`의 `Sensor_monitor/` **only** (standalone 금지) |

- **왜:** standalone이 기준 앱, 모노레포 안 폴더는 과제용 분기 사본.
- **⚠️ 이미 분기 진행됨:** 워치와 달리 이 폴더는 **DCT 전용 변경이 이미 많이 쌓임**(로그인 흐름, 멀티파트 업로드, `userID`→`studyId`/`subjectId` 등). 따라서 **공통 수정을 standalone에 올릴 때 DCT 전용 변경이 섞여 들어가지 않게 파일/헝크 단위로 선별**한다. 폴더 통째 동기화 절대 금지(DCT 작업 오염/유실 위험).
- **어떻게:** 편집은 항상 모노레포 작업본(`c:/projects/ICreaT/Sensor_monitor/`)에서. standalone push는 임시 클론에 **공통에 해당하는 변경 파일만** 복사(경로 prefix `Sensor_monitor/` 제거)→커밋→push→임시 정리. 두 레포는 히스토리 루트가 달라 cherry-pick 불가 → 파일 단위 이식.
- **라벨 없으면** 추측 금지 — 공통인지 DCT 전용인지 물어본다.
- 모노레포 전용 파일(`CLAUDE.md`/`CHANGELOG.md`/`.idea/`, `setup_phone.ps1`)은 standalone 반영 시 별도 판단.

## 핵심 과제 — 베데스다 업로드 (최우선)
식별 체계 전환: `userID` → `studyId`/`subjectId`. 임상 데이터 무결성 직결.
- 작업 전 `../reports/notes/bethesda_*.md`, `../pbcr_source/API_sensor_upload_guide.md` 먼저 읽기.
- 업로드/식별자 코드는 추측 금지. 가이드 확인 후 수정.
- QR 로그인은 `../reports/notes/qr_login_integration_plan_2026-05-26.md`, `../reports/notes/qr_phase0_changes_2026-05-26.md` 참조.

## 하네스 라우팅
- "어디서 X 호출" / 클래스 위치 → `cavecrew-investigator`.
- 넓은 스윕(여러 activity/service 명명규칙) → `Explore` "medium".
- 1~2 파일 외과 수정 → `cavecrew-builder`.
- diff 리뷰 → `cavecrew-reviewer`.

## 아카이브 규칙 (필수)
코드 변경 시:
1. 인라인 주석 태그: `// [YYYY-MM-DD] 이유: <왜> | 목적: <무엇>`
2. `CHANGELOG.md`에 항목 추가.
민감 파일 커밋 금지: `google-services.json`, keystore.
