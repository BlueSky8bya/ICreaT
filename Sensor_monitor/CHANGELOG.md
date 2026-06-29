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

## 2026-06-29 — 배터리: 실측 수신 전 업로드 보류 (가짜 100 차단)
- 이유: `DeviceInfo._battery` 기본값 `"100"`은 placeholder. 업로드는 `mergeTimer`(1분 주기)가 수신과 독립으로 발사하므로, 앱 재시작 후 워치 재연결 전에 디스크 백로그 CSV가 실제 배터리와 무관한 `100`으로 전송될 수 있었음.
- 목적: 기본값을 빈 sentinel(`""`)로 바꾸고 `hasBattery()` 게이트 추가. `sendCSV()` 진입 시 실측 배터리 미수신이면 병합·전송 보류(조각 파일은 디스크 보존 → 워치 연결 후 실측값으로 전송). persistence 없이 "연결 당시 워치 배터리만 전송" 보장.
- 파일: `common/DeviceInfo.kt`(기본값·init 기본인자·`hasBattery()`), `service/AcceptService.kt`(`sendCSV` 보류 게이트)
- 비고: 정상 스트리밍 중엔 매 패킷이 `_battery`를 갱신하므로 영향 없음. 워치가 끝내 재연결 안 되면 백로그는 미전송 보류(가짜 데이터보다 안전). `_battery` 소비처는 `postFile` 뿐이라 빈값이 서버로 새지 않음.

## 2026-06-29 — 앱 차별화: 이름·applicationId 분리 (동시 설치)
- 이유: 기존 단말에 설치된 'Sensor Monitor'와 DCT 연동 테스트용 빌드를 나란히 두어야 함. applicationId가 같으면 기존 앱을 덮어씀.
- 목적: 런처 이름 `Sensor Monitor` → `Sensor Monitor DCT`, applicationId `...user_mobile` → `...user_mobile.dct`. 별도 패키지로 동시 설치.
- 파일: `app/build.gradle`(applicationId), `app/src/main/res/values/strings.xml`(app_name)
- 비고: namespace는 불변 → 코드 패키지/R 클래스 그대로, Kotlin 파일 이동 없음. Firebase/google-services 없음·FileProvider authorities 없음 → applicationId 변경 충돌 없음. 코드의 `packageName` 참조는 런타임 해석이라 새 패키지로 정상 동작.

> 직전 진행 내역은 `../reports/notes/progress_report_2026-05-26.md`, `../reports/notes/qr_phase0_changes_2026-05-26.md` 참조.
