$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Update Welcome Screen Logo & Title
$oldTitle = @"
      <!-- Main Logo & Title -->
      <div class="space-y-1 pt-0.5">
        <div class="inline-flex items-center space-x-2 px-3.5 py-1 rounded-full bg-sky-500/15 border border-sky-500/30 text-sky-300 text-xs font-bold uppercase tracking-widest glow-cyan">
          <span>? ASTRAS OUTPOST COMMANDER</span>
        </div>
        <h1 class="text-4xl sm:text-5xl font-black text-white tracking-tight leading-none">
          ASTRAS
        </h1>
        <p class="text-xs sm:text-base font-bold text-sky-400 tracking-wide uppercase">
          NASA Engineering Trade-Offs & Planetary Science Simulator
        </p>
      </div>
"@

$newTitle = @"
      <!-- Main Logo & Title with Authentic Design Sheet Artwork -->
      <div class="space-y-2 pt-1 flex flex-col items-center">
        <img src="assets/astra_logo.png" alt="ASTRA Junior Astronaut Mission Trainer" class="max-h-24 sm:max-h-28 object-contain filter drop-shadow-[0_8px_20px_rgba(56,189,248,0.45)] hover:scale-105 transition-transform cursor-pointer" onclick="audioService.playChime()" onerror="this.onerror=null; if(window.ASTRAS_ASSETS && window.ASTRAS_ASSETS['astra_logo']) this.src=window.ASTRAS_ASSETS['astra_logo'];">
        <div class="inline-flex items-center space-x-2 px-3.5 py-1 rounded-full bg-sky-500/15 border border-sky-500/30 text-sky-300 text-xs font-bold uppercase tracking-widest glow-cyan">
          <span>? Train • Explore • Decide • Discover</span>
        </div>
        <p class="text-xs sm:text-sm font-bold text-slate-300 tracking-wide">
          NASA Engineering Trade-Offs & Planetary Outpost Simulator
        </p>
      </div>
"@

if ($html.Contains($oldTitle)) {
    $html = $html.Replace($oldTitle, $newTitle)
    Write-Output "Updated Welcome screen logo."
} else {
    Write-Output "Warning: Old title block not matched exactly."
}

# 2. Add Cadet Crew Showcase Ribbon in Welcome Screen (before Core Navigation Launchers)
$oldNavStart = @"
      <!-- Core Navigation Launchers -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5 pt-0.5">
"@

