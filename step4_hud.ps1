$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Update AstrasWorld3D.setupDestination to support 'iss' and 'deepspace'
$patternSetupDest = '(?s)setupDestination\(dest\) \{.*?this\.outpostGroup\.add\(gridHelper\);\s*\}'
$newSetupDest = @"
setupDestination(dest) {
        const THREE = this.THREE;
        this.destination = dest;
        while (this.outpostGroup.children.length > 0) {
          this.outpostGroup.remove(this.outpostGroup.children[0]);
        }

        // Sky & Environment
        if (dest === 'moon') {
          // Lunar South Pole: Pitch black sky with high Earth
          this.scene.background = null;
          this.scene.fog = new THREE.FogExp2(0x020408, 0.003);

          // Earth Blue Marble in Lunar Sky
          const earth = new THREE.Mesh(new THREE.SphereGeometry(5.0, 32, 32), new THREE.MeshBasicMaterial({ color: 0x38BDF8 }));
          earth.position.set(-45, 65, -120);
          this.outpostGroup.add(earth);

          // Realistic NASA LOLA Altimetry Shackleton Crater Rim
          const terrainGeo = new THREE.PlaneGeometry(160, 160, 56, 56);
          terrainGeo.rotateX(-Math.PI * 0.5);
          const pos = terrainGeo.attributes.position;
          for (let i = 0; i < pos.count; i++) {
            const x = pos.getX(i), z = pos.getZ(i);
            const distFromCrater = Math.hypot(x - 18, z - 18);
            let y = (Math.sin(x * 0.05) + Math.cos(z * 0.05)) * 1.8;
            if (distFromCrater < 35) {
              y -= (35 - distFromCrater) * 0.38;
            } else {
              y += Math.exp(-Math.pow((distFromCrater - 38) / 8, 2)) * 3.5;
            }
            pos.setY(i, y);
          }
          terrainGeo.computeVertexNormals();
          const moonMat = new THREE.MeshStandardMaterial({ color: 0x94A3B8, roughness: 0.92, flatShading: true });
          const terrain = new THREE.Mesh(terrainGeo, moonMat);
          terrain.receiveShadow = true;
          this.outpostGroup.add(terrain);

          const dirLight = new THREE.DirectionalLight(0xFFFFFF, 1.8);
          dirLight.position.set(40, 12, 30);
          dirLight.castShadow = true;
          this.outpostGroup.add(dirLight);
          this.outpostGroup.add(new THREE.AmbientLight(0x1E293B, 0.4));

        } else if (dest === 'iss') {
          // ISS Earth Orbit
          this.scene.background = null;
          this.scene.fog = null;

          // Huge Rotating Blue Marble Earth below
          const earthGeo = new THREE.SphereGeometry(45, 48, 48);
          const earthMat = new THREE.MeshStandardMaterial({ color: 0x1E40AF, roughness: 0.8, metalness: 0.1 });
          const earth = new THREE.Mesh(earthGeo, earthMat);
          earth.position.set(0, -55, -20);
          this.outpostGroup.add(earth);

          // Orbit Truss platform
          const platformGeo = new THREE.BoxGeometry(40, 1.0, 40);
          const platformMat = new THREE.MeshStandardMaterial({ color: 0x334155, metalness: 0.6, roughness: 0.4 });
          const platform = new THREE.Mesh(platformGeo, platformMat);
          platform.position.y = -1.0;
          this.outpostGroup.add(platform);

          const dirLight = new THREE.DirectionalLight(0xFFFFFF, 2.0);
          dirLight.position.set(30, 40, 20);
          this.outpostGroup.add(dirLight);
          this.outpostGroup.add(new THREE.AmbientLight(0x0EA5E9, 0.4));

        } else if (dest === 'deepspace') {
          // Deep Space Gateway & Saturn
          this.scene.background = null;
          this.scene.fog = null;

          const saturn = new THREE.Mesh(new THREE.SphereGeometry(14, 32, 32), new THREE.MeshStandardMaterial({ color: 0xFDE047, roughness: 0.7 }));
          saturn.position.set(50, 45, -130);
          this.outpostGroup.add(saturn);

          const ringGeo = new THREE.RingGeometry(18, 30, 40);
          ringGeo.rotateX(Math.PI * 0.35);
          const ringMat = new THREE.MeshBasicMaterial({ color: 0xD97706, side: THREE.DoubleSide, transparent: true, opacity: 0.65 });
          const ring = new THREE.Mesh(ringGeo, ringMat);
          ring.position.copy(saturn.position);
          this.outpostGroup.add(ring);

          const platformGeo = new THREE.CylinderGeometry(20, 20, 1.0, 32);
          const platformMat = new THREE.MeshStandardMaterial({ color: 0x1E1B4B, metalness: 0.7, roughness: 0.3 });
          const platform = new THREE.Mesh(platformGeo, platformMat);
          platform.position.y = -1.0;
          this.outpostGroup.add(platform);

          const dirLight = new THREE.DirectionalLight(0xE0E7FF, 1.6);
          dirLight.position.set(30, 30, 20);
          this.outpostGroup.add(dirLight);
          this.outpostGroup.add(new THREE.AmbientLight(0x4C1D95, 0.4));

        } else {
          // Mars Jezero Crater
          this.scene.background = new THREE.Color(0xC25E3E);
          this.scene.fog = new THREE.FogExp2(0xC25E3E, 0.012);

          const phobos = new THREE.Mesh(new THREE.DodecahedronGeometry(1.8, 1), new THREE.MeshBasicMaterial({ color: 0xD6D3D1 }));
          phobos.position.set(-50, 75, -110);
          this.outpostGroup.add(phobos);

          const terrainGeo = new THREE.PlaneGeometry(160, 160, 56, 56);
          terrainGeo.rotateX(-Math.PI * 0.5);
          const pos = terrainGeo.attributes.position;
          for (let i = 0; i < pos.count; i++) {
            const x = pos.getX(i), z = pos.getZ(i);
            let y = Math.sin(x * 0.04) * Math.cos(z * 0.04) * 1.5;
            if (z < -8 && Math.abs(x) < 28) {
              y += Math.sin((z + 10) * 0.1) * 2.2 + 1.2;
            }
            pos.setY(i, y);
          }
          terrainGeo.computeVertexNormals();
          const marsMat = new THREE.MeshStandardMaterial({ color: 0x9A3412, roughness: 0.88, flatShading: true });
          const terrain = new THREE.Mesh(terrainGeo, marsMat);
          terrain.receiveShadow = true;
          this.outpostGroup.add(terrain);

          for (let b = 0; b < 24; b++) {
            const rock = new THREE.Mesh(
              new THREE.DodecahedronGeometry(0.6 + Math.random() * 1.4, 0),
              new THREE.MeshStandardMaterial({ color: 0x78350F, roughness: 0.95 })
            );
            rock.position.set((Math.random() - 0.5) * 80, 0, (Math.random() - 0.5) * 80);
            this.outpostGroup.add(rock);
          }

          const dirLight = new THREE.DirectionalLight(0xFFF1E6, 1.4);
          dirLight.position.set(25, 30, 20);
          dirLight.castShadow = true;
          this.outpostGroup.add(dirLight);
          this.outpostGroup.add(new THREE.AmbientLight(0x7C2D12, 0.5));
        }

        // Construction Grid Markers on Terrain
        const gridHelper = new THREE.GridHelper(36, 18, 0x38BDF8, 0x1E293B);
        gridHelper.position.set(0, 0.05, -6);
        this.outpostGroup.add(gridHelper);
      }
