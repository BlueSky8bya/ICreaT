# Git 운용 메모

이 저장소는 `https://github.com/BlueSky8bya/ICreaT.git`를 원격 저장소로 사용합니다.

## 기본 흐름

```bash
git status
git add <수정한 파일>
git commit -m "작업 내용 요약"
git push origin main
```

## 수정 전 안전 지점 만들기

큰 수정 전에는 현재 상태를 커밋해두면 돌아가기 쉽습니다.

```bash
git status
git add .
git commit -m "baseline before bethesda integration"
```

## 최근 커밋으로 돌아가기

작업 중인 변경을 버리기 전에는 반드시 `git status`로 목록을 확인하세요.

```bash
git restore <파일>
```

이미 커밋한 변경을 되돌릴 때는 기록을 보존하는 `revert`가 안전합니다.

```bash
git revert <commit-sha>
```

## 주의

`pbcr_source/key/`, keystore, Firebase 설정 파일, 로그, 빌드 산출물은 `.gitignore`로 제외했습니다. 실제 운영 키가 GitHub에 올라가지 않도록 계속 확인해야 합니다.

현재 `Sensor_monitor/` 폴더 안에는 기존 별도 Git 저장소가 들어 있습니다. 루트 `ICreaT` 저장소에서 `Sensor_monitor`의 실제 파일까지 함께 추적하려면, 기존 `Sensor_monitor/.git`을 백업하거나 제거한 뒤 루트 저장소에서 다시 추가해야 합니다.
