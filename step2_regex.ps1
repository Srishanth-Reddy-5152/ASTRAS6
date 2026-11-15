$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Regex replace Main Logo & Title with authentic ASTRA design logo
$patternLogo = '(?s)<!-- Main Logo & Title -->\s*<div class="space-y-1 pt-0.5">.*?</div>\s*</div>'
$newLogo = @"
<!-- Main Logo & Title with Authentic Design Sheet Artwork -->
      <div class="space-y-2 pt-1 flex flex-col items-center">
        <img src="assets/astra_logo.png" alt="ASTRA Junior Astronaut Mission Trainer" class="max-h-24 sm:max-h-28 object-contain filter drop-shadow-[0_8px_20px_rgba(56,189,248,0.45)] hover:scale-105 transition-transform cursor-pointer" onclick="audioService.playChime()" onerror="this.onerror=null; if(window.ASTRAS_ASSETS && window.ASTRAS_ASSETS['astra_logo']) this.src=window.ASTRAS_ASSETS['astra_logo'];">
        <div class="inline-flex items-center space-x-2 px-3 py-0.5 rounded-full bg-sky-500/15 border border-sky-500/30 text-sky-300 text-[11px] font-bold uppercase tracking-widest glow-cyan">
          <span>? Train • Explore • Decide • Discover</span>
        </div>
        <p class="text-xs sm:text-sm font-bold text-slate-300 tracking-wide">
          NASA Engineering Trade-Offs & Planetary Outpost Simulator
        </p>
      </div>
"@

if ([regex]::IsMatch($html, $patternLogo)) {
    $html = [regex]::Replace($html, $patternLogo, $newLogo)
    Write-Output "Applied ASTRA logo replacement."
} else {
    Write-Output "Logo regex did not match."
}

