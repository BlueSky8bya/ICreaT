# reports/ 변경 아카이브

> append-only. 최신 항목을 맨 위에 추가. 컨텍스트 창이 차도 여기서 "왜/언제/무엇" 복원.
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

## 2026-06-29 — reports/ 폴더 타입별 3분류 정리
- 이유: 16개 파일 + `__pycache__`가 reports/ 루트에 평면적으로 섞여 탐색 어려움.
- 목적: `decks/`(.pptx) · `builders/`(.py) · `notes/`(.md) 3분류로 정리. 에이전트가 빠르게 길 찾도록.
- 파일: 전체 이동. `__pycache__/` 삭제. 빌더 4개 출력 경로를 `../decks/`로 수정. `CLAUDE.md`에 폴더 구조·정리 규칙 추가.
- 비고: `CLAUDE.md`/`CHANGELOG.md`만 reports/ 루트 유지. 타 폴더 지침서의 `reports/*.md` 참조도 `reports/notes/*`로 갱신.

## 2026-06-29 — PPT 빌더 출력 경로 버그 수정
- 이유: `OUT`/`PPT`/`out` 변수가 옛 절대경로 `c:\projects\iCreat\reports\...`로 하드코딩됨. 저장소가 `c:\projects\Health Care\Research Assignments\iCreat\`로 이동해 실행 시 저장 실패.
- 목적: 스크립트 상대경로(`os.path.dirname(os.path.abspath(__file__))`)로 전환해 저장소 위치 무관하게 동작.
- 파일: `build_progress_ppt_2026-05-26.py`, `build_progress_ppt_2026-06-16.py`, `build_meeting_ppt.py`, `update_meeting_ppt.py`
- 비고: 4개 모두 `import os` 추가. 4개 syntax 검증 통과. 실제 .pptx 재생성은 미실행(python-pptx 설치 여부 미확인).
