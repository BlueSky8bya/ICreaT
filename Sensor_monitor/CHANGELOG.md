# Sensor_monitor/ 변경 아카이브

> append-only. 최신 항목 맨 위. 컨텍스트 창이 차도 여기서 "왜/언제/무엇" 복원.
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

## 2026-06-29 — 앱 차별화: 이름·applicationId 분리 (동시 설치)
- 이유: 기존 단말에 설치된 'Sensor Monitor'와 DCT 연동 테스트용 빌드를 나란히 두어야 함. applicationId가 같으면 기존 앱을 덮어씀.
- 목적: 런처 이름 `Sensor Monitor` → `Sensor Monitor DCT`, applicationId `...user_mobile` → `...user_mobile.dct`. 별도 패키지로 동시 설치.
- 파일: `app/build.gradle`(applicationId), `app/src/main/res/values/strings.xml`(app_name)
- 비고: namespace는 불변 → 코드 패키지/R 클래스 그대로, Kotlin 파일 이동 없음. Firebase/google-services 없음·FileProvider authorities 없음 → applicationId 변경 충돌 없음. 코드의 `packageName` 참조는 런타임 해석이라 새 패키지로 정상 동작.

> 직전 진행 내역은 `../reports/notes/progress_report_2026-05-26.md`, `../reports/notes/qr_phase0_changes_2026-05-26.md` 참조.