$newNavStart = @"
      <!-- ASTRONAUT CADET CREW SHOWCASE RIBBON -->
      <div class="p-3 rounded-2xl bg-slate-900/90 border border-slate-800 shadow-xl backdrop-blur-md">
        <div class="flex items-center justify-between pb-2 border-b border-slate-800/80 mb-2">
          <div class="flex items-center space-x-2">
            <span class="text-xs font-mono font-bold text-amber-300 uppercase tracking-wider">????? CREW SPECIALISTS</span>
            <span class="text-[10px] text-slate-400">Click to preview voices & suits</span>
          </div>
          <span class="text-[10px] font-mono text-sky-400">Artemis & Ares Squad</span>
        </div>
        <div class="grid grid-cols-4 gap-2">
          <!-- Cadet Leo -->
          <button class="btn-welcome-char p-2 rounded-xl bg-slate-950/70 hover:bg-sky-950/60 border border-slate-800 hover:border-sky-400/80 transition-all text-center group cursor-pointer" data-char="leo">
            <img src="assets/char_leo_avatar.png" class="w-12 h-12 sm:w-14 sm:h-14 mx-auto rounded-xl object-contain border border-sky-400/30 group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_leo_avatar'];">
            <span class="text-[11px] font-black text-white block mt-1">Leo</span>
            <span class="text-[9px] text-sky-300 font-mono block">Cadet Pilot</span>
          </button>
          <!-- Specialist Maya -->
          <button class="btn-welcome-char p-2 rounded-xl bg-slate-950/70 hover:bg-sky-950/60 border border-slate-800 hover:border-sky-400/80 transition-all text-center group cursor-pointer" data-char="maya">
            <img src="assets/char_maya_avatar.png" class="w-12 h-12 sm:w-14 sm:h-14 mx-auto rounded-xl object-contain border border-sky-400/30 group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_maya_avatar'];">
            <span class="text-[11px] font-black text-white block mt-1">Maya</span>
            <span class="text-[9px] text-sky-300 font-mono block">Specialist</span>
          </button>
          <!-- Dr. Arin -->
          <button class="btn-welcome-char p-2 rounded-xl bg-slate-950/70 hover:bg-orange-950/60 border border-slate-800 hover:border-orange-400/80 transition-all text-center group cursor-pointer" data-char="arin">
            <img src="assets/char_arin_avatar.png" class="w-12 h-12 sm:w-14 sm:h-14 mx-auto rounded-xl object-contain border border-orange-400/30 group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_arin_avatar'];">
            <span class="text-[11px] font-black text-white block mt-1">Dr. Arin</span>
            <span class="text-[9px] text-orange-300 font-mono block">Engineer</span>
          </button>
          <!-- Dr. Tara -->
          <button class="btn-welcome-char p-2 rounded-xl bg-slate-950/70 hover:bg-purple-950/60 border border-slate-800 hover:border-purple-400/80 transition-all text-center group cursor-pointer" data-char="tara">
            <img src="assets/char_tara_avatar.png" class="w-12 h-12 sm:w-14 sm:h-14 mx-auto rounded-xl object-contain border border-purple-400/30 group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_tara_avatar'];">
            <span class="text-[11px] font-black text-white block mt-1">Dr. Tara</span>
            <span class="text-[9px] text-purple-300 font-mono block">Botanist</span>
          </button>
        </div>
      </div>

      <!-- Core Navigation Launchers -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5 pt-0.5">
"@

if ($html.Contains($oldNavStart)) {
    $html = $html.Replace($oldNavStart, $newNavStart)
    Write-Output "Added Cadet Crew Showcase Ribbon."
} else {
    Write-Output "Warning: oldNavStart not matched."
}

# 3. Update Gemini & Profile launchers on Welcome Screen
$oldGeminiBtn = @"
        <!-- Gemini AI Copilot Trigger -->
        <button id="btn-welcome-gemini-chat" class="w-full py-3 px-4 rounded-2xl bg-gradient-to-r from-purple-950/80 to-slate-900 border-2 border-purple-500/70 text-purple-300 font-bold active:scale-95 transition-all flex items-center space-x-3 text-left cursor-pointer shadow-lg">
          <span class="text-2xl">??</span>
          <div>
            <div class="text-xs font-black text-white">Gemini Space Copilot</div>
            <div class="text-[10px] text-purple-300">Ask any question to NASA AI</div>
          </div>
        </button>
"@

$newGeminiBtn = @"
        <!-- Gemini AI Copilot Trigger (NOVA AI Companion) -->
        <button id="btn-welcome-gemini-chat" class="w-full py-3 px-4 rounded-2xl bg-gradient-to-r from-purple-950/80 to-slate-900 border-2 border-purple-500/70 text-purple-300 font-bold active:scale-95 transition-all flex items-center space-x-3 text-left cursor-pointer shadow-lg group">
          <img src="assets/nova_companion.png" class="w-9 h-9 object-contain filter drop-shadow group-hover:scale-110 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['nova_companion'];">
          <div>
            <div class="text-xs font-black text-white flex items-center space-x-1.5">
              <span>NOVA AI Copilot</span>
              <span class="text-[9px] px-1.5 py-0.2 rounded-full bg-purple-500/30 text-purple-200">Gemini</span>
            </div>
            <div class="text-[10px] text-purple-300">Ask anything to NASA Space AI</div>
          </div>
        </button>
"@

if ($html.Contains($oldGeminiBtn)) {
    $html = $html.Replace($oldGeminiBtn, $newGeminiBtn)
    Write-Output "Updated Gemini launcher button with NOVA companion."
}

