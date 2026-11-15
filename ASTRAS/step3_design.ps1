$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Update this.crewData with rich metadata from design sheet
$oldCrewData = '(?s)this\.crewData = \[.*?\];'
$newCrewData = @"
this.crewData = [
          { 
            id: 'leo', 
            name: 'Cadet Leo', 
            role: 'Cadet Pilot',
            skinName: 'Artemis Polar',
            skinClass: 'bg-cyan-500/20 text-cyan-300 border border-cyan-400/40',
            pose: 'pose_pointing',
            voice: 'Cadet Leo reporting! Ready to navigate our spacecraft and pilot the mission!' 
          },
          { 
            id: 'maya', 
            name: 'Maya', 
            role: 'Mission Specialist',
            skinName: 'Standard Artemis',
            skinClass: 'bg-blue-500/20 text-blue-300 border border-blue-400/40',
            pose: 'pose_waving',
            voice: 'Mission Specialist Maya here! Ready to build strong shelters and explore the terrain!' 
          },
          { 
            id: 'arin', 
            name: 'Dr. Arin', 
            role: 'Systems Engineer',
            skinName: 'Ares Flight Suit',
            skinClass: 'bg-orange-500/20 text-orange-300 border border-orange-400/40',
            pose: 'pose_idle',
            voice: 'Dr. Arin reporting! Solar arrays, battery grids, and life support systems are nominal!' 
          },
          { 
            id: 'tara', 
            name: 'Dr. Tara', 
            role: 'Botanist & Medic',
            skinName: 'Bio-Science Suit',
            skinClass: 'bg-purple-500/20 text-purple-300 border border-purple-400/40',
            pose: 'pose_kneeling',
            voice: 'Dr. Tara here! Ready to cultivate our hydroponic greenhouses and harvest fresh water ice!' 
          }
        ];
"@

if ([regex]::IsMatch($html, $oldCrewData)) {
    $html = [regex]::Replace($html, $oldCrewData, $newCrewData)
    Write-Output "Updated this.crewData with design sheet details."
} else {
    Write-Output "crewData regex did not match."
}

# 2. Update renderCrewSelection() to display character portraits, avatars, suit skins and poses
$oldRenderCrew = '(?s)renderCrewSelection\(\) \{.*?grid\.appendChild\(card\);\s*\}\);?\s*\}'
$newRenderCrew = @"
renderCrewSelection() {
        const grid = document.getElementById('crew-cards-grid');
        if (!grid) return;
        grid.innerHTML = '';

        this.crewData.forEach(c => {
          const isSelected = this.selectedCrew.includes(c.id);
          const card = document.createElement('div');
          card.className = `p-3.5 rounded-3xl border-2 transition-all cursor-pointer flex flex-col justify-between group \${
            isSelected
              ? 'bg-sky-950/90 border-sky-400 ring-4 ring-sky-400/40 shadow-xl'
              : 'bg-slate-900/90 border-slate-700/80 hover:border-slate-500 hover:bg-slate-850'
          }`;

          card.innerHTML = `
            <div class="space-y-2.5">
              <!-- Full Body Illustration Card -->
              <div class="relative w-full h-36 rounded-2xl overflow-hidden bg-gradient-to-b from-slate-950 via-slate-900 to-space-950 border border-slate-800 flex items-center justify-center p-2">
                <img src="assets/char_\${c.id}_full.png" alt="\${c.name}" class="h-32 object-contain group-hover:scale-105 transition-transform" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_\${c.id}_full'];">
                <img src="assets/char_\${c.id}_avatar.png" class="absolute bottom-2 left-2 w-8 h-8 rounded-xl border border-sky-400/50 shadow-md object-contain bg-slate-950/90" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['char_\${c.id}_avatar'];">
                <span class="absolute top-2 right-2 text-[10px] px-2.5 py-0.5 rounded-full font-black uppercase \${
                  isSelected ? 'bg-sky-400 text-slate-950 shadow-md' : 'bg-slate-800/90 text-slate-400 border border-slate-700'
                }">\${isSelected ? '? SELECTED' : 'SELECT'}</span>
              </div>

              <!-- Name & Title -->
              <div>
                <div class="flex items-center justify-between">
                  <h4 class="font-black text-base text-white group-hover:text-sky-300 transition-colors">\${c.name}</h4>
                  <span class="text-[9px] px-2 py-0.5 rounded-full font-mono font-bold \${c.skinClass}">\${c.skinName}</span>
                </div>
                <span class="text-xs font-bold text-sky-400 block">\${c.role}</span>
              </div>
            </div>

            <!-- Voice Preview & Selection Button -->
            <div class="pt-2.5 border-t border-slate-800 space-y-1.5 mt-2.5">
              <button class="btn-hear-voice w-full py-1.5 px-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-sky-300 text-xs font-bold border border-slate-700 flex items-center justify-center space-x-1.5 cursor-pointer transition-colors shadow">
                <span>???</span>
                <span>Preview Voice</span>
              </button>
            </div>
          `;

          // Card Click Action
          card.addEventListener('click', (e) => {
            if (e.target.closest('.btn-hear-voice')) {
              e.stopPropagation();
              audioService.speak(c.voice, c.id);
              return;
            }
            audioService.playClick();
            if (this.selectedCrew.includes(c.id)) {
              if (this.selectedCrew.length > 1) {
                this.selectedCrew = this.selectedCrew.filter(id => id !== c.id);
              }
            } else {
              if (this.selectedCrew.length < 2) {
                this.selectedCrew.push(c.id);
              } else {
                this.selectedCrew[1] = c.id;
              }
            }
            document.getElementById('crew-count-display').innerText = `\${this.selectedCrew.length} / 2`;
            this.renderCrewSelection();
          });

          grid.appendChild(card);
        });
      }
