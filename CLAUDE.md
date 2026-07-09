# CLAUDE.md — iCReaT 과제 모노레포

이 파일은 Claude Code가 이 저장소에서 작업할 때 읽는 운영 지침이다. 처음 들어온 세션은 이 문서부터 읽고 폴더 라우팅·목표·작업 기법을 파악한다.

---

## 0. 프로젝트 목표 (왜 이 저장소가 존재하는가)

**공익적 분산형 임상연구(DCT) 기반 구축 과제.** 연구대상자의 생체·문진 데이터를 수집해 베데스다 iCReaT DCT 서버(eSource)로 안전하게 업로드하는 것이 최종 목적이다.

핵심 목표 3가지:

1. **데이터 수집** — 모바일/워치 앱으로 혈압·체온·수면·걸음·문진(ePRO) 데이터를 측정.
2. **서버 연동** — 수집 데이터를 베데스다 iCReaT DCT 서버에 CSV/멀티파트로 업로드. `userID` → `studyId`/`subjectId` 식별 체계 전환이 진행 중인 핵심 과제.
3. **진행 보고** — 2주 단위로 진행상황 보고서(md)를 쓰고, 발표용 PPT로 변환해 제출. `reports/`가 이 산출물의 보관소.

작업 우선순위: **베데스다 업로드 파이프라인 정확성 > 보고 산출물 > 그 외 기능.** 임상 데이터 무결성이 걸린 코드는 추측으로 고치지 않는다 — 가이드 문서를 먼저 확인한다.

---

## 1. 폴더 라우팅 (어디서 무엇을 고치나)

| 폴더 | 정체 | 스택 | 들어가는 작업 |
|---|---|---|---|
| `pbcr_source/` | iCReaT DCT ePRO 앱 (`icreat_dct`, 앱ID `kr.caresquare.pbcr`) | Flutter 3.6 / Dart | 문진 시스템, eSource 업로드, FCM 알림, BLE 생체측정 |
| `Sensor_monitor/` | 폰 센서 모니터 앱 | Android / Kotlin | 센서 수집, 베데스다 CSV 업로드, QR 로그인 |
| `Wear_os_Sensor_v3/` | 워치 센서 앱 | Wear OS / Kotlin | 워치 센서 수집·전송 |
| `SLBM_hyuk-main_0730/` | 가천대 통신 서버 (DMF_ver3) | Django + MongoDB | API 서버, file2db, 설문 수신 |
| `reports/` | 진행보고 산출물 | Markdown + python-pptx | 보고서 작성 → PPT 변환 (§3) |
| `reports/` | 진행보고 산출물 | Markdown + python-pptx | `decks/`(.pptx)·`builders/`(.py)·`notes/`(.md) 3분류 (§3) |
| `docs/` | 저장소 운영 메모 | Markdown | git 흐름(`git_workflow.md`), monorepo 전환 이력(`repository_plan.md`) |
| `mails/` | 베데스다 담당자 메일 아카이브 | Markdown + 첨부파일 | 메일 본문 문서화(`threads/`)·주고받은 파일 보관(`attachments/`) |
| `pbcr_source/key/` | 키/시크릿 | — | **건드리지 마라. git 제외 대상.** |

### 라우팅 규칙
- **폴더 진입 시 그 폴더의 `CLAUDE.md`부터 읽어라.** 각 라우팅 폴더에 전용 지침서가 있다 — 토큰 낭비 없이 바로 길 찾는다:
  - `reports/CLAUDE.md`, `Sensor_monitor/CLAUDE.md`, `Wear_os_Sensor_v3/CLAUDE.md`, `pbcr_source/CLAUDE.md`, `SLBM_hyuk-main_0730/CLAUDE.md`
