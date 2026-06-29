# SLBM_hyuk-main_0730/ — 가천대 통신 서버 (DMF_ver3)

> 루트 `../CLAUDE.md` 먼저. 이 파일은 SLBM 서버 전용.

## 역할
API 서버. 앱들이 수집한 데이터 수신·저장. 설문 수신, file2db 적재.

## 스택
Django + MongoDB. 실행: `python3 manage.py runserver 0.0.0.0:7778` (포트 변경 시 숫자만 교체).

## 핵심 경로
| 경로 | 역할 |
|---|---|
| `DMF_ver3/settings.py` | 서버 주요 설정 |
| `file2db/` | 파일 → DB 적재 |
| `forSurvey/` | 설문 수신 |
| `forRun/` / `forAsan/` | 실행/아산 연동 |
| `README.md` / `SERVICES.md` | 서버 구성·서비스 설명 |

## 작업 메모
- 엔드포인트 변경은 앱 측(`../Sensor_monitor/common/ServerConnection.kt`, `../pbcr_source/`) 호출과 정합 확인.
- 설정/포트/DB 연결 변경은 이유를 CHANGELOG에 명시.

## 하네스 라우팅
- view/url/모델 위치 → `cavecrew-investigator`.
- 넓은 스윕 → `Explore` "medium".
- 1~2 파일 수정 → `cavecrew-builder`.

## 아카이브 규칙 (필수)
코드 변경 시:
1. 인라인 주석 태그: `# [YYYY-MM-DD] 이유: <왜> | 목적: <무엇>`
2. `CHANGELOG.md`에 항목 추가.
**커밋 금지:** 로그, `db.sqlite3`, `nohup.out`, 시크릿/키.