"@

if ([regex]::IsMatch($html, $oldRenderCrew)) {
    $html = [regex]::Replace($html, $oldRenderCrew, $newRenderCrew)
    Write-Output "Applied renderCrewSelection() upgrade."
} else {
    Write-Output "renderCrewSelection regex did not match."
}

# 3. Add Event Listeners for Welcome Cadet Preview buttons and ISS/Deepspace buttons
$oldDestListeners = '(?s)document\.getElementById\(''btn-select-mars''\)\?\.addEventListener\(.*?\}\);'
$newDestListeners = @"
document.getElementById('btn-select-mars')?.addEventListener('click', () => {
          audioService.playClick();
          this.destination = 'mars';
          this.world.setupDestination('mars');
          document.getElementById('builder-site-badge').innerText = 'Mars Jezero Outpost (MOLA)';
          document.getElementById('hud-site-title').innerText = 'Mars Jezero Outpost • Ares Base Alpha';
          this.showScreen('screen-crew');
          audioService.speak("Mars Jezero Outpost selected. Ares Base Alpha initialized on MOLA terrain.", "nova");
        });

        document.getElementById('btn-select-iss')?.addEventListener('click', () => {
          audioService.playClick();
          this.destination = 'iss';
          this.world.setupDestination('iss');
          document.getElementById('builder-site-badge').innerText = 'ISS Earth Orbit (Microgravity)';
          document.getElementById('hud-site-title').innerText = 'Earth Orbit • ISS Cupola Platform';
          this.showScreen('screen-crew');
          audioService.speak("ISS Cupola Platform selected. Earth orbital velocity locked at 27,600 kilometers per hour.", "nova");
        });

        document.getElementById('btn-select-deepspace')?.addEventListener('click', () => {
          audioService.playClick();
          this.destination = 'deepspace';
          this.world.setupDestination('deepspace');
          document.getElementById('builder-site-badge').innerText = 'Deep Space Gateway (DSN)';
          document.getElementById('hud-site-title').innerText = 'Deep Space • Cislunar Gateway Base';
          this.showScreen('screen-crew');
          audioService.speak("Deep Space Gateway selected. Deep Space Network 70-meter telemetry dishes aligned.", "nova");
        });

        // Welcome Screen Cadet Preview Buttons
        document.querySelectorAll('.btn-welcome-char').forEach(btn => {
          btn.addEventListener('click', () => {
            const charId = btn.getAttribute('data-char');
            const cadet = this.crewData.find(c => c.id === charId);
            if (cadet) {
              audioService.playChime();
              audioService.speak(cadet.voice, cadet.id);
            }
          });
        });
"@

if ([regex]::IsMatch($html, $oldDestListeners)) {
    $html = [regex]::Replace($html, $oldDestListeners, $newDestListeners)
    Write-Output "Applied ISS, Deepspace, and Welcome cadet click listeners."
} else {
    Write-Output "destListeners regex did not match."
}