- 베데스다 업로드 코드 작업 전 → `pbcr_source/API_sensor_upload_guide.md`, `reports/notes/bethesda_*.md` 먼저 읽기.
- 베데스다 담당자와의 합의·스펙 확인(필드명, 식별자, 엔드포인트, 기한) → `mails/threads/` 에서 1차 출처 확인. 코드 추측 전 실제 메일 근거 우선.
- 어느 폴더 작업인지 모호하면 추측 금지 → `cavecrew-investigator` 또는 `Explore`로 위치부터 찾기.
- 저장소 운영은 `docs/`: git 기본 흐름·되돌리기는 `docs/git_workflow.md`, monorepo 전환 배경·민감파일 제외 목록은 `docs/repository_plan.md`(전환 완료 이력).
- `Sensor_monitor/`, `Wear_os_Sensor_v3/`는 과거 독립 repo였다가 monorepo로 통합됨 (`docs/repository_plan.md`). 이제 루트에서 함께 추적된다.

---

## 2. 하네스 엔지니어링 (도구를 일에 맞게 배치)

이 저장소는 코드(2개 언어 × 4개 앱) + 문서 + 빌드스크립트가 섞여 있다. 매 작업마다 도구를 일 형태에 맞춰 고른다 — 인라인으로 다 하지 말고 위임한다.

### 위임 기준
- **위치 찾기** (where is X / 무엇이 Y를 호출 / 디렉터리 지도) → `cavecrew-investigator` (caveman 압축 출력, 메인 컨텍스트 ~60% 절약).
- **넓은 탐색** (여러 폴더·명명규칙 스윕, 결론만 필요) → `Explore`. 범위 명시: "medium" 또는 "very thorough".
- **1~2 파일 외과 수정** (오타, 단일 함수 재작성, 기계적 rename) → `cavecrew-builder`. 3+ 파일은 거부함.
- **diff/브랜치/파일 리뷰** → `cavecrew-reviewer`. 심각도 태그, 한 줄/발견.
- **설계 필요** → `Plan` 에이전트.

### 병렬 원칙
독립적인 호출은 한 메시지에 묶어 동시 실행. 의존성 있을 때만 순차.

### 멀티에이전트 워크플로 (opt-in)
대규모 감사·마이그레이션·교차 리뷰는 사용자가 "워크플로 써라" / "ultracode" 명시할 때만 `Workflow`로 오케스트레이션. 그 전엔 단일 에이전트 또는 인라인. 비용 큰 도구이므로 추론하지 말고 명시적 동의 필요.

---

## 3. 보고서 → PPT 파이프라인 (우로보로스 기법)

진행보고는 **자기참조 루프**로 돈다. 이전 산출물이 다음 산출물의 입력이 되어 형식·팔레트·말투가 누적 일관성을 유지한다 — 이게 여기서 말하는 우로보로스(꼬리 무는 뱀) 기법이다.

```
직전 보고서(md) ──┐
직전 PPT 스크립트 ─┼─▶ 새 보고서(md) ──▶ 새 PPT 스크립트(.py) ──▶ python-pptx ──▶ 새 .pptx
직전 .pptx 팔레트 ─┘            (다음 회차 입력으로 되먹임) ◀──────────────────┘
```

> reports/는 3분류 폴더(`decks/`·`builders/`·`notes/`). 세부는 `reports/CLAUDE.md` 참조.

### 루프 규칙
1. **새 보고는 직전 보고를 먹는다.** 새 회차 시작 시 직전 `reports/notes/progress_report_*.md`와 직전 `reports/builders/build_progress_ppt_*.py`를 먼저 읽어 "직전 이후 경과"만 정리. 처음부터 다시 쓰지 않는다.
2. **형식 상속.** 새 PPT 스크립트는 직전 덱과 동일 팔레트·폰트를 재사용한다 (아래 상수 고정).
3. **말투 고정.** 보고 본문은 개조식 — `~임 / ~했음`.
4. **회차 네이밍.** `notes/progress_report_YYYY-MM-DD.md`, `builders/build_progress_ppt_YYYY-MM-DD.py`, 산출물 `decks/[ICreaT과제] 진행상황 보고서_YYYY-MM-DD.pptx`.

### 고정 팔레트/폰트 (덱 간 일관성)
```python
NAVY = RGBColor(0x0F, 0x2A, 0x4A)   # 제목/강조
BLUE = RGBColor(0x1F, 0x4E, 0x79)
ACCENT = RGBColor(0xE8, 0x74, 0x22) # 포인트(주황)
GREEN = RGBColor(0x2E, 0x8B, 0x57)  # 완료
RED   = RGBColor(0xC0, 0x39, 0x2B)  # 이슈/주의
FONT_KR = "맑은 고딕"
FONT_MONO = "Consolas"
슬라이드: 13.333 x 7.5 in (16:9), layout[6] = BLANK
```

