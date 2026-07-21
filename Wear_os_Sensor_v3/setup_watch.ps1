# setup_watch.ps1 — 워치 1대 셋업 자동화
# [2026-06-30] 이유: 연구 대상자 워치마다 설치 후 '권한 허용 + 사용하지 않을 때 앱 일시정지 해제 + 배터리 최적화 제외'를
#   설정 화면에서 수동으로 하기 번거롭고(앱은 시스템 설정 화면을 스크롤/토글할 수 없음), 실수로 빠뜨리기 쉬움.
# 목적: ADB로 설치~설정을 한 번에 끝낸다. 사용자가 워치 설정 화면을 만질 필요가 없게 함.
#
# 사용법(Wear_os_Sensor_v3 폴더에서):
#   .\setup_watch.ps1                              # 이미 연결된 기기에 빌드+설치+설정
#   .\setup_watch.ps1 -Serial 172.25.94.42:45097  # 해당 기기에 connect 후 진행
#   .\setup_watch.ps1 -SkipInstall                 # 설치 생략, 권한/설정만 적용
#
# 주의: 무선 페어링(adb pair, 1회성 코드 입력)은 자동화 불가 → 최초 1회는 수동으로:
#   adb pair <IP:PORT>   (코드 입력)  →  이후 이 스크립트에 -Serial <IP:PORT> 전달.

param(
    [string]$Serial = "",
    [switch]$SkipInstall
)

$ErrorActionPreference = "Stop"
$pkg = "com.gachon_HCI_Lab.wear_os_sensor_v3"

# 런타임(위험) 권한 — pm grant로 직접 부여하면 앱의 '권한' 화면을 누를 필요가 없음.
$perms = @(
    "android.permission.BODY_SENSORS",
    # [2026-07-21] Wear OS 4+: 백그라운드(화면 꺼짐) 심박 접근 = '피트니스 및 웰니스 > 항상 허용' (standalone 2bf6253 이식)
    "android.permission.BODY_SENSORS_BACKGROUND",
    "android.permission.ACTIVITY_RECOGNITION",
    "android.permission.BLUETOOTH_CONNECT",
    "android.permission.BLUETOOTH_SCAN",
    "android.permission.POST_NOTIFICATIONS"
)

function Write-Step($msg)  { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)     { Write-Host "  [OK]   $msg" -ForegroundColor Green }
function Write-Warn2($msg)  { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }

# adb 대상 인자(특정 기기 지정). 비어 있으면 연결된 단일 기기 사용.
$t = @()
if ($Serial -ne "") { $t = @("-s", $Serial) }

# adb 존재 확인
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
    Write-Warn2 "기기가 online이 아님 (state='$state'). 아래로 재연결 시도:"
    if ($Serial -ne "") {
        adb disconnect $Serial | Out-Host
        adb connect $Serial | Out-Host
        $state = (adb @t get-state) 2>$null
    }
    if ($state.Trim() -ne "device") {
        throw "기기 offline. 워치 화면을 켜고 무선 디버깅을 확인한 뒤 다시 실행하세요. (adb devices)"
    }
}
Write-OK "기기 online"

# 2) 빌드 + 설치
if (-not $SkipInstall) {
    Write-Step "빌드 + 설치 (gradlew installDebug)"
    if ($Serial -ne "") { $env:ANDROID_SERIAL = $Serial }  # 여러 기기 연결 시 대상 고정
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
        else { Write-Warn2 "$p — 부여 실패(미선언/미지원일 수 있음)" }
    } catch { Write-Warn2 "$p — 예외: $($_.Exception.Message)" }
}

