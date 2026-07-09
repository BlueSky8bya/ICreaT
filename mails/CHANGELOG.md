# mails/ CHANGELOG

append-only. 최신 항목 맨 위. 형식:
```
## YYYY-MM-DD — <한 줄 제목>
- 내용: 무슨 메일/첨부 추가·갱신
- 파일: threads/... 또는 attachments/...
- 비고: 후속/주의 (선택)
```

---

## 2026-07-09 — QR 스캔 첫 테스트 확인 요청 발신 문서화
- 내용: QR 로그인 Phase 1 적용 후 첫 종단간 테스트(07-09 17:15 스캔 → 17:30 전송, C250005/121-001) 수신·적재 확인 + 테스트 QR 지속 사용 여부 문의 메일 발신. 회신 대기.
- 파일: threads/2026-07-09_qr-scan-first-upload-confirm.md, attachments/2026-07-09_test_qr.png (메일 첨부한 자체 생성 테스트 QR)
- 비고: 회신 오면 같은 스레드 파일에 append. 적재 확인 시 QR 전환 검증 종료 → 다음 회차 보고 반영.
- 내용: 김영진 담당자 06-30 회신(지정 시간 전송 파일 수신 확인 + 전송파일 압축 역첨부) 스레드로 문서화. 07-01 발표자료 근거.
- 파일: threads/2026-06-30_sensor-upload-receipt-confirm.md, attachments/2026-06-30_iCReaT_DCT_sensor_upload.zip (14개 CSV)
- 비고: 06-17 보고 미결 "DB 적재 확인" 종료 확정. 원본 텍스트는 attachments/2026-06-30.txt.

## 2026-06-30 — mails/ 아카이브 초기화
- 내용: 베데스다 담당자 메일 보관소 생성. threads/(본문 문서화)·attachments/(원본 파일) 2분류. 루트 CLAUDE.md 라우팅 표·규칙 추가, mails/CLAUDE.md 지침 작성.
- 파일: mails/CLAUDE.md, mails/CHANGELOG.md, ../CLAUDE.md
- 비고: 기존 루트의 `iCReaT_DCT_sensor_upload.zip` → `attachments/2026-06-30_iCReaT_DCT_sensor_upload.zip`로 이동.
