# ICREAT 저장소 구성 메모

루트 저장소:

- 경로: `C:\projects\iCreat`
- 원격: `https://github.com/BlueSky8bya/ICreaT.git`
- 브랜치: `main`

## 현재 상태

루트 `ICreaT` 저장소는 새로 초기화되어 원격이 연결되었습니다. 아직 커밋/푸시는 하지 않았습니다.

하위 폴더 중 아래 두 곳은 이미 별도 Git 저장소입니다.

| 경로 | 기존 원격 |
|---|---|
| `Sensor_monitor/` | `https://github.com/BlueSky8bya/Sensor_monitor.git` |
| `Wear_os_Sensor_v3/` | `https://github.com/BlueSky8bya/Wear_os_Sensor_v3.git` |

이 상태에서 루트에서 `git add .`를 하면 두 폴더가 일반 파일 묶음이 아니라 embedded repository로 잡힙니다. 그러면 `ICreaT.git`를 새로 clone한 사람이 `Sensor_monitor`, `Wear_os_Sensor_v3`의 실제 파일 내용을 받지 못할 수 있습니다.

## 권장 방향

전체 프로젝트를 하나의 GitHub repo에서 함께 롤백하고 관리하려면 monorepo 방식이 가장 단순합니다.

절차:

1. `Sensor_monitor/.git`, `Wear_os_Sensor_v3/.git`을 백업
2. 두 폴더의 `.git` 디렉터리를 제거 또는 외부 백업 위치로 이동
3. 루트 `ICreaT` 저장소에서 실제 파일 전체를 추적
4. 민감 키, 빌드 산출물, 로그, DB 파일은 `.gitignore`로 제외
5. 첫 baseline 커밋 생성
6. `origin main`으로 push

## 대안

기존 `Sensor_monitor`, `Wear_os_Sensor_v3` repo를 독립적으로 계속 유지하고 싶다면 submodule 방식도 가능합니다. 다만 submodule은 clone, checkout, rollback 절차가 더 번거롭습니다. 현재처럼 전체 프로젝트를 한 번에 수정하고 되돌리는 목적에는 monorepo가 더 편합니다.

## 첫 커밋 전 확인할 것

- `pbcr_source/key/`는 제외되어야 합니다.
- `google-services.json`, `GoogleService-Info.plist`, keystore 파일은 제외되어야 합니다.
- `SLBM_hyuk-main_0730`의 로그, `db.sqlite3`, `nohup.out`은 제외되어야 합니다.
- `Sensor_monitor/sensor_data.zip`은 베데스다 연동 샘플로 포함할지 최종 확인해야 합니다.
