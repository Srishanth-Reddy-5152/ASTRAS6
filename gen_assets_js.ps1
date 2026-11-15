$assetsDir = "c:\Users\HP\.antigravity-ide\ASTRAS\assets"
$outputJs = "c:\Users\HP\.antigravity-ide\ASTRAS\assets_data.js"

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("// ASTRAS Auto-Generated Assets Data (Base64 + Relative)")
[void]$sb.AppendLine("const ASTRAS_ASSETS = {")

$files = Get-ChildItem -Path $assetsDir -Filter "*.png"
foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $b64 = [System.Convert]::ToBase64String($bytes)
    $key = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    [void]$sb.AppendLine("  '$key': 'data:image/png;base64,$b64',")
}

[void]$sb.AppendLine("};")
[void]$sb.AppendLine("if (typeof window !== 'undefined') { window.ASTRAS_ASSETS = ASTRAS_ASSETS; }")

[System.IO.File]::WriteAllText($outputJs, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Generated assets_data.js with $($files.Count) assets, size: $((Get-Item $outputJs).Length) bytes"