"@

if ([regex]::IsMatch($html, $patternSetupDest)) {
    $html = [regex]::Replace($html, $patternSetupDest, $newSetupDest)
    Write-Output "Applied 4 environments setupDestination logic."
} else {
    Write-Output "setupDestination regex did not match."
}

# 2. Add In-Game HUD Active Astronaut Card and Radar Scanner to colony-operations-hud
$oldHudTop = '(?s)<!-- Top Row: Telemetry, Clock, Controls -->\s*<div class="flex flex-col sm:flex-row items-start sm:items-center justify-between w-full pointer-events-auto gap-2">\s*<!-- Sol Clock & Destination Tag -->'
$newHudTop = @"
<!-- Top Row: Telemetry, Clock, Controls & Design Sheet In-Game HUD -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between w-full pointer-events-auto gap-2">
      
      <!-- In-Game HUD: Active Astronaut Card matching Design Sheet -->
      <div class="flex items-center space-x-2.5 bg-slate-900/90 backdrop-blur-md px-3 py-1.5 rounded-2xl border border-sky-400/40 shadow-xl">
        <div class="relative">
          <img id="hud-active-avatar" src="assets/char_leo_avatar.png" class="w-10 h-10 rounded-xl object-contain border border-sky-400/60 bg-slate-950/80 shadow" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_leo_avatar'];">
          <span class="absolute -top-1 -right-1 w-3 h-3 rounded-full bg-emerald-400 border border-slate-950"></span>
        </div>
        <div class="space-y-0.5">
          <div class="flex items-center space-x-1.5">
            <span id="hud-active-crew-name" class="font-black text-xs text-white">Cadet Leo</span>
            <span class="text-[9px] px-1.5 py-0.2 rounded-full bg-sky-500/20 text-sky-300 font-mono">EVA SUIT</span>
          </div>
          <div class="flex items-center space-x-2 text-[10px] font-mono">
            <span class="flex items-center space-x-1 text-rose-400 font-bold" title="Suit Health"><img src="assets/icon_heart.png" class="w-3.5 h-3.5 inline"> <span id="hud-bar-health">100%</span></span>
            <span class="flex items-center space-x-1 text-amber-400 font-bold" title="Battery Power"><img src="assets/icon_power.png" class="w-3.5 h-3.5 inline"> <span id="hud-bar-suit-pwr">100%</span></span>
            <span class="flex items-center space-x-1 text-cyan-400 font-bold" title="O2 Reserve"><img src="assets/icon_o2.png" class="w-3.5 h-3.5 inline"> <span id="hud-bar-suit-o2">100%</span></span>
          </div>
        </div>
      </div>

      <!-- Sol Clock & Destination Tag -->
