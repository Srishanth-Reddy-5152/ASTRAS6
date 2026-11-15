Add-Type -AssemblyName System.Drawing

function Crop-Image($srcPath, $dstPath, $x, $y, $w, $h) {
    $src = [System.Drawing.Image]::FromFile($srcPath)
    if ($x + $w -gt $src.Width) { $w = $src.Width - $x }
    if ($y + $h -gt $src.Height) { $h = $src.Height - $y }
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($src, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $bmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    $src.Dispose()
}

$assetsDir = "c:\Users\HP\.antigravity-ide\ASTRAS\assets"
$src = "c:\Users\HP\.antigravity-ide\ASTRAS\astra_design_sheet.jpg"

# 1. Logo
Crop-Image $src "$assetsDir\astra_logo.png" 10 20 220 135

# 2. Characters Full & Headshot Avatars
Crop-Image $src "$assetsDir\char_leo_full.png" 250 50 92 152
Crop-Image $src "$assetsDir\char_leo_avatar.png" 256 50 78 78
Crop-Image $src "$assetsDir\char_maya_full.png" 342 58 78 144
Crop-Image $src "$assetsDir\char_maya_avatar.png" 344 60 74 74
Crop-Image $src "$assetsDir\char_arin_full.png" 420 50 76 152
Crop-Image $src "$assetsDir\char_arin_avatar.png" 422 52 70 74
Crop-Image $src "$assetsDir\char_tara_full.png" 488 66 74 136
Crop-Image $src "$assetsDir\char_tara_avatar.png" 490 68 68 72

# 3. AI Companion NOVA (Full & Expressions)
Crop-Image $src "$assetsDir\nova_companion.png" 698 55 142 148
Crop-Image $src "$assetsDir\nova_neutral.png" 880 88 48 48
Crop-Image $src "$assetsDir\nova_excited.png" 936 88 48 48
Crop-Image $src "$assetsDir\nova_happy.png" 880 142 48 48
Crop-Image $src "$assetsDir\nova_loving.png" 936 142 48 48
Crop-Image $src "$assetsDir\nova_surprised.png" 880 196 48 48
Crop-Image $src "$assetsDir\nova_talking.png" 936 196 48 48

# 4. Environments (inner image without card borders)
Crop-Image $src "$assetsDir\env_iss.png" 16 226 110 88
Crop-Image $src "$assetsDir\env_moon.png" 135 226 110 88
Crop-Image $src "$assetsDir\env_mars.png" 254 226 110 88
Crop-Image $src "$assetsDir\env_deepspace.png" 372 226 110 88

# 5. Equipment & Tools
Crop-Image $src "$assetsDir\tool_helmet.png" 508 236 54 50
Crop-Image $src "$assetsDir\tool_backpack.png" 578 236 50 50
Crop-Image $src "$assetsDir\tool_tablet.png" 642 236 46 50
Crop-Image $src "$assetsDir\tool_rover.png" 708 236 66 50
Crop-Image $src "$assetsDir\tool_torch.png" 512 298 50 40
Crop-Image $src "$assetsDir\tool_medkit.png" 578 298 48 40
Crop-Image $src "$assetsDir\tool_vial.png" 652 298 32 42
Crop-Image $src "$assetsDir\tool_wrench.png" 720 298 48 42

# 6. UI Icons
Crop-Image $src "$assetsDir\icon_star.png" 805 230 38 38
Crop-Image $src "$assetsDir\icon_trophy.png" 855 230 38 38
Crop-Image $src "$assetsDir\icon_medal.png" 904 230 38 38
Crop-Image $src "$assetsDir\icon_shield.png" 946 230 38 38
Crop-Image $src "$assetsDir\icon_heart.png" 805 274 36 34
Crop-Image $src "$assetsDir\icon_power.png" 856 274 34 36
Crop-Image $src "$assetsDir\icon_o2.png" 904 274 36 36
Crop-Image $src "$assetsDir\icon_water.png" 950 274 32 36

# 7. Planet Orbs (inner circles)
Crop-Image $src "$assetsDir\planet_iss.png" 22 392 70 70
Crop-Image $src "$assetsDir\planet_moon.png" 106 392 70 70
Crop-Image $src "$assetsDir\planet_mars.png" 184 392 70 70
Crop-Image $src "$assetsDir\planet_deepspace.png" 260 392 70 70

# 8. Mission Briefing Image
Crop-Image $src "$assetsDir\mission_rover_photo.png" 348 388 105 105

# 9. In-Game HUD Elements
Crop-Image $src "$assetsDir\hud_radar.png" 900 384 80 80
Crop-Image $src "$assetsDir\hud_scene_preview.png" 610 376 370 148

# 10. Result Screens & Achievements
Crop-Image $src "$assetsDir\badge_mission_expert.png" 154 564 42 46
Crop-Image $src "$assetsDir\nova_mission_failed.png" 318 592 70 70
Crop-Image $src "$assetsDir\nova_mission_success.png" 472 592 70 70

# 11. Character Poses
Crop-Image $src "$assetsDir\pose_idle.png" 646 565 38 95
Crop-Image $src "$assetsDir\pose_waving.png" 700 565 44 95
Crop-Image $src "$assetsDir\pose_pointing.png" 754 565 48 95
Crop-Image $src "$assetsDir\pose_jumping.png" 818 560 46 95
Crop-Image $src "$assetsDir\pose_kneeling.png" 875 590 42 70
Crop-Image $src "$assetsDir\pose_scanning.png" 938 575 42 85

Write-Output "Refined crops complete. Total files: $((Get-ChildItem $assetsDir).Count)"
