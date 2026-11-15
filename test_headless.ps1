$url = "file:///c:/Users/HP/.antigravity-ide/ASTRAS/play_offline.html"
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (!(Test-Path $edgePath)) {
    $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}

Write-Output "Testing Edge at: $edgePath"
# Launch Edge in headless dump mode
$proc = Start-Process -FilePath $edgePath -ArgumentList "--headless", "--dump-dom", "--virtual-time-budget=2000", "$url" -NoNewWindow -PassThru -RedirectStandardOutput "c:\Users\HP\.antigravity-ide\ASTRAS\headless_dom.txt" -RedirectStandardError "c:\Users\HP\.antigravity-ide\ASTRAS\headless_err.txt"
$proc.WaitForExit(5000)

$out = Get-Content "c:\Users\HP\.antigravity-ide\ASTRAS\headless_dom.txt" -Raw
Write-Output "DOM Length: $($out.Length)"
$err = Get-Content "c:\Users\HP\.antigravity-ide\ASTRAS\headless_err.txt" -Raw
Write-Output "Errors: $err"