# 4. Update Destination Screen to 4 Environments
$oldDestScreen = @"
      <!-- Destination Choice Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
        
        <!-- Choice 1: Moon South Pole -->
        <button id="btn-select-moon" class="p-5 rounded-3xl bg-slate-800/80 hover:bg-slate-750 border-2 border-slate-700 hover:border-cyan-400 text-left transition-all group flex flex-col justify-between space-y-3 cursor-pointer">
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <span class="text-4xl group-hover:scale-110 transition-transform">??</span>
              <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-cyan-500/20 text-cyan-300 font-bold uppercase">NASA LOLA Altimetry</span>
            </div>
            <h3 class="text-base font-black text-white group-hover:text-cyan-300">Lunar South Pole</h3>
            <p class="text-xs text-slate-300 leading-relaxed">
              Located at Shackleton Crater rim. 0.166g low gravity lets you jump 6x higher than Earth. Sunlit rim peaks contrast with pitch-black crater floors harboring billions of tons of water ice!
            </p>
          </div>
          <div class="pt-2 border-t border-slate-700/60 text-[11px] font-mono text-cyan-400 space-y-1">
            <div>• Elevation: +1.2 km rim / -4.2 km basin</div>
            <div>• Comms Lag: 1.3 seconds light-speed</div>
            <div>• Key Hazard: 14-day freezing lunar night</div>
          </div>
          <div class="w-full py-2 rounded-xl bg-cyan-600/30 group-hover:bg-cyan-500 text-cyan-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Deploy Artemis Base ?
          </div>
        </button>

        <!-- Choice 2: Mars Jezero Crater -->
        <button id="btn-select-mars" class="p-5 rounded-3xl bg-slate-800/80 hover:bg-slate-750 border-2 border-slate-700 hover:border-orange-400 text-left transition-all group flex flex-col justify-between space-y-3 cursor-pointer">
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <span class="text-4xl group-hover:scale-110 transition-transform">??</span>
              <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-orange-500/20 text-orange-300 font-bold uppercase">NASA MOLA Altimetry</span>
            </div>
            <h3 class="text-base font-black text-white group-hover:text-orange-300">Mars Jezero Crater</h3>
            <p class="text-xs text-slate-300 leading-relaxed">
              Landing site of Perseverance rover! Ancient river delta fan with layered clay carbonate strata. Thin 610 Pa atmosphere. Dust storms blot out sunlight for weeks.
            </p>
          </div>
          <div class="pt-2 border-t border-slate-700/60 text-[11px] font-mono text-orange-400 space-y-1">
            <div>• Elevation: -2,500m ancient lakebed datum</div>
            <div>• Comms Lag: 4 to 20 minutes (speed of light)</div>
            <div>• Key Hazard: Planet-wide regolith dust storms</div>
          </div>
          <div class="w-full py-2 rounded-xl bg-orange-600/30 group-hover:bg-orange-500 text-orange-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Deploy Ares Base ?
          </div>
        </button>

      </div>
"@

$newDestScreen = @"
      <!-- Destination Choice Cards: 4 Space Environments with Artwork -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5 pt-2">
        
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
            <h3 class="text-sm font-black text-white group-hover:text-cyan-300">Lunar South Pole (Shackleton)</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              0.166g gravity (jump 6x higher!). Sunlit rim peaks contrast with permanently shadowed craters storing water ice.
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
            <h3 class="text-sm font-black text-white group-hover:text-orange-300">Mars Jezero Crater (Perseverance)</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              0.38g gravity, 610 Pa thin CO2 air. Ancient river delta clay strata. Dust storms blot out solar energy.
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
            <h3 class="text-sm font-black text-white group-hover:text-blue-300">ISS Orbital Cupola</h3>
            <p class="text-[11px] text-slate-300 leading-snug">
              Microgravity lab overlooking Blue Marble Earth. 90-minute orbit cycle with continuous solar recharge.
            </p>
          </div>
          <div class="pt-1.5 border-t border-slate-700/60 text-[10px] font-mono text-blue-400 flex justify-between">
            <span>Orbit: 408 km</span>
            <span>Speed: 27,600 km/h</span>
            <span>Lag: 0.001s</span>
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
              Lagrange Point outpost beyond Earth magnetosphere. Intense galactic cosmic rays require heavy shielding.
            </p>
          </div>
          <div class="pt-1.5 border-t border-slate-700/60 text-[10px] font-mono text-purple-400 flex justify-between">
            <span>Dist: 1.5M km</span>
            <span>Comms: DSN Goldstone</span>
            <span>GCR: High</span>
          </div>
          <div class="w-full py-1.5 rounded-xl bg-purple-600/30 group-hover:bg-purple-500 text-purple-200 group-hover:text-slate-950 font-black text-xs text-center transition-all">
            Launch Deep Space ?
          </div>
        </button>

      </div>