"@

if ([regex]::IsMatch($html, $oldHudTop)) {
    $html = [regex]::Replace($html, $oldHudTop, $newHudTop)
    Write-Output "Applied In-Game HUD Astronaut Card."
} else {
    Write-Output "hudTop regex did not match."
}

# 3. Add Radar Scanner next to controls in colony-operations-hud
$oldHudControls = '(?s)<div class="flex items-center space-x-1\.5">\s*<button id="btn-hud-unit-toggle".*???? Toggle View\s*</button>\s*</div>'
$newHudControls = @"
<div class="flex items-center space-x-2">
        <div class="flex items-center space-x-1.5">
          <button id="btn-hud-unit-toggle" class="px-2.5 py-1.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-[11px] font-bold text-sky-300 border border-slate-600 transition-all cursor-pointer" title="Toggle scientific units">
            Mode: <span id="unit-toggle-label" class="text-white">Cadet %</span>
          </button>
          <button id="btn-hud-nasa-data" class="px-2.5 py-1.5 rounded-xl bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-500/50 text-[11px] font-bold text-emerald-300 cursor-pointer flex items-center space-x-1">
            <span>??</span>
            <span>NASA Data</span>
          </button>
          <button id="btn-hud-view-toggle" class="px-2.5 py-1.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-[11px] font-bold text-slate-200 border border-slate-600 cursor-pointer">
            ??? Toggle View
          </button>
        </div>

        <!-- Authentic Radar Scanner from Design Sheet -->
        <div class="relative w-12 h-12 rounded-full overflow-hidden border-2 border-sky-400/70 shadow-lg bg-slate-950/90 backdrop-blur-md shrink-0 hidden sm:block" title="Surface Radar Scanner">
          <img src="assets/hud_radar.png" alt="Radar Scanner" class="w-full h-full object-cover animate-pulse" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['hud_radar'];">
        </div>
      </div>
"@

if ([regex]::IsMatch($html, $oldHudControls)) {
    $html = [regex]::Replace($html, $oldHudControls, $newHudControls)
    Write-Output "Applied Radar Scanner to HUD."
} else {
    Write-Output "hudControls regex did not match."
}

# 4. Synchronize HUD active avatar with chosen crew in startSimulation
$oldStartSim = '(?s)startSimulation\(\) \{.*?this\.updateTelemetryUI\(\);'
$newStartSim = @"
startSimulation() {
        this.simSol = 1;
        this.world.setArchitectMode(false);
        this.showScreen('colony-operations-hud');

        // Update active crew avatar from selected team
        const activeCadetId = this.selectedCrew[0] || 'leo';
        const activeCadet = this.crewData.find(c => c.id === activeCadetId);
        if (activeCadet) {
          const avImg = document.getElementById('hud-active-avatar');
          const nameSpan = document.getElementById('hud-active-crew-name');
          if (avImg) avImg.src = getAstrasAsset('char_' + activeCadet.id + '_avatar');
          if (nameSpan) nameSpan.innerText = activeCadet.name;
        }

        this.updateTelemetryUI();
"@

if ([regex]::IsMatch($html, $oldStartSim)) {
    $html = [regex]::Replace($html, $oldStartSim, $newStartSim)
    Write-Output "Applied active cadet sync in startSimulation."
} else {
    Write-Output "startSim regex did not match."
}

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Output "HUD & Destination integration complete."
