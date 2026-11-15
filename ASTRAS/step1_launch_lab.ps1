$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Add launch_lab.js script in <head>
if ($html -notmatch 'launch_lab.js') {
    $html = $html.Replace(
        '<script src="assets_data.js"></script>',
        "<script src=`"assets_data.js`"></script>`r`n  <script src=`"launch_lab.js`"></script>"
    )
    Write-Output "Added launch_lab.js script tag."
}

# 2. Add Orbital Launch Lab button in Welcome Screen (Primary banner next to Colony Commander)
$oldWelcomeColony = '(?s)<button id="btn-welcome-colony".*?</button>'
$newWelcomeLaunchButtons = @"
<button id="btn-welcome-colony" class="col-span-1 sm:col-span-2 w-full py-3.5 px-5 rounded-2xl bg-gradient-to-r from-amber-500 via-orange-600 to-rose-600 hover:from-amber-400 hover:to-orange-500 text-white font-black text-sm sm:text-base shadow-xl shadow-orange-500/30 active:scale-95 transition-all flex items-center justify-between cursor-pointer">
          <div class="flex items-center space-x-3 text-left">
            <span class="text-3xl">????</span>
            <div>
              <div class="flex items-center space-x-2">
                <span class="font-black">LAUNCH OUTPOST COMMANDER</span>
                <span class="text-[9px] px-2 py-0.5 bg-amber-300 text-slate-950 font-extrabold rounded-full uppercase">Artemis & Ares</span>
              </div>
              <p class="text-[11px] text-amber-100 font-medium">Build station in 3D with 1,000 credits & balance survival trade-offs!</p>
            </div>
          </div>
          <span class="text-xs sm:text-sm bg-white/20 px-3 py-1.5 rounded-xl font-bold ml-2 shrink-0">PLAY ?</span>
        </button>

        <!-- NEW: 3D ORBITAL LAUNCH LAB & PLANETARY ORRERY -->
        <button id="btn-welcome-launch-lab" class="col-span-1 sm:col-span-2 w-full py-3 px-4 rounded-2xl bg-gradient-to-r from-blue-900/90 via-indigo-950 to-slate-900 hover:from-blue-800 border-2 border-cyan-400/70 text-white font-bold active:scale-95 transition-all flex items-center justify-between cursor-pointer shadow-xl group">
          <div class="flex items-center space-x-3 text-left">
            <span class="text-3xl group-hover:scale-110 transition-transform">??</span>
            <div>
              <div class="flex items-center space-x-2">
                <span class="font-black text-sm text-cyan-300">3D ORBITAL LAUNCH LAB & PLANETARY ORRERY</span>
                <span class="text-[9px] px-2 py-0.2 bg-cyan-400 text-slate-950 font-black rounded-full uppercase">NEW 3D LAB</span>
              </div>
              <p class="text-[11px] text-slate-300 font-medium">Set NASA trajectory conditions, align planetary orbits, & launch spaceships between planets!</p>
            </div>
          </div>
          <span class="text-xs bg-cyan-500/30 text-cyan-300 border border-cyan-400/50 px-3 py-1.5 rounded-xl font-bold ml-2 shrink-0">OPEN LAB ??</span>
        </button>
"@

if ([regex]::IsMatch($html, $oldWelcomeColony)) {
    $html = [regex]::Replace($html, $oldWelcomeColony, $newWelcomeLaunchButtons, 1)
    Write-Output "Added btn-welcome-launch-lab to Welcome screen."
} else {
    Write-Output "btn-welcome-colony regex did not match."
}

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Output "Step 1 complete."