# 3.5) 특수 권한 실효화 (appops) — pm grant만으론 UI에 안 켜지는 항목
# [2026-07-21] 이유: POST_NOTIFICATIONS / BODY_SENSORS_BACKGROUND는 pm grant가 exit 0([OK])을 찍어도
#   실제 게이트인 appop이 ignore로 남아 워치 설정 UI에 '거부'로 표시되는 문제 실증(7/21).
#   알림은 importance=NONE(이전 설치 잔존), 백그라운드 센서는 포그라운드 appop이 allow여야 유효.
# 목적: appop을 allow로 강제하고, 포그라운드 allow 뒤 백그라운드 권한을 재부여해 UI까지 실제 허용 반영.
Write-Step "특수 권한 실효화 (appops allow)"
# 알림: 권한 비트가 아니라 appop/importance가 실제 게이트
adb @t shell cmd appops set $pkg POST_NOTIFICATION allow 2>$null
if ($LASTEXITCODE -eq 0) { Write-OK "POST_NOTIFICATION (알림) appop allow" } else { Write-Warn2 "POST_NOTIFICATION appop 설정 실패" }
# 피트니스/웰니스: 포그라운드 appop을 먼저 allow → 그 위에서 백그라운드(항상 허용)가 유효
adb @t shell cmd appops set $pkg BODY_SENSORS allow 2>$null
if ($LASTEXITCODE -eq 0) { Write-OK "BODY_SENSORS (피트니스/웰니스) appop allow" } else { Write-Warn2 "BODY_SENSORS appop 설정 실패" }
# 포그라운드 appop이 allow된 뒤 백그라운드 권한을 재부여(순서 중요 — 먼저 grant하면 appop ignore로 되말림)
adb @t shell pm grant $pkg android.permission.BODY_SENSORS_BACKGROUND 2>$null
if ($LASTEXITCODE -eq 0) { Write-OK "BODY_SENSORS_BACKGROUND 재부여(항상 허용)" } else { Write-Warn2 "BODY_SENSORS_BACKGROUND 재부여 실패" }

# 4) '사용하지 않을 때 앱 일시정지(hibernation/auto-revoke)' 해제
Write-Step "앱 일시정지 해제 (appops AUTO_REVOKE_PERMISSIONS_IF_UNUSED = ignore)"
adb @t shell cmd appops set $pkg AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore | Out-Host
Write-OK "설정 적용"

# 5) 배터리 최적화 제외(백그라운드 지속 실행) — 연구용 워치가 OS에 의해 종료되지 않도록
Write-Step "배터리 최적화 제외 (deviceidle whitelist)"
adb @t shell dumpsys deviceidle whitelist "+$pkg" | Out-Host
Write-OK "화이트리스트 추가"

# 6) 검증
Write-Step "검증"
$revoke = (adb @t shell cmd appops get $pkg AUTO_REVOKE_PERMISSIONS_IF_UNUSED) 2>$null
Write-Host "  appops AUTO_REVOKE: $revoke"
if ("$revoke" -match "ignore") { Write-OK "일시정지 해제 확인" } else { Write-Warn2 "일시정지 상태 재확인 필요" }

$wl = (adb @t shell dumpsys deviceidle whitelist) 2>$null
if ("$wl" -match [regex]::Escape($pkg)) { Write-OK "배터리 화이트리스트 등록 확인" } else { Write-Warn2 "배터리 화이트리스트 미확인" }

Write-Host "`n--- 부여된 권한 상태 ---" -ForegroundColor Cyan
adb @t shell dumpsys package $pkg | Select-String -Pattern "BODY_SENSORS|ACTIVITY_RECOGNITION|BLUETOOTH_CONNECT|BLUETOOTH_SCAN|POST_NOTIFICATIONS" | ForEach-Object { Write-Host "  $_" }

# [2026-07-21] 특수 권한은 granted 비트만으론 UI 반영을 못 믿으므로 실제 게이트(appop)를 함께 검증
Write-Host "`n--- 특수 권한 appop 상태(실제 게이트) ---" -ForegroundColor Cyan
$noti = (adb @t shell cmd appops get $pkg POST_NOTIFICATION) 2>$null
if ("$noti" -match "allow") { Write-OK "알림(POST_NOTIFICATION) appop = allow" } else { Write-Warn2 "알림 appop 미허용: $noti" }
$body = (adb @t shell cmd appops get $pkg BODY_SENSORS) 2>$null
if ("$body" -match "allow") { Write-OK "피트니스/웰니스(BODY_SENSORS) appop = allow" } else { Write-Warn2 "BODY_SENSORS appop 미허용: $body" }

Write-Host "`n=== 셋업 완료 ===" -ForegroundColor Green
Write-Host "참고: Samsung Health [Dev mode] 등 시스템 API로 토글 불가한 항목은 여전히 수동입니다." -ForegroundColor DarkGray
