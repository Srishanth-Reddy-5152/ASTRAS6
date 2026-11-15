$path = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$c = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
$c = $c.Replace('this.style.display="none"', "this.style.display='none'")
[System.IO.File]::WriteAllText($path, $c, [System.Text.Encoding]::UTF8)
Write-Host "Replaced successfully."

