# setup_phone.ps1 — 모바일(Sensor Monitor DCT) 1대 셋업 자동화
# [2026-06-30] 이유: 폰마다 설치 후 '권한 허용 + 모든 파일 접근 + 일시정지 해제 + 배터리 최적화 제외'를
#   설정 화면에서 수동으로 하기 번거롭고 누락 위험. (워치용 setup_watch.ps1의 모바일 짝.)
# 목적: ADB로 설치~설정을 한 번에. 사용자가 폰 설정 화면을 만질 필요가 없게 함.
#
# 사용법(Sensor_monitor 폴더에서):
#   .\setup_phone.ps1                      # 연결된 기기에 빌드+설치+설정
#   .\setup_phone.ps1 -Serial <IP:PORT>    # 해당 기기 connect 후 진행
#   .\setup_phone.ps1 -SkipInstall         # 설치 생략, 권한/설정만
#
# 주의: 무선 페어링(adb pair, 1회성 코드)은 자동화 불가 → 최초 1회 수동 후 -Serial 전달.

param(
    [string]$Serial = "",
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"
# applicationId(.dct) — 기존 Sensor Monitor와 별도 패키지로 동시 설치됨.
$pkg = "com.gachon_HCI_Lab.user_mobile.dct"

# 런타임(위험) 권한 — pm grant로 직접 부여하면 앱의 '권한' 화면을 누를 필요가 없음.
# 저장소 권한은 OS 버전에 따라 미지원이라 실패해도 무시(아래 MANAGE_EXTERNAL_STORAGE가 핵심).
$perms = @(
    "android.permission.ACCESS_FINE_LOCATION",
    "android.permission.ACCESS_COARSE_LOCATION",
    "android.permission.ACCESS_BACKGROUND_LOCATION",
    "android.permission.BLUETOOTH_CONNECT",
    "android.permission.BLUETOOTH_SCAN",
    "android.permission.POST_NOTIFICATIONS",
    "android.permission.READ_EXTERNAL_STORAGE",
    "android.permission.WRITE_EXTERNAL_STORAGE"
)

function Write-Step($msg)  { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)     { Write-Host "  [OK]   $msg" -ForegroundColor Green }
function Write-Warn2($msg)  { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }

# adb 대상 인자. 비어 있으면 연결된 단일 기기 사용.
$t = @()
if ($Serial -ne "") { $t = @("-s", $Serial) }

if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    throw "adb를 PATH에서 찾을 수 없음. platform-tools를 PATH에 추가하거나 adb 경로를 확인하세요."
}

# 0) (옵션) 연결
if ($Serial -ne "" -and $Serial.Contains(":")) {
    Write-Step "기기 연결: $Serial"
    adb connect $Serial | Out-Host
}

# 1) 기기 online 확인
Write-Step "기기 상태 확인"
$state = (adb @t get-state) 2>$null
if ($LASTEXITCODE -ne 0 -or $state.Trim() -ne "device") {
    Write-Warn2 "기기가 online이 아님 (state='$state')."
    if ($Serial -ne "") {
        adb disconnect $Serial | Out-Host
        adb connect $Serial | Out-Host
        $state = (adb @t get-state) 2>$null
    }
    if ($state.Trim() -ne "device") {
        throw "기기 offline. USB 디버깅 또는 무선 디버깅을 확인한 뒤 다시 실행하세요. (adb devices)"
    }
}
Write-OK "기기 online"

# 2) 빌드 + 설치
if (-not $SkipInstall) {
    Write-Step "빌드 + 설치 (gradlew installDebug)"
    if ($Serial -ne "") { $env:ANDROID_SERIAL = $Serial }
    & "$PSScriptRoot\gradlew.bat" -p "$PSScriptRoot" installDebug
    if ($LASTEXITCODE -ne 0) { throw "installDebug 실패. 위 gradle 출력을 확인하세요." }
    Write-OK "설치 완료"
} else {
    Write-Warn2 "설치 생략(-SkipInstall). 권한/설정만 적용."
}

# 3) 런타임 권한 부여
Write-Step "런타임 권한 부여 (pm grant)"
foreach ($p in $perms) {
    try {
        adb @t shell pm grant $pkg $p 2>$null
        if ($LASTEXITCODE -eq 0) { Write-OK $p }
        else { Write-Warn2 "$p — 부여 실패(OS 버전상 미지원/미선언일 수 있음)" }
    } catch { Write-Warn2 "$p — 예외: $($_.Exception.Message)" }
}

# 4) 모든 파일 접근(MANAGE_EXTERNAL_STORAGE) — 센서 CSV를 Downloads에 읽고/쓰기 위해 필요. pm grant 불가 → appops.
Write-Step "모든 파일 접근 허용 (appops MANAGE_EXTERNAL_STORAGE = allow)"
adb @t shell appops set --uid $pkg MANAGE_EXTERNAL_STORAGE allow 2>$null
adb @t shell appops set $pkg MANAGE_EXTERNAL_STORAGE allow 2>$null
Write-OK "설정 적용(둘 중 하나 적용되면 OK)"

# 5) '사용하지 않을 때 앱 일시정지(hibernation/auto-revoke)' 해제
Write-Step "앱 일시정지 해제 (appops AUTO_REVOKE_PERMISSIONS_IF_UNUSED = ignore)"
adb @t shell cmd appops set $pkg AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore | Out-Host
Write-OK "설정 적용"

# 6) 배터리 최적화 제외 — 백그라운드 수집/업로드가 OS에 의해 종료되지 않도록
Write-Step "배터리 최적화 제외 (deviceidle whitelist)"
adb @t shell dumpsys deviceidle whitelist "+$pkg" | Out-Host
Write-OK "화이트리스트 추가"

# 7) 검증
Write-Step "검증"
$revoke = (adb @t shell cmd appops get $pkg AUTO_REVOKE_PERMISSIONS_IF_UNUSED) 2>$null
Write-Host "  appops AUTO_REVOKE: $revoke"
if ("$revoke" -match "ignore") { Write-OK "일시정지 해제 확인" } else { Write-Warn2 "일시정지 상태 재확인 필요" }

$wl = (adb @t shell dumpsys deviceidle whitelist) 2>$null
if ("$wl" -match [regex]::Escape($pkg)) { Write-OK "배터리 화이트리스트 등록 확인" } else { Write-Warn2 "배터리 화이트리스트 미확인" }

Write-Host "`n--- 부여된 권한 상태 ---" -ForegroundColor Cyan
adb @t shell dumpsys package $pkg | Select-String -Pattern "ACCESS_FINE_LOCATION|ACCESS_BACKGROUND_LOCATION|BLUETOOTH_CONNECT|BLUETOOTH_SCAN|POST_NOTIFICATIONS|MANAGE_EXTERNAL_STORAGE" | ForEach-Object { Write-Host "  $_" }

Write-Host "`n=== 셋업 완료 ===" -ForegroundColor Green
Write-Host "참고: 앱 첫 실행 시 베데스다 무인증 정책으로 로그인 없이 진입, studyId/subjectId는 테스트 하드코딩(C250005/121-001)." -ForegroundColor DarkGray