# 4. Support ISS & Deepspace in AstrasWorld3D.setupDestination(dest)
$oldWorldSetup = '(?s)setupDestination\(dest\) \{.*?if \(dest === ''moon''\) \{.*?\}\s*else if \(dest === ''mars''\) \{.*?\}\s*\}'
$newWorldSetup = @"
setupDestination(dest) {
        const THREE = this.THREE;
        this.destination = dest;
        while (this.outpostGroup.children.length > 0) {
          this.outpostGroup.remove(this.outpostGroup.children[0]);
        }

        // Sky & Environment
        if (dest === 'moon') {
          this.scene.background = null;
          this.scene.fog = new THREE.FogExp2(0x020408, 0.003);

          const earth = new THREE.Mesh(new THREE.SphereGeometry(5.0, 32, 32), new THREE.MeshBasicMaterial({ color: 0x38BDF8 }));
          earth.position.set(-45, 65, -120);
          this.outpostGroup.add(earth);

          const terrainGeo = new THREE.PlaneGeometry(160, 160, 56, 56);
          terrainGeo.rotateX(-Math.PI * 0.5);
          const pos = terrainGeo.attributes.position;
          for (let i = 0; i < pos.count; i++) {
            const x = pos.getX(i), z = pos.getZ(i);
            const distFromCrater = Math.hypot(x - 18, z - 18);
            let y = (Math.sin(x * 0.05) + Math.cos(z * 0.05)) * 1.8;
            if (distFromCrater < 26) {
              y -= Math.cos((distFromCrater / 26) * (Math.PI * 0.5)) * 4.2;
            } else if (distFromCrater < 36) {
              y += Math.sin(((distFromCrater - 26) / 10) * Math.PI) * 1.2;
            }
            pos.setY(i, y);
          }
          terrainGeo.computeVertexNormals();
          const terrainMat = new THREE.MeshStandardMaterial({
            color: 0x64748B,
            roughness: 0.95,
            metalness: 0.05,
            flatShading: true
          });
          const terrain = new THREE.Mesh(terrainGeo, terrainMat);
          terrain.position.y = -0.5;
          this.outpostGroup.add(terrain);

        } else if (dest === 'mars') {
          this.scene.background = new THREE.Color(0x3B1B14);
          this.scene.fog = new THREE.FogExp2(0x52231A, 0.006);

          const terrainGeo = new THREE.PlaneGeometry(160, 160, 56, 56);
          terrainGeo.rotateX(-Math.PI * 0.5);
          const pos = terrainGeo.attributes.position;
          for (let i = 0; i < pos.count; i++) {
            const x = pos.getX(i), z = pos.getZ(i);
            let y = Math.sin(x * 0.08) * 1.6 + Math.cos(z * 0.07) * 1.5;
            if (Math.abs(x - z) < 14) y -= 1.8;
            pos.setY(i, y);
          }
          terrainGeo.computeVertexNormals();
          const terrainMat = new THREE.MeshStandardMaterial({
            color: 0xC25732,
            roughness: 0.9,
            metalness: 0.1,
            flatShading: true
          });
          const terrain = new THREE.Mesh(terrainGeo, terrainMat);
          terrain.position.y = -0.5;
          this.outpostGroup.add(terrain);

        } else if (dest === 'iss') {
          this.scene.background = null;
          this.scene.fog = null;

          // Huge Rotating Blue Marble Earth below
          const earthGeo = new THREE.SphereGeometry(60, 48, 48);
          const earthMat = new THREE.MeshStandardMaterial({
            color: 0x1E40AF,
            roughness: 0.8,
            metalness: 0.2
          });
          const earth = new THREE.Mesh(earthGeo, earthMat);
          earth.position.set(0, -75, -20);
          this.outpostGroup.add(earth);

          // Platform Grid
          const grid = new THREE.GridHelper(50, 25, 0x38BDF8, 0x1E293B);
          grid.position.y = -0.5;
          this.outpostGroup.add(grid);

        } else if (dest === 'deepspace') {
          this.scene.background = null;
          this.scene.fog = null;

          // Saturn with rings in deep space
          const saturn = new THREE.Mesh(new THREE.SphereGeometry(12, 32, 32), new THREE.MeshStandardMaterial({ color: 0xFDE047, roughness: 0.7 }));
          saturn.position.set(50, 40, -140);
          this.outpostGroup.add(saturn);

          const ringGeo = new THREE.RingGeometry(16, 26, 40);
          ringGeo.rotateX(Math.PI * 0.35);
          const ringMat = new THREE.MeshBasicMaterial({ color: 0xD97706, side: THREE.DoubleSide, transparent: true, opacity: 0.6 });
          const ring = new THREE.Mesh(ringGeo, ringMat);
          ring.position.copy(saturn.position);
          this.outpostGroup.add(ring);

          const grid = new THREE.GridHelper(50, 25, 0xA855F7, 0x334155);
          grid.position.y = -0.5;
          this.outpostGroup.add(grid);
        }
      }
"@

