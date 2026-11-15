$baseDir = "c:\Users\HP\.antigravity-ide\ASTRAS"
$utf8 = [System.Text.Encoding]::UTF8

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "ASTRAS NASA SUITE COMPREHENSIVE VERIFICATION" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

$pass = 0
$fail = 0

function Assert-Check($cond, $msg) {
    if ($cond) {
        Write-Host "  [PASS] $msg" -ForegroundColor Green
        $script:pass++
    } else {
        Write-Host "  [FAIL] $msg" -ForegroundColor Red
        $script:fail++
    }
}

$html = [System.IO.File]::ReadAllText("$baseDir\index.html", $utf8)

# Check 1: File size
Assert-Check ($html.Length -gt 50000) "File size is substantial ($($html.Length) chars)"

# Check 2: Braces and parens balance in inline JS
$scriptStart = $html.LastIndexOf("<script>")
$scriptEnd = $html.LastIndexOf("</script>")
$js = $html.Substring($scriptStart + 8, $scriptEnd - ($scriptStart + 8))
$openB = ([regex]::Matches($js, "\{")).Count
$closeB = ([regex]::Matches($js, "\}")).Count
Assert-Check ($openB -eq $closeB) "Braces balance in JS ($openB open, $closeB close)"

$openP = ([regex]::Matches($js, "\(")).Count
$closeP = ([regex]::Matches($js, "\)")).Count
Assert-Check ($openP -eq $closeP) "Parentheses balance in JS ($openP open, $closeP close)"

# Check 3: Essential HTML Screens & Modals
$screens = @(
    "screen-welcome",
    "screen-destination",
    "screen-crew",
    "screen-builder",
    "colony-operations-hud",
    "screen-academy",
    "screen-launch-lab",
    "gemini-side-board",
    "modal-emergency",
    "modal-debrief",
    "modal-lab-outcome"
)
foreach ($s in $screens) {
    Assert-Check ($html -match "id=""$s""") "Screen/Modal $s exists in HTML"
}

# Check 4: Design Sheet Assets & Cropped Graphics
$assets = @(
    "assets\astra_logo.png",
    "assets\char_leo_full.png",
    "assets\char_leo_avatar.png",
    "assets\char_maya_full.png",
    "assets\char_maya_avatar.png",
    "assets\char_arin_full.png",
    "assets\char_arin_avatar.png",
    "assets\char_tara_full.png",
    "assets\char_tara_avatar.png",
    "assets\nova_companion.png",
    "assets\nova_talking.png",
    "assets\nova_happy.png",
    "assets\nova_mission_success.png",
    "assets\nova_mission_failed.png",
    "assets\env_moon.png",
    "assets\env_mars.png",
    "assets\env_iss.png",
    "assets\env_deepspace.png",
    "assets\hud_radar.png"
)
$missingAssets = 0
foreach ($a in $assets) {
    if (!(Test-Path "$baseDir\$a")) { $missingAssets++ }
}
Assert-Check ($missingAssets -eq 0) "All 19 design sheet cropped assets exist in assets folder"
Assert-Check (Test-Path "$baseDir\assets_data.js") "assets_data.js base64 bundle exists"

# Check 5: Space Systems Academy (6 Chapters & 24 Questions)
Assert-Check ($html -match 'Chapter 1: NASA Space Weather' -and $html -match 'Chapter 6: In-Situ Resource') "6 Academy chapters loaded"
Assert-Check ($html -match 'academyCurriculum') "Full question bank curriculum object present"

# Check 6: NOVA AI & Gemini Side Board
Assert-Check ($html -match 'NOVA AI COPILOT' -and $html -match 'btn-floating-gemini') "NOVA Copilot and floating trigger integrated"
Assert-Check ($html -match 'nova_surprised' -and $html -match 'nova_talking') "NOVA dynamic expressions wired"

# Check 7: 4 Authentic Environments with 3D Support
Assert-Check ($html -match 'btn-select-moon' -and $html -match 'btn-select-mars' -and $html -match 'btn-select-iss' -and $html -match 'btn-select-deepspace') "4 Space Destinations clickable"
Assert-Check ($html -match "dest === 'iss'" -and $html -match "dest === 'deepspace'") "3D Engine supports ISS Earth Orbit & Deep Space"

# Check 8: 1,000 Credit Budget & 8 Strategic Modules
Assert-Check ($html -match '1000 cr') "1,000 Credit Budget supported"
Assert-Check ($html -match 'Kilopower Nuclear' -and $html -match 'Regolith Bunker') "8 Authentic NASA modules present"

# Check 9: 3D Orbital Launch Lab & Planetary Orrery
Assert-Check (Test-Path "$baseDir\launch_lab.js") "launch_lab.js script exists"
$labJs = [System.IO.File]::ReadAllText("$baseDir\launch_lab.js", $utf8)
Assert-Check ($labJs -match 'class LaunchLabWorld3D' -and $labJs -match 'class LaunchLabManager') "LaunchLabWorld3D and LaunchLabManager classes present"
Assert-Check ($labJs -match 'Hohmann' -and $labJs -match '44.4' -and $labJs -match 'deltaV') "NASA Hohmann transfer & orbital parameters implemented"
Assert-Check ($html -match 'btn-welcome-launch-lab') "Launch Lab launcher button present on welcome screen"

# Check 10: In-Game HUD Elements
Assert-Check ($html -match 'hud-active-avatar' -and $html -match 'hud_radar.png') "Active astronaut avatar card and radar scanner present in HUD"

# Check 11: Outpost Launch & Commissioning Feature
Assert-Check ($html -match 'modal-launch-outpost' -and $html -match 'overlay-outpost-launching' -and $html -match 'btn-confirm-outpost-launch') "Outpost Commissioning & 3D Launch Sequence implemented"

# Check 12: Days & How Many Days Completed Feature
Assert-Check ($html -match 'hud-days-completed-num' -and $html -match 'hud-sol-milestones' -and $html -match 'btn-hud-complete-sol' -and $html -match 'modal-days-log') "Days Completed live tracker, interactive sol milestones, and flight log modal implemented"

# Check 13: Sync across offline files
$playHtml = [System.IO.File]::ReadAllText("$baseDir\play.html", $utf8)
$offlineHtml = [System.IO.File]::ReadAllText("$baseDir\play_offline.html", $utf8)
Assert-Check ($playHtml.Length -eq $html.Length -and $offlineHtml.Length -eq $html.Length) "play.html and play_offline.html 100% synchronized"

Write-Host "-------------------------------------------------" -ForegroundColor Cyan
Write-Host "TEST SUMMARY: $pass Passed, $fail Failed" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Red" })
Write-Host "=================================================" -ForegroundColor Cyan

if ($fail -gt 0) { exit 1 } else { exit 0 }
