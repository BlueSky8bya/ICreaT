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
