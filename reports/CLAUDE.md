# reports/ — 진행보고 산출물 + PPT 빌더

> 루트 `../CLAUDE.md` 먼저. 이 파일은 reports/ 전용 지침.

## 역할
2주 단위 진행보고. md 보고서 작성 → python-pptx 스크립트로 발표용 .pptx 생성. 베데스다 연동 분석 문서 보관소.

## 폴더 구조 (타입별 분류)
```
reports/
├─ CLAUDE.md          이 지침
├─ CHANGELOG.md       변경 아카이브
├─ decks/             산출물 .pptx (16:9, 맑은 고딕)
├─ builders/          python-pptx 빌더 (.py) — decks/로 출력
└─ notes/             md 보고서·계획·분석
```

| 위치 | 내용 |
|---|---|
| `decks/[ICreaT과제] 진행상황 보고서_*.pptx` | 발표 산출물 |
| `builders/build_progress_ppt_YYYY-MM-DD.py` | 회차 PPT 빌더 |
| `builders/build_meeting_ppt.py` / `update_meeting_ppt.py` | 05-13 회의덱 빌더/수정 |
| `notes/progress_report_YYYY-MM-DD.md` | 회차 보고 본문 (개조식 `~임/~했음`) |
| `notes/bethesda_*.md` | 베데스다 회신/멀티파트/CSV 분석 |
| `notes/qr_*.md` | QR 로그인 통합 계획·변경 |

## 우로보로스 워크플로 (자기참조 루프)
새 회차 = 직전 산출물을 입력으로 먹는다. 처음부터 다시 쓰지 않음.
1. 직전 `notes/progress_report_*.md` + 직전 `builders/build_progress_ppt_*.py` 읽기 → "직전 이후 경과"만 추출.
2. 새 PPT 스크립트는 직전 덱 **팔레트·폰트 그대로 상속** (NAVY/BLUE/ACCENT/GREEN/RED, 맑은 고딕/Consolas, 13.333×7.5in, layout[6]).
3. 본문 말투 개조식 고정.
4. 네이밍: `notes/progress_report_YYYY-MM-DD.md`, `builders/build_progress_ppt_YYYY-MM-DD.py`, `decks/[ICreaT과제] 진행상황 보고서_YYYY-MM-DD.pptx`.

## 실행
- Python 런처는 `py` (PATH에 `python` 없음). 예: `py reports/builders/build_progress_ppt_YYYY-MM-DD.py`.
- `python-pptx` 필요. 없으면 `py -m pip install python-pptx`.
- 빌더 `OUT`/`PPT` 경로는 **스크립트 상대경로**로 `../decks/`를 가리킴 (`os.path.join(os.path.dirname(__file__), "..", "decks", ...)`). 절대경로 하드코딩 금지 — 저장소 이동 시 깨짐.

## 폴더 정리 규칙 (필수)
이 폴더는 **항상 3분류 유지** — 루트에 산출물/스크립트/노트를 흩뿌리지 마라.
- 새 .pptx → `decks/`
- 새 빌더 .py → `builders/` (출력 경로 `../decks/`로)
- 새 보고/계획/분석 .md → `notes/`
- `CLAUDE.md`, `CHANGELOG.md`만 reports/ 루트에 둔다.
- `__pycache__/`, `*.pyc` 등 빌드 부산물은 커밋 금지(이미 .gitignore). 보이면 삭제.
- 새 파일 추가 시 위 "폴더 구조" 표도 갱신.

## 하네스 라우팅
- 새 회차 보고 작성 → 직전 2개 파일(notes+builders) 직접 읽기(작음). 탐색 에이전트 불필요.
- 코드 변경 근거 찾기 → 해당 코드 폴더(`Sensor_monitor/` 등) `CHANGELOG.md` 참조.

## 아카이브 규칙 (필수)
이 폴더에서 스크립트/문서 변경 시:
1. 인라인 주석 태그: `# [YYYY-MM-DD] 이유: <왜> | 목적: <무엇>`
2. `CHANGELOG.md`에 항목 추가 (형식은 그 파일 헤더 참조).
