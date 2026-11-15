$src = "c:\Users\HP\.antigravity-ide\ASTRAS"
$dst = "c:\Users\HP\.antigravity-ide\astra-mars-trainer"

Copy-Item "$src\index.html" "$src\play.html" -Force
Copy-Item "$src\index.html" "$src\play_offline.html" -Force

if (!(Test-Path $dst)) {
    New-Item -ItemType Directory -Path $dst -Force
}

Copy-Item "$src\index.html" "$dst\index.html" -Force
Copy-Item "$src\index.html" "$dst\play.html" -Force
Copy-Item "$src\index.html" "$dst\play_offline.html" -Force
Copy-Item "$src\launch_lab.js" "$dst\launch_lab.js" -Force
Copy-Item "$src\assets_data.js" "$dst\assets_data.js" -Force

if (!(Test-Path "$dst\assets")) {
    New-Item -ItemType Directory -Path "$dst\assets" -Force
}
Copy-Item "$src\assets\*" "$dst\assets\" -Recurse -Force

Write-Host "Synchronization completed successfully."