"@

if ($html.Contains($oldDestScreen)) {
    $html = $html.Replace($oldDestScreen, $newDestScreen)
    Write-Output "Updated Destination screen to 4 environments with design sheet art."
} else {
    Write-Output "Warning: oldDestScreen not matched."
}

# 5. Update Gemini Header in gemini-side-board
$oldGeminiHeader = @"
    <!-- Gemini Header -->
    <div class="flex items-center justify-between border-b border-slate-800 pb-3">
      <div class="flex items-center space-x-2">
        <div class="w-8 h-8 rounded-xl bg-gradient-to-tr from-purple-500 to-indigo-600 flex items-center justify-center text-lg shadow-md">
          ??
        </div>
        <div>
          <h3 class="text-sm font-black text-white">GEMINI SPACE COPILOT</h3>
          <span class="text-[10px] text-purple-400 font-mono">NASA Open Science AI Intelligence</span>
        </div>
      </div>
      <button id="btn-close-gemini" class="text-slate-400 hover:text-white font-bold text-lg p-1 cursor-pointer">
        ?
      </button>
    </div>
"@

$newGeminiHeader = @"
    <!-- Gemini Header with Authentic NOVA Bot -->
    <div class="flex items-center justify-between border-b border-slate-800 pb-3">
      <div class="flex items-center space-x-2.5">
        <img id="gemini-bot-avatar" src="assets/nova_companion.png" class="w-10 h-10 object-contain rounded-xl bg-purple-950/60 p-1 border border-purple-400 shadow-md transition-all" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['nova_companion'];">
        <div>
          <div class="flex items-center space-x-1.5">
            <h3 class="text-sm font-black text-white">NOVA AI COPILOT</h3>
            <span class="text-[9px] px-1.5 py-0.2 rounded-full bg-purple-500/30 text-purple-200 font-mono">Gemini</span>
          </div>
          <span class="text-[10px] text-purple-400 font-mono block">NASA Open Science AI Intelligence</span>
        </div>
      </div>
      <button id="btn-close-gemini" class="text-slate-400 hover:text-white font-bold text-lg p-1 cursor-pointer">
        ?
      </button>
    </div>
"@

if ($html.Contains($oldGeminiHeader)) {
    $html = $html.Replace($oldGeminiHeader, $newGeminiHeader)
    Write-Output "Updated Gemini side board header with NOVA companion."
}

# 6. Update Floating Gemini Trigger Pill
$oldFloatingTrigger = @"
  <button id="btn-floating-gemini" class="fixed bottom-5 right-5 z-40 px-3.5 py-2.5 rounded-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white font-black text-xs shadow-2xl glow-purple active:scale-95 transition-all flex items-center space-x-2 cursor-pointer border border-purple-300/40">
    <span class="text-lg">??</span>
    <span>Ask Gemini</span>
  </button>
"@

$newFloatingTrigger = @"
  <button id="btn-floating-gemini" class="fixed bottom-5 right-5 z-40 px-3.5 py-2 rounded-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white font-black text-xs shadow-2xl glow-purple active:scale-95 transition-all flex items-center space-x-2 cursor-pointer border border-purple-300/40 group">
    <img src="assets/nova_companion.png" class="w-6 h-6 object-contain group-hover:scale-110 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['nova_companion'];">
    <span>Ask NOVA AI</span>
  </button>
"@

if ($html.Contains($oldFloatingTrigger)) {
    $html = $html.Replace($oldFloatingTrigger, $newFloatingTrigger)
    Write-Output "Updated floating Gemini trigger pill."
}

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Output "HTML screen updates completed."