if ([regex]::IsMatch($html, $oldWorldSetup)) {
    $html = [regex]::Replace($html, $oldWorldSetup, $newWorldSetup)
    Write-Output "Applied 4 environments to AstrasWorld3D."
} else {
    Write-Output "worldSetup regex did not match."
}

# 5. Add Debrief Image container & expression updating in handleGeminiUserPrompt and endSimulation
$oldDebriefBadge = '(?s)<div id="debrief-outcome-badge".*?</div>\s*<div class="space-y-1">'
$newDebriefBadge = @"
<div id="debrief-outcome-badge" class="inline-flex items-center space-x-2 px-4 py-1.5 rounded-full bg-emerald-500/20 text-emerald-300 border border-emerald-400/40 text-xs font-black uppercase tracking-wider">
        <span>?? MISSION ACCOMPLISHED</span>
      </div>

      <!-- Result Screen Robot Illustration -->
      <div id="debrief-img-wrap" class="flex justify-center py-1">
        <img id="debrief-result-img" src="assets/nova_mission_success.png" alt="Mission Result" class="max-h-24 sm:max-h-28 object-contain filter drop-shadow-xl" onerror="this.onerror=null; if(window.ASTRAS_ASSETS) this.src=window.ASTRAS_ASSETS['nova_mission_success'];">
      </div>

      <div class="space-y-1">
"@

if ([regex]::IsMatch($html, $oldDebriefBadge)) {
    $html = [regex]::Replace($html, $oldDebriefBadge, $newDebriefBadge)
    Write-Output "Added debrief result image container."
}

# 6. Update endSimulation to swap debrief-result-img between success & fail
$oldEndSim = '(?s)endSimulation\(success\) \{.*?document\.getElementById\(''modal-debrief''\)\.classList\.remove\(''hidden''\);'
$newEndSim = @"
endSimulation(success) {
        if (this.simTimer) clearInterval(this.simTimer);
        document.getElementById('modal-debrief').classList.remove('hidden');

        const resImg = document.getElementById('debrief-result-img');
        if (resImg) {
          resImg.src = success ? getAstrasAsset('nova_mission_success') : getAstrasAsset('nova_mission_failed');
        }
"@

if ([regex]::IsMatch($html, $oldEndSim)) {
    $html = [regex]::Replace($html, $oldEndSim, $newEndSim)
    Write-Output "Updated endSimulation to swap success/fail robot images."
}

# 7. Update Gemini Prompt Handler to expressively animate NOVA's face
$oldGeminiPrompt = '(?s)handleGeminiUserPrompt\(prompt\) \{.*?log\.scrollTop = log\.scrollHeight;'
$newGeminiPrompt = @"
handleGeminiUserPrompt(prompt) {
        const log = document.getElementById('gemini-chat-log');
        if (!log) return;

        // Expressive NOVA: thinking/surprised
        const botAvatar = document.getElementById('gemini-bot-avatar');
        if (botAvatar) botAvatar.src = getAstrasAsset('nova_surprised');

        // Append User Message
        const uMsg = document.createElement('div');
        uMsg.className = "p-2.5 rounded-2xl bg-sky-950/60 border border-sky-500/40 text-slate-100 text-right";
        uMsg.innerHTML = `<span class="font-bold text-sky-300 block text-[10px] mb-0.5">????? Cadet:</span>\${prompt}`;
        log.appendChild(uMsg);
        log.scrollTop = log.scrollHeight;
"@

if ([regex]::IsMatch($html, $oldGeminiPrompt)) {
    $html = [regex]::Replace($html, $oldGeminiPrompt, $newGeminiPrompt)
    Write-Output "Updated handleGeminiUserPrompt with NOVA expressions."
}

# 8. When Gemini answers, switch to talking, then happy
$oldGeminiAnswer = '(?s)log\.appendChild\(aMsg\);\s*log\.scrollTop = log\.scrollHeight;\s*audioService\.speak'
$newGeminiAnswer = @"
log.appendChild(aMsg);
          log.scrollTop = log.scrollHeight;

          const botAvatar = document.getElementById('gemini-bot-avatar');
          if (botAvatar) {
            botAvatar.src = getAstrasAsset('nova_talking');
            setTimeout(() => {
              if (botAvatar) botAvatar.src = getAstrasAsset('nova_happy');
            }, 3000);
          }

          audioService.speak
"@

if ([regex]::IsMatch($html, $oldGeminiAnswer)) {
    $html = [regex]::Replace($html, $oldGeminiAnswer, $newGeminiAnswer)
    Write-Output "Updated Gemini answer avatar expression timing."
}

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Output "All Step 3 design sheet integrations completed successfully."
