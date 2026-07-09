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

## 2026-07-01 — 07-01 진행보고 회차 추가 (종단간 전송 + 베데스다 수신 확인)
- 이유: 직전 06-17 보고의 미결 항목(서버 DB 적재 확인)이 06-30 담당자 회신으로 종료됨. 우로보로스 규칙대로 회차 보고 작성.
- 목적: 06-30 종단간 자동 전송(워치→앱→서버 30분 사이클, 7종 센서 14개 CSV) + 베데스다 김영진 담당자 수신 확인 회신을 발표자료로 정리. 다음 목표 = QR 스캔.
- 파일: `notes/progress_report_2026-07-01.md`, `builders/build_progress_ppt_2026-07-01.py`, `decks/[ICreaT과제] 진행상황 보고서_2026-07-01.pptx`(9슬라이드)
- 비고: 06-17 덱 팔레트·폰트·헬퍼 상속. 근거 1차 출처 = `mails/threads/2026-06-30_sensor-upload-receipt-confirm.md`, 첨부 = `mails/attachments/2026-06-30_iCReaT_DCT_sensor_upload.zip`.
- 후속 수정(같은 날): 슬라이드 5의 메일 원문 인용 박스 제거 → 수신 파일 증빙 테이블(센서×사이클)로 재설계. 슬라이드 3 인용 문구도 사실 서술로 교체. 재발 방지로 `CLAUDE.md`에 "슬라이드 내용 규칙(메일 원문 인용 금지, 결론·수치만)" 추가.

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
