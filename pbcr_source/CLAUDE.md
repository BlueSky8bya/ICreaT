# pbcr_source/ — iCReaT DCT ePRO 앱 (Flutter)

> 루트 `../CLAUDE.md` 먼저. 이 파일은 pbcr_source/ 전용.

## 역할
연구대상자 전용 ePRO 모바일 앱. 스크리닝 후 D0부터 사용. iCReaT 웹에서 일정·문진 동기화 → 표시 → 응답을 eSource 업로드. 앱ID `kr.caresquare.pbcr`, 패키지 `icreat_dct`, 버전 1.0.15+15.

## 스택
Flutter 3.6 / Dart 3.6. 소스: `lib/`. 구성: `pubspec.yaml`.

## 핵심 기능
- ePRO 문진(객관식/주관식) 수행·제출
- iCReaT 연동(일정/문진 동기화)
- eSource 업로드
- FCM + 로컬 알림
- BLE 생체측정(혈압/체온)
- 수면/걸음(현재 비활성)

## 핵심 경로
| 경로 | 역할 |
|---|---|
| `lib/` | Dart 소스 (앱 본체) |
| `API_sensor_upload_guide.md` | **센서 업로드 API 가이드 — 업로드 작업 전 필독** |
| `assets/` / `mock/` / `data/` | 리소스·목·데이터 |
| `pubspec.yaml` | 의존성/버전 |
| `key/` | **시크릿. 건드리지 마라. git 제외.** |

## 작업 메모
- eSource 업로드/식별자(`studyId`/`subjectId`) 코드는 추측 금지 → `API_sensor_upload_guide.md`, `../reports/notes/bethesda_*.md` 먼저.
- 폰 앱(`../Sensor_monitor/`)과 업로드 규약 정합 확인.
- 버전 올릴 때 `pubspec.yaml`의 version/build code 동시 갱신.

## 하네스 라우팅
- 위젯/서비스 위치 → `cavecrew-investigator`.
- 넓은 lib/ 스윕 → `Explore` "medium".
- 1~2 파일 수정 → `cavecrew-builder`.
- diff 리뷰 → `cavecrew-reviewer`.

## 아카이브 규칙 (필수)
코드 변경 시:
1. 인라인 주석 태그: `// [YYYY-MM-DD] 이유: <왜> | 목적: <무엇>`
2. `CHANGELOG.md`에 항목 추가.
`key/`, `google-services.json`, `GoogleService-Info.plist` 커밋 절대 금지.
