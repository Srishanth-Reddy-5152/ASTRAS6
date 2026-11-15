Add-Type -AssemblyName System.Drawing

$src = [System.Drawing.Image]::FromFile("c:\Users\HP\.antigravity-ide\ASTRAS\astra_design_sheet.jpg")
Write-Output "Image size: $($src.Width) x $($src.Height)"

# Draw a grid overlay on a copy to read exact pixel coordinates
$bmp = New-Object System.Drawing.Bitmap($src)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$pen100 = New-Object System.Drawing.Pen([System.Drawing.Color]::Yellow, 1)
$pen50 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 255, 255, 0), 1)
$font = New-Object System.Drawing.Font("Arial", 8)
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)

for ($x = 0; $x -lt $src.Width; $x += 50) {
    $pen = if ($x % 100 -eq 0) { $pen100 } else { $pen50 }
    $g.DrawLine($pen, $x, 0, $x, $src.Height)
    if ($x % 100 -eq 0) { $g.DrawString("$x", $font, $brush, [float]($x + 2), 2.0) }
}
for ($y = 0; $y -lt $src.Height; $y += 50) {
    $pen = if ($y % 100 -eq 0) { $pen100 } else { $pen50 }
    $g.DrawLine($pen, 0, $y, $src.Width, $y)
    if ($y % 100 -eq 0) { $g.DrawString("$y", $font, $brush, 2.0, [float]($y + 2)) }
}

$bmp.Save("c:\Users\HP\.antigravity-ide\ASTRAS\assets\grid_overlay.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g.Dispose()
$bmp.Dispose()
$src.Dispose()
Write-Output "Grid overlay saved."