# 2. Regex replace Destination Screen Cards with 4 Authentic Environments
$patternDest = '(?s)<!-- Destination Choice Cards -->\s*<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">.*?<!-- Choice 2: Mars Jezero Crater -->.*?</div>\s*</div>'
$newDest = @"
<!-- Destination Choice Cards: 4 Space Environments with Design Sheet Art -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
        
        <!-- Choice 1: Moon Base -->
        <button id="btn-select-moon" class="p-3.5 rounded-3xl bg-slate-800/85 hover:bg-slate-750 border-2 border-slate-700 hover:border-cyan-400 text-left transition-all group flex flex-col justify-between space-y-2 cursor-pointer shadow-lg">
          <div class="space-y-2">
            <div class="relative w-full h-24 rounded-2xl overflow-hidden border border-cyan-500/30">
              <img src="assets/env_moon.png" alt="Moon Base" class="w-full h-full object-cover group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['env_moon'];">
              <div class="absolute top-2 left-2 flex items-center space-x-1.5 px-2 py-0.5 rounded-full bg-slate-950/80 backdrop-blur-md border border-cyan-400/40">
                <img src="assets/planet_moon.png" class="w-4 h-4 rounded-full" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['planet_moon'];">
                <span class="text-[9px] font-mono font-bold text-cyan-300 uppercase">Moon Base</span>
              </div>
              <span class="absolute top-2 right-2 text-[9px] px-2 py-0.5 rounded-full bg-cyan-500/20 text-cyan-300 font-bold uppercase">LOLA Altimetry</span>
            </div>
            <h3 class="text-sm font-black text-white group-hover:text-cyan-300">Lunar South Pole (Shackleton Rim)</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              0.166g low gravity lets you jump 6x higher than Earth. Sunlit rim peaks contrast with pitch-black crater floors harboring billions of tons of water ice.
            </p>
          </div>
          <div class="pt-1.5 border-t border-slate-700/60 text-[10px] font-mono text-cyan-400 flex justify-between">
            <span>Elevation: -4.2km</span>
            <span>Lag: 1.3s</span>
            <span>Night: 14 Earth Days</span>
          </div>
          <div class="w-full py-1.5 rounded-xl bg-cyan-600/30 group-hover:bg-cyan-500 text-cyan-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Deploy Artemis Base ?
          </div>
        </button>

        <!-- Choice 2: Mars Colony -->
        <button id="btn-select-mars" class="p-3.5 rounded-3xl bg-slate-800/85 hover:bg-slate-750 border-2 border-slate-700 hover:border-orange-400 text-left transition-all group flex flex-col justify-between space-y-2 cursor-pointer shadow-lg">
          <div class="space-y-2">
            <div class="relative w-full h-24 rounded-2xl overflow-hidden border border-orange-500/30">
              <img src="assets/env_mars.png" alt="Mars Colony" class="w-full h-full object-cover group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['env_mars'];">
              <div class="absolute top-2 left-2 flex items-center space-x-1.5 px-2 py-0.5 rounded-full bg-slate-950/80 backdrop-blur-md border border-orange-400/40">
                <img src="assets/planet_mars.png" class="w-4 h-4 rounded-full" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['planet_mars'];">
                <span class="text-[9px] font-mono font-bold text-orange-300 uppercase">Mars Colony</span>
              </div>
              <span class="absolute top-2 right-2 text-[9px] px-2 py-0.5 rounded-full bg-orange-500/20 text-orange-300 font-bold uppercase">MOLA Altimetry</span>
            </div>
            <h3 class="text-sm font-black text-white group-hover:text-orange-300">Mars Jezero Crater (Ares Colony)</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              Landing site of Perseverance rover! Ancient river delta fan with layered clay carbonate strata. Thin 610 Pa atmosphere. Dust storms blot out sunlight.
            </p>
          </div>
          <div class="pt-1.5 border-t border-slate-700/60 text-[10px] font-mono text-orange-400 flex justify-between">
            <span>Elevation: -2.5km</span>
            <span>Lag: 4-20m</span>
            <span>Hazard: Dust Storms</span>
          </div>
          <div class="w-full py-1.5 rounded-xl bg-orange-600/30 group-hover:bg-orange-500 text-orange-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Deploy Ares Base ?
          </div>
        </button>

        <!-- Choice 3: ISS / Earth Orbit -->
        <button id="btn-select-iss" class="p-3.5 rounded-3xl bg-slate-800/85 hover:bg-slate-750 border-2 border-slate-700 hover:border-blue-400 text-left transition-all group flex flex-col justify-between space-y-2 cursor-pointer shadow-lg">
          <div class="space-y-2">
            <div class="relative w-full h-24 rounded-2xl overflow-hidden border border-blue-500/30">
              <img src="assets/env_iss.png" alt="ISS Earth Orbit" class="w-full h-full object-cover group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['env_iss'];">
              <div class="absolute top-2 left-2 flex items-center space-x-1.5 px-2 py-0.5 rounded-full bg-slate-950/80 backdrop-blur-md border border-blue-400/40">
                <img src="assets/planet_iss.png" class="w-4 h-4 rounded-full" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['planet_iss'];">
                <span class="text-[9px] font-mono font-bold text-blue-300 uppercase">Earth Orbit</span>
              </div>
              <span class="text-[9px] px-2 py-0.5 rounded-full bg-blue-500/20 text-blue-300 font-bold uppercase absolute top-2 right-2">Microgravity</span>
            </div>
            <h3 class="text-sm font-black text-white group-hover:text-blue-300">ISS Cupola & Earth Orbit</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              Microgravity space research lab orbiting Earth every 90 minutes. High solar panel output with zero atmosphere drag.
            </p>
          </div>
          <div class="pt-1.5 border-t border-slate-700/60 text-[10px] font-mono text-blue-400 flex justify-between">
            <span>Altitude: 408 km</span>
            <span>Speed: 27,600 km/h</span>
            <span>Comms: Instant</span>
          </div>
          <div class="w-full py-1.5 rounded-xl bg-blue-600/30 group-hover:bg-blue-500 text-blue-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Enter Earth Orbit ?
          </div>
        </button>

        <!-- Choice 4: Deep Space Gateway -->
        <button id="btn-select-deepspace" class="p-3.5 rounded-3xl bg-slate-800/85 hover:bg-slate-750 border-2 border-slate-700 hover:border-purple-400 text-left transition-all group flex flex-col justify-between space-y-2 cursor-pointer shadow-lg">
          <div class="space-y-2">
            <div class="relative w-full h-24 rounded-2xl overflow-hidden border border-purple-500/30">
              <img src="assets/env_deepspace.png" alt="Deep Space" class="w-full h-full object-cover group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['env_deepspace'];">
              <div class="absolute top-2 left-2 flex items-center space-x-1.5 px-2 py-0.5 rounded-full bg-slate-950/80 backdrop-blur-md border border-purple-400/40">
                <img src="assets/planet_deepspace.png" class="w-4 h-4 rounded-full" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['planet_deepspace'];">
                <span class="text-[9px] font-mono font-bold text-purple-300 uppercase">Deep Space</span>
              </div>
              <span class="text-[9px] px-2 py-0.5 rounded-full bg-purple-500/20 text-purple-300 font-bold uppercase absolute top-2 right-2">DSN Network</span>
            </div>
            <h3 class="text-sm font-black text-white group-hover:text-purple-300">Deep Space Gateway & Rings</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              Outpost situated in cislunar space. Outside Earth's protective magnetic field, vulnerable to intense cosmic radiation.
            </p>
          </div>
          <div class="pt-1.5 border-t border-slate-700/60 text-[10px] font-mono text-purple-400 flex justify-between">
            <span>Range: 1,500,000 km</span>
            <span>DSN: 70m Antennas</span>
            <span>Radiation: Extreme</span>
          </div>
          <div class="w-full py-1.5 rounded-xl bg-purple-600/30 group-hover:bg-purple-500 text-purple-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Launch Deep Space ?
          </div>
        </button>

      </div>
"@

if ([regex]::IsMatch($html, $patternDest)) {
    $html = [regex]::Replace($html, $patternDest, $newDest)
    Write-Output "Applied Destination 4 environments replacement."
} else {
    Write-Output "Destination regex did not match."
}

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Output "Step 2 executed successfully."