### 출력 경로 규칙 (해결됨 2026-06-29)
빌더의 `OUT`/`PPT` 경로는 **스크립트 상대경로**로 `../decks/`를 가리킨다:
```python
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "decks", "<파일명>.pptx")
```
절대경로 하드코딩 금지 — 저장소 이동 시 깨진다. (과거 `c:\projects\iCreat\...` 하드코딩 버그는 4개 빌더에서 수정 완료.)

### 의존성·실행
`python-pptx` 필요. Python 런처는 `py`(PATH에 `python` 없음). 실행: `py reports/builders/build_progress_ppt_YYYY-MM-DD.py`.

---

## 4. Git 운용

- 원격: `https://github.com/BlueSky8bya/ICreaT.git`, 브랜치 `main`.
- 커밋/푸시는 **사용자가 요청할 때만**. main에서 직접 작업 전 안전 커밋(baseline) 권장.
- **제외 대상 (절대 커밋 금지):** `pbcr_source/key/`, `google-services.json`, `GoogleService-Info.plist`, keystore, SLBM 로그/`db.sqlite3`/`nohup.out`, 빌드 산출물.
- 큰 수정 전 `git status`로 목록 확인. 기본 흐름·되돌리기 상세는 `docs/git_workflow.md`.
- monorepo 구성 배경·전환 이력은 `docs/repository_plan.md` (전환 완료, 역사 보존용).

---

## 5.5 아카이브 컨벤션 (왜·언제·무엇을 영구 보존)

컨텍스트 창은 유한하다. 세션이 길어져 대화가 요약되거나 새 세션이 들어와도, **코드가 왜·언제·무엇 때문에 바뀌었는지**는 코드 옆과 폴더 아카이브에 남아 있어야 한다. 이게 이 저장소의 하네스 엔지니어링 핵심 규칙이다.

### 모든 코드/스크립트 변경 = 2단 기록 (필수)
1. **인라인 주석 태그** — 바뀐 코드 바로 위에:
   - Kotlin/Dart: `// [YYYY-MM-DD] 이유: <왜> | 목적: <무엇 달성>`
   - Python/Django: `# [YYYY-MM-DD] 이유: <왜> | 목적: <무엇 달성>`
2. **폴더 `CHANGELOG.md` 항목** — 해당 폴더 루트의 append-only 아카이브에 최신 항목을 맨 위에 추가:
   ```
   ## YYYY-MM-DD — <한 줄 제목>
   - 이유: 왜 바꿨나
   - 목적: 무엇을 달성하나
   - 파일: 건드린 파일 목록
   - 비고: 후속/주의 (선택)
   ```

### 복원 경로 (나중에 접근하는 법)
폴더 진입 → `CLAUDE.md`(역할·라우팅) → `CHANGELOG.md`(변경 이력) → 인라인 주석(정확한 라인 맥락). 이 순서면 컨텍스트 0에서도 빠르게 복구.

### 아카이브 보유 폴더
`reports/`, `Sensor_monitor/`, `Wear_os_Sensor_v3/`, `pbcr_source/`, `SLBM_hyuk-main_0730/` — 각각 `CLAUDE.md` + `CHANGELOG.md` 보유.

---

## 5.6 날짜 기준
주석/CHANGELOG의 날짜는 **작업 수행일**(실제 캘린더 날짜)을 쓴다. 상대표현("어제","지난주") 금지 — 절대날짜로.

---

## 6. 작업 태도

- 임상 데이터·업로드 식별자(`studyId`/`subjectId`) 관련 코드는 추측 금지 — 가이드 문서 확인 후 수정.
- 충분히 알면 행동한다. 이미 정해진 결정 재논의 금지.
- 테스트 실패하면 출력과 함께 그대로 보고. 건너뛴 단계는 건너뛰었다고 말한다.
