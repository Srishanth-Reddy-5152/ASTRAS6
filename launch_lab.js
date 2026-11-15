// =========================================================================
// ASTRAS: 3D ORBITAL LAUNCH LAB & PLANETARY ORRERY SIMULATOR
// Grounded in Real NASA Orbital Mechanics & Planetary Data
// =========================================================================

(function(window) {
  'use strict';

  // --- 1. PROCEDURAL 3D PLANET TEXTURE HELPERS ---
  function createEarthTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 512;
    canvas.height = 256;
    const ctx = canvas.getContext('2d');
    
    // Deep Ocean
    ctx.fillStyle = '#0f2b46';
    ctx.fillRect(0, 0, 512, 256);

    // Continents (Simplified stylised landmasses)
    ctx.fillStyle = '#1e5f38';
    // North America & Eurasia
    ctx.beginPath();
    ctx.ellipse(140, 80, 55, 35, 0.2, 0, Math.PI * 2);
    ctx.ellipse(320, 70, 85, 40, -0.1, 0, Math.PI * 2);
    // South America & Africa
    ctx.ellipse(170, 160, 35, 50, 0.3, 0, Math.PI * 2);
    ctx.ellipse(280, 140, 45, 55, 0.1, 0, Math.PI * 2);
    // Australia
    ctx.ellipse(400, 170, 30, 25, 0, 0, Math.PI * 2);
    ctx.fill();

    // White Clouds & Polar Ice Caps
    ctx.fillStyle = 'rgba(255, 255, 255, 0.85)';
    ctx.fillRect(0, 0, 512, 18);
    ctx.fillRect(0, 238, 512, 18);
    
    // Swirling cloud bands
    ctx.fillStyle = 'rgba(255, 255, 255, 0.35)';
    for (let i = 0; i < 12; i++) {
      ctx.beginPath();
      ctx.ellipse((i * 45) % 512, 60 + (i * 12) % 130, 45, 12, 0.4, 0, Math.PI * 2);
      ctx.fill();
    }
    
    return new THREE.CanvasTexture(canvas);
  }

  function createMarsTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 512;
    canvas.height = 256;
    const ctx = canvas.getContext('2d');
    
    // Rust-Red Martian Regolith
    ctx.fillStyle = '#b84c28';
    ctx.fillRect(0, 0, 512, 256);

    // Dark Basalt Lowlands & Syrtis Major
    ctx.fillStyle = '#6b2b16';
    ctx.beginPath();
    ctx.ellipse(180, 120, 60, 40, 0.3, 0, Math.PI * 2);
    ctx.ellipse(340, 110, 80, 45, -0.2, 0, Math.PI * 2);
    ctx.fill();

    // Valles Marineris canyon scratch
    ctx.strokeStyle = '#44180a';
    ctx.lineWidth = 6;
    ctx.beginPath();
    ctx.moveTo(110, 130);
    ctx.lineTo(230, 145);
    ctx.stroke();

    // Polar Carbon Dioxide / Water Ice Caps
    ctx.fillStyle = '#ffffff';
    ctx.beginPath();
    ctx.ellipse(256, 12, 65, 12, 0, 0, Math.PI * 2);
    ctx.ellipse(256, 244, 45, 10, 0, 0, Math.PI * 2);
    ctx.fill();

    return new THREE.CanvasTexture(canvas);
  }

  function createMoonTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 256;
    canvas.height = 128;
    const ctx = canvas.getContext('2d');
    
    ctx.fillStyle = '#8c95a0';
    ctx.fillRect(0, 0, 256, 128);

    // Darker basaltic maria
    ctx.fillStyle = '#5a626c';
    ctx.beginPath();
    ctx.ellipse(80, 50, 30, 25, 0.2, 0, Math.PI * 2);
    ctx.ellipse(160, 55, 40, 30, -0.1, 0, Math.PI * 2);
    ctx.ellipse(110, 80, 25, 20, 0, 0, Math.PI * 2);
    ctx.fill();

    // Small impact craters
    ctx.fillStyle = '#adb5bd';
    for (let c = 0; c < 30; c++) {
      ctx.beginPath();
      ctx.arc((c * 37) % 256, (c * 23) % 128, 2 + (c % 4), 0, Math.PI * 2);
      ctx.fill();
    }

    return new THREE.CanvasTexture(canvas);
  }

  // --- 2. 3D ORBITAL LAUNCH LAB WORLD CLASS ---
  class LaunchLabWorld3D {
    constructor(container) {
      this.container = container;
      this.THREE = window.THREE;
      this.scene = null;
      this.camera = null;
      this.renderer = null;
      this.viewMode = 'orrery'; // 'orrery', 'pad', 'ship'
      
      // Celestial bodies
      this.sunMesh = null;
      this.earthGroup = null;
      this.earthMesh = null;
      this.moonGroup = null;
      this.moonMesh = null;
      this.marsGroup = null;
      this.marsMesh = null;

      // Trajectory and Launchpad
      this.orbitLinesGroup = null;
      this.trajectoryLine = null;
      this.launchPadGroup = null;
      this.rocketGroup = null;
      this.flameMesh = null;
      this.particleSystem = null;

      // Parameters
      this.earthOrbitRadius = 14.0;
      this.marsOrbitRadius = 23.5;
      this.phaseAngleDeg = 44.4;
      this.route = 'mars'; // 'moon' or 'mars'

      // Camera Orbit Controls
      this.camDistance = 42.0;
      this.camRotX = 0.55;
      this.camRotY = 0.45;
      this.isDragging = false;
      this.prevMouse = { x: 0, y: 0 };

      // Animation loop state
      this.isAnimatingLaunch = false;
      this.launchProgress = 0.0;
      this.launchParams = null;
      this.onLaunchCompleteCallback = null;

      this.init();
    }

    init() {
      const THREE = this.THREE;
      if (!THREE || !this.container) return;

      const w = this.container.clientWidth || 800;
      const h = this.container.clientHeight || 500;

      // Scene
      this.scene = new THREE.Scene();

      // Camera
      this.camera = new THREE.PerspectiveCamera(45, w / h, 0.1, 1000);
      this.updateCameraPosition();

      // WebGL Renderer
      this.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
      this.renderer.setSize(w, h);
      this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
      this.container.innerHTML = '';
      this.container.appendChild(this.renderer.domElement);

      // Starfield Background inside Lab
      this.buildStarfield();

      // Lighting
      const ambientLight = new THREE.AmbientLight(0x2d3748, 0.8);
      this.scene.add(ambientLight);

      const sunLight = new THREE.PointLight(0xfff7ed, 2.2, 300, 0.4);
      sunLight.position.set(0, 0, 0);
      this.scene.add(sunLight);

      // Build Solar System & Launch Assets
      this.buildSun();
      this.buildPlanets();
      this.buildOrbitRings();
      this.buildTrajectoryCurve();
      this.buildRocketAndPad();

      // Setup Mouse Orbit & Touch controls
      this.setupControls();

      // Window resize
      window.addEventListener('resize', () => {
        if (!this.container) return;
        const nw = this.container.clientWidth || 800;
        const nh = this.container.clientHeight || 500;
        this.camera.aspect = nw / nh;
        this.camera.updateProjectionMatrix();
        this.renderer.setSize(nw, nh);
      });

      // Start RAF Loop
      this.renderLoop = this.renderLoop.bind(this);
      requestAnimationFrame(this.renderLoop);
    }

    buildStarfield() {
      const THREE = this.THREE;
      const starsCount = 450;
      const starGeo = new THREE.BufferGeometry();
      const positions = new Float32Array(starsCount * 3);

      for (let i = 0; i < starsCount * 3; i += 3) {
        const u = Math.random();
        const v = Math.random();
        const theta = u * 2.0 * Math.PI;
        const phi = Math.acos(2.0 * v - 1.0);
        const r = 180.0 + Math.random() * 40.0;
        positions[i] = r * Math.sin(phi) * Math.cos(theta);
        positions[i + 1] = r * Math.sin(phi) * Math.sin(theta);
        positions[i + 2] = r * Math.cos(phi);
      }
      starGeo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
      const starMat = new THREE.PointsMaterial({ color: 0xffffff, size: 1.2, transparent: true, opacity: 0.8 });
      const stars = new THREE.Points(starGeo, starMat);
      this.scene.add(stars);
    }

    buildSun() {
      const THREE = this.THREE;
      const sunGeo = new THREE.SphereGeometry(3.6, 32, 32);
      const sunMat = new THREE.MeshBasicMaterial({ color: 0xffb703 });
      this.sunMesh = new THREE.Mesh(sunGeo, sunMat);
      
      // Corona Glow Halo
      const coronaGeo = new THREE.SphereGeometry(4.4, 24, 24);
      const coronaMat = new THREE.MeshBasicMaterial({ color: 0xfb8500, transparent: true, opacity: 0.28 });
      const corona = new THREE.Mesh(coronaGeo, coronaMat);
      this.sunMesh.add(corona);

      this.scene.add(this.sunMesh);
    }

    buildPlanets() {
      const THREE = this.THREE;

      // 1. Earth & Moon System
      this.earthGroup = new THREE.Group();
      this.earthGroup.position.set(this.earthOrbitRadius, 0, 0);

      const earthGeo = new THREE.SphereGeometry(1.5, 32, 32);
      const earthMat = new THREE.MeshStandardMaterial({
        map: createEarthTexture(),
        roughness: 0.85,
        metalness: 0.15
      });
      this.earthMesh = new THREE.Mesh(earthGeo, earthMat);
      this.earthGroup.add(this.earthMesh);

      // Earth Atmosphere Rim Glow
      const atmoGeo = new THREE.SphereGeometry(1.7, 24, 24);
      const atmoMat = new THREE.MeshBasicMaterial({ color: 0x38bdf8, transparent: true, opacity: 0.22, side: THREE.BackSide });
      this.earthMesh.add(new THREE.Mesh(atmoGeo, atmoMat));

      // Orbiting Moon
      this.moonGroup = new THREE.Group();
      const moonGeo = new THREE.SphereGeometry(0.45, 20, 20);
      const moonMat = new THREE.MeshStandardMaterial({ map: createMoonTexture(), roughness: 0.95 });
      this.moonMesh = new THREE.Mesh(moonGeo, moonMat);
      this.moonMesh.position.set(3.2, 0, 0);
      this.moonGroup.add(this.moonMesh);
      this.earthGroup.add(this.moonGroup);

      this.scene.add(this.earthGroup);

      // 2. Mars Planet
      this.marsGroup = new THREE.Group();
      this.updateMarsPosition();

      const marsGeo = new THREE.SphereGeometry(1.15, 32, 32);
      const marsMat = new THREE.MeshStandardMaterial({
        map: createMarsTexture(),
        roughness: 0.9,
        metalness: 0.05
      });
      this.marsMesh = new THREE.Mesh(marsGeo, marsMat);
      this.marsGroup.add(this.marsMesh);

      this.scene.add(this.marsGroup);
    }

    buildOrbitRings() {
      const THREE = this.THREE;
      this.orbitLinesGroup = new THREE.Group();

      // Earth Orbit Ring (Cyan)
      const earthRingGeo = new THREE.RingGeometry(this.earthOrbitRadius - 0.05, this.earthOrbitRadius + 0.05, 96);
      earthRingGeo.rotateX(-Math.PI * 0.5);
      const earthRingMat = new THREE.MeshBasicMaterial({ color: 0x0284c7, side: THREE.DoubleSide, transparent: true, opacity: 0.45 });
      this.orbitLinesGroup.add(new THREE.Mesh(earthRingGeo, earthRingMat));

      // Mars Orbit Ring (Orange)
      const marsRingGeo = new THREE.RingGeometry(this.marsOrbitRadius - 0.05, this.marsOrbitRadius + 0.05, 96);
      marsRingGeo.rotateX(-Math.PI * 0.5);
      const marsRingMat = new THREE.MeshBasicMaterial({ color: 0xea580c, side: THREE.DoubleSide, transparent: true, opacity: 0.45 });
      this.orbitLinesGroup.add(new THREE.Mesh(marsRingGeo, marsRingMat));

      this.scene.add(this.orbitLinesGroup);
    }

    buildTrajectoryCurve() {
      const THREE = this.THREE;
      const points = [];
      for (let i = 0; i <= 60; i++) {
        points.push(new THREE.Vector3(0, 0, 0));
      }
      const geom = new THREE.BufferGeometry().setFromPoints(points);
      const mat = new THREE.LineBasicMaterial({ color: 0x38bdf8, linewidth: 2, transparent: true, opacity: 0.9 });
      this.trajectoryLine = new THREE.Line(geom, mat);
      this.scene.add(this.trajectoryLine);

      this.updateTrajectoryGeometry(3.9, this.phaseAngleDeg, 'mars');
    }

    buildRocketAndPad() {
      const THREE = this.THREE;
      this.rocketGroup = new THREE.Group();

      // Rocket Booster Core (White Cylinder)
      const bodyGeo = new THREE.CylinderGeometry(0.22, 0.26, 1.6, 16);
      const bodyMat = new THREE.MeshStandardMaterial({ color: 0xf1f5f9, metalness: 0.4, roughness: 0.3 });
      const body = new THREE.Mesh(bodyGeo, bodyMat);
      body.position.y = 0.8;
      this.rocketGroup.add(body);

      // Core Orange Tank Stripe
      const stripeGeo = new THREE.CylinderGeometry(0.23, 0.23, 0.5, 16);
      const stripeMat = new THREE.MeshStandardMaterial({ color: 0xf97316 });
      stripeGeo.translate(0, 0.7, 0);
      this.rocketGroup.add(new THREE.Mesh(stripeGeo, stripeMat));

      // Payload Fairing Cone (Nose)
      const fairingGeo = new THREE.ConeGeometry(0.22, 0.6, 16);
      const fairingMat = new THREE.MeshStandardMaterial({ color: 0xffffff });
      fairingGeo.translate(0, 1.9, 0);
      this.rocketGroup.add(new THREE.Mesh(fairingGeo, fairingMat));

      // 4 Grid Fins at Base
      for (let f = 0; f < 4; f++) {
        const finGeo = new THREE.BoxGeometry(0.04, 0.22, 0.22);
        const finMat = new THREE.MeshStandardMaterial({ color: 0x334155 });
        const fin = new THREE.Mesh(finGeo, finMat);
        const angle = (f * Math.PI) / 2;
        fin.position.set(Math.cos(angle) * 0.24, 0.2, Math.sin(angle) * 0.24);
        fin.rotation.y = angle;
        this.rocketGroup.add(fin);
      }

      // Main Engine Bell & Flame Cone
      const engineGeo = new THREE.ConeGeometry(0.14, 0.25, 12);
      engineGeo.rotateX(Math.PI);
      const engineMat = new THREE.MeshStandardMaterial({ color: 0x0f172a, metalness: 0.8 });
      const engine = new THREE.Mesh(engineGeo, engineMat);
      engine.position.y = -0.05;
      this.rocketGroup.add(engine);

      // Rocket Exhaust Flame (Orange Glow)
      const flameGeo = new THREE.ConeGeometry(0.18, 0.8, 12);
      flameGeo.rotateX(Math.PI);
      const flameMat = new THREE.MeshBasicMaterial({ color: 0x38bdf8, transparent: true, opacity: 0.9 });
      this.flameMesh = new THREE.Mesh(flameGeo, flameMat);
      this.flameMesh.position.y = -0.55;
      this.flameMesh.visible = false;
      this.rocketGroup.add(this.flameMesh);

      // Deployed Solar Panels (for interplanetary cruise)
      this.solarWings = new THREE.Group();
      const wingGeo = new THREE.BoxGeometry(1.2, 0.02, 0.35);
      const wingMat = new THREE.MeshStandardMaterial({ color: 0x0284c7, metalness: 0.7, roughness: 0.2 });
      const leftWing = new THREE.Mesh(wingGeo, wingMat);
      leftWing.position.set(-0.85, 1.1, 0);
      const rightWing = new THREE.Mesh(wingGeo, wingMat);
      rightWing.position.set(0.85, 1.1, 0);
      this.solarWings.add(leftWing, rightWing);
      this.solarWings.visible = false;
      this.rocketGroup.add(this.solarWings);

      // Scale down rocket for orrery view
      this.rocketGroup.scale.set(0.8, 0.8, 0.8);
      this.scene.add(this.rocketGroup);
      this.resetRocketToLaunchpad();
    }

    setupControls() {
      const el = this.renderer.domElement;

      el.addEventListener('pointerdown', (e) => {
        this.isDragging = true;
        this.prevMouse = { x: e.clientX, y: e.clientY };
      });

      window.addEventListener('pointermove', (e) => {
        if (!this.isDragging) return;
        const dx = e.clientX - this.prevMouse.x;
        const dy = e.clientY - this.prevMouse.y;
        this.prevMouse = { x: e.clientX, y: e.clientY };

        this.camRotX -= dx * 0.008;
        this.camRotY = Math.max(0.08, Math.min(1.45, this.camRotY + dy * 0.008));
        this.updateCameraPosition();
      });

      window.addEventListener('pointerup', () => {
        this.isDragging = false;
      });

      el.addEventListener('wheel', (e) => {
        e.preventDefault();
        this.camDistance = Math.max(8.0, Math.min(85.0, this.camDistance + e.deltaY * 0.04));
        this.updateCameraPosition();
      }, { passive: false });
    }

    updateCameraPosition() {
      if (this.viewMode === 'orrery') {
        const x = this.camDistance * Math.sin(this.camRotX) * Math.cos(this.camRotY);
        const z = this.camDistance * Math.cos(this.camRotX) * Math.cos(this.camRotY);
        const y = this.camDistance * Math.sin(this.camRotY);
        this.camera.position.set(x, y, z);
        this.camera.lookAt(0, 0, 0);
      } else if (this.viewMode === 'pad') {
        const p = this.earthGroup.position;
        this.camera.position.set(p.x + 3.5, p.y + 2.5, p.z + 4.5);
        this.camera.lookAt(p.x, p.y + 1.2, p.z);
      } else if (this.viewMode === 'ship') {
        const p = this.rocketGroup.position;
        this.camera.position.set(p.x - 2.8, p.y + 1.8, p.z + 3.2);
        this.camera.lookAt(p.x, p.y + 0.6, p.z);
      }
    }

    setViewMode(mode) {
      this.viewMode = mode;
      if (mode === 'orrery') {
        this.camDistance = 42.0;
      }
      this.updateCameraPosition();
    }

    setPhaseAngle(angleDeg) {
      this.phaseAngleDeg = angleDeg;
      this.updateMarsPosition();
      this.updateTrajectoryGeometry(3.9, this.phaseAngleDeg, this.route);
    }

    setRoute(route) {
      this.route = route;
      this.updateTrajectoryGeometry(3.9, this.phaseAngleDeg, this.route);
      this.resetRocketToLaunchpad();
    }

    updateMarsPosition() {
      const rad = (this.phaseAngleDeg * Math.PI) / 180.0;
      const mx = Math.cos(rad) * this.marsOrbitRadius;
      const mz = -Math.sin(rad) * this.marsOrbitRadius;
      this.marsGroup.position.set(mx, 0, mz);
    }

    updateTrajectoryGeometry(deltaV, phaseAngleDeg, route) {
      if (!this.trajectoryLine) return;
      const THREE = this.THREE;
      const points = [];
      const numSteps = 60;

      const pStart = this.earthGroup.position.clone();
      let pTarget;

      if (route === 'moon') {
        // Moon trajectory
        pTarget = new THREE.Vector3().copy(this.earthGroup.position).add(this.moonMesh.position);
        for (let i = 0; i <= numSteps; i++) {
          const t = i / numSteps;
          const pos = new THREE.Vector3().lerpVectors(pStart, pTarget, t);
          // Arch upward slightly
          pos.y += Math.sin(t * Math.PI) * 1.5;
          points.push(pos);
        }
        this.trajectoryLine.material.color.setHex(0x38bdf8);
      } else {
        // Interplanetary Hohmann Ellipse to Mars
        pTarget = this.marsGroup.position.clone();
        
        // Calculate Hohmann transfer ellipse apex
        const targetRadius = this.marsOrbitRadius;
        const originRadius = this.earthOrbitRadius;
        const isOptimalAngle = Math.abs(phaseAngleDeg - 44.4) < 8.0;
        const isEnoughDeltaV = deltaV >= 3.6;

        for (let i = 0; i <= numSteps; i++) {
          const t = i / numSteps;
          const theta = t * Math.PI; // 180 degree Hohmann half-ellipse

          // Interpolate radius from Earth orbit to Mars orbit
          let r = originRadius + (targetRadius - originRadius) * Math.sin(t * Math.PI * 0.5);
          
          if (!isEnoughDeltaV) {
            // Sub-orbital: falls back before reaching Mars orbit
            r = originRadius + (deltaV / 3.9) * (targetRadius - originRadius) * Math.sin(t * Math.PI * 0.5);
          }

          const angle = theta * 0.65;
          const x = Math.cos(angle) * r;
          const z = -Math.sin(angle) * r;
          const y = Math.sin(t * Math.PI) * 1.8;
          points.push(new THREE.Vector3(x, y, z));
        }

        // Color coding: Cyan if locked, Orange if suboptimal, Rose if suborbital
        if (isOptimalAngle && isEnoughDeltaV) {
          this.trajectoryLine.material.color.setHex(0x10b981); // Emerald Green Intercept
        } else if (!isEnoughDeltaV) {
          this.trajectoryLine.material.color.setHex(0xf43f5e); // Rose Fail Suborbital
        } else {
          this.trajectoryLine.material.color.setHex(0xfbbf24); // Amber Caution
        }
      }

      this.trajectoryLine.geometry.setFromPoints(points);
      this.trajectoryPoints = points;
    }

    resetRocketToLaunchpad() {
      this.isAnimatingLaunch = false;
      this.launchProgress = 0.0;
      this.solarWings.visible = false;
      this.flameMesh.visible = false;

      // Place rocket standing upright on Earth (or on pad)
      this.rocketGroup.position.copy(this.earthGroup.position);
      this.rocketGroup.position.y += 1.5;
      this.rocketGroup.rotation.set(0, 0, 0);
      this.rocketGroup.scale.set(0.65, 0.65, 0.65);
    }

    startLaunchSequence(params, onComplete) {
      this.isAnimatingLaunch = true;
      this.launchProgress = 0.0;
      this.launchParams = params;
      this.onLaunchCompleteCallback = onComplete;
      this.flameMesh.visible = true;
      this.flameMesh.material.color.setHex(0xf97316); // Ignition Orange
    }

    renderLoop() {
      requestAnimationFrame(this.renderLoop);

      // Rotate Sun corona
      if (this.sunMesh) {
        this.sunMesh.rotation.y += 0.002;
      }

      // Rotate Earth & Moon on axes
      if (this.earthMesh) {
        this.earthMesh.rotation.y += 0.01;
      }
      if (this.moonGroup) {
        this.moonGroup.rotation.y += 0.006;
      }
      if (this.marsMesh) {
        this.marsMesh.rotation.y += 0.008;
      }

      // Handle Launch Flight Animation
      if (this.isAnimatingLaunch && this.trajectoryPoints && this.trajectoryPoints.length > 1) {
        this.launchProgress += 0.0035;

        // Stage 1: Pad Liftoff & Gravity Turn (0.0 to 0.15)
        if (this.launchProgress < 0.15) {
          const t = this.launchProgress / 0.15;
          this.rocketGroup.position.y = 1.5 + t * 2.5;
          this.rocketGroup.rotation.z = -t * (this.launchParams.pitchAngle * (Math.PI / 180.0));
          this.flameMesh.scale.set(1 + Math.random() * 0.4, 1 + Math.random() * 0.5, 1);
        }
        // Stage 2: Staging & Trans-Planetary Injection (0.15 to 0.3)
        else if (this.launchProgress < 0.3) {
          this.solarWings.visible = true; // Deployed solar arrays
          this.flameMesh.material.color.setHex(0x38bdf8); // Blue Ion / Hydrolox burn
          this.flameMesh.scale.set(0.7, 1.2, 0.7);

          const ptIdx = Math.floor(((this.launchProgress - 0.15) / 0.85) * (this.trajectoryPoints.length - 1));
          const pt = this.trajectoryPoints[Math.min(ptIdx, this.trajectoryPoints.length - 1)];
          this.rocketGroup.position.copy(pt);
          this.rocketGroup.rotation.z = -0.6;
        }
        // Stage 3: Interplanetary Hohmann Cruise (0.3 to 0.88)
        else if (this.launchProgress < 0.88) {
          this.flameMesh.visible = (Math.random() > 0.85); // Coast phase with occasional RCS pulses

          const ptIdx = Math.floor(((this.launchProgress - 0.15) / 0.85) * (this.trajectoryPoints.length - 1));
          const pt = this.trajectoryPoints[Math.min(ptIdx, this.trajectoryPoints.length - 1)];
          this.rocketGroup.position.copy(pt);
          
          // Tangent orientation along curve
          if (ptIdx < this.trajectoryPoints.length - 1) {
            const nextPt = this.trajectoryPoints[ptIdx + 1];
            this.rocketGroup.lookAt(nextPt.x, nextPt.y + 0.5, nextPt.z);
          }
        }
        // Stage 4: Arrival & Planetary Retro-Capture (0.88 to 1.0)
        else if (this.launchProgress < 1.0) {
          this.flameMesh.visible = true; // Retro burn!
          this.flameMesh.material.color.setHex(0xf97316);

          const targetPos = (this.route === 'moon') 
            ? this.earthGroup.position.clone().add(this.moonMesh.position)
            : this.marsGroup.position;

          this.rocketGroup.position.lerp(targetPos, 0.08);
        }
        // Flight Complete!
        else {
          this.isAnimatingLaunch = false;
          this.flameMesh.visible = false;
          if (this.onLaunchCompleteCallback) {
            this.onLaunchCompleteCallback();
          }
        }

        // Camera follow if in 'ship' view
        if (this.viewMode === 'ship') {
          this.updateCameraPosition();
        }
      }

      this.renderer.render(this.scene, this.camera);
    }
  }

  // --- 3. LAUNCH LAB UI & NASA PHYSICS CONTROLLER ---
  class LaunchLabManager {
    constructor() {
      this.world3D = null;
      this.route = 'mars'; // 'moon' or 'mars'
      this.phaseAngle = 44.4; // degrees
      this.deltaV = 3.9; // km/s
      this.pitchAngle = 20; // degrees
      this.weather = 'quiet'; // 'quiet', 'm-class', 'x-class'
      this.hasStormShelter = false;
      this.isSimulating = false;
    }

    init() {
      const container = document.getElementById('launch-lab-canvas-container');
      if (container) {
        this.world3D = new LaunchLabWorld3D(container);
      }
      this.bindEvents();
      this.updatePhysicsCalculations();
    }

    bindEvents() {
      // 1. Route Selection Tabs
      document.querySelectorAll('.btn-lab-route').forEach(btn => {
        btn.addEventListener('click', () => {
          document.querySelectorAll('.btn-lab-route').forEach(b => {
            b.classList.remove('bg-sky-500', 'text-slate-950', 'font-black');
            b.classList.add('bg-slate-800', 'text-slate-300');
          });
          btn.classList.remove('bg-slate-800', 'text-slate-300');
          btn.classList.add('bg-sky-500', 'text-slate-950', 'font-black');

          this.route = btn.getAttribute('data-route');
          if (this.route === 'moon') {
            document.getElementById('slider-phase-angle').value = 110;
            document.getElementById('slider-deltav').value = 3.2;
            this.phaseAngle = 110;
            this.deltaV = 3.2;
          } else {
            document.getElementById('slider-phase-angle').value = 44;
            document.getElementById('slider-deltav').value = 3.9;
            this.phaseAngle = 44.4;
            this.deltaV = 3.9;
          }
          if (this.world3D) this.world3D.setRoute(this.route);
          this.updatePhysicsCalculations();
        });
      });

      // 2. View Mode Buttons
      document.querySelectorAll('.btn-lab-view').forEach(btn => {
        btn.addEventListener('click', () => {
          document.querySelectorAll('.btn-lab-view').forEach(b => b.classList.remove('bg-purple-600', 'text-white'));
          btn.classList.add('bg-purple-600', 'text-white');
          const mode = btn.getAttribute('data-view');
          if (this.world3D) this.world3D.setViewMode(mode);
        });
      });

      // 3. Phase Angle Slider
      const phaseSlider = document.getElementById('slider-phase-angle');
      if (phaseSlider) {
        phaseSlider.addEventListener('input', (e) => {
          this.phaseAngle = parseFloat(e.target.value);
          document.getElementById('val-phase-angle').innerText = `${this.phaseAngle}°`;
          if (this.world3D) this.world3D.setPhaseAngle(this.phaseAngle);
          this.updatePhysicsCalculations();
        });
      }

      // 4. Delta-v Slider
      const deltaVSlider = document.getElementById('slider-deltav');
      if (deltaVSlider) {
        deltaVSlider.addEventListener('input', (e) => {
          this.deltaV = parseFloat(e.target.value);
          document.getElementById('val-deltav').innerText = `${this.deltaV.toFixed(1)} km/s`;
          this.updatePhysicsCalculations();
        });
      }

      // 5. Pitch Angle Slider
      const pitchSlider = document.getElementById('slider-pitch');
      if (pitchSlider) {
        pitchSlider.addEventListener('input', (e) => {
          this.pitchAngle = parseInt(e.target.value);
          document.getElementById('val-pitch').innerText = `${this.pitchAngle}°`;
          this.updatePhysicsCalculations();
        });
      }

      // 6. Space Weather Radio Buttons
      document.querySelectorAll('input[name="lab-weather"]').forEach(radio => {
        radio.addEventListener('change', (e) => {
          this.weather = e.target.value;
          this.updatePhysicsCalculations();
        });
      });

      // 7. Radiation Storm Shelter Checkbox
      const shelterChk = document.getElementById('chk-storm-shelter');
      if (shelterChk) {
        shelterChk.addEventListener('change', (e) => {
          this.hasStormShelter = e.target.checked;
          this.updatePhysicsCalculations();
        });
      }

      // 8. Auto-Tune NASA Baseline Button
      document.getElementById('btn-lab-autotune')?.addEventListener('click', () => {
        if (window.audioService) audioService.playChime();
        this.autoTuneNasaBaseline();
      });

      // 9. Reset Pad Button
      document.getElementById('btn-lab-reset')?.addEventListener('click', () => {
        if (window.audioService) audioService.playClick();
        if (this.world3D) this.world3D.resetRocketToLaunchpad();
        document.getElementById('lab-feedback-banner').className = "p-3 rounded-2xl bg-slate-900 border border-slate-700 text-xs text-slate-300";
        document.getElementById('lab-feedback-banner').innerText = "💡 Configure your orbital flight parameters above and initiate launch!";
      });

      // 10. INITIATE LAUNCH BUTTON
      document.getElementById('btn-lab-launch')?.addEventListener('click', () => {
        this.executeLaunch();
      });
    }

    autoTuneNasaBaseline() {
      if (this.route === 'mars') {
        this.phaseAngle = 44.4;
        this.deltaV = 3.9;
        this.pitchAngle = 20;
        this.weather = 'quiet';
        document.getElementById('slider-phase-angle').value = 44;
        document.getElementById('slider-deltav').value = 3.9;
        document.getElementById('slider-pitch').value = 20;
        document.getElementById('weather-quiet').checked = true;
      } else {
        this.phaseAngle = 110.0;
        this.deltaV = 3.2;
        this.pitchAngle = 22;
        this.weather = 'quiet';
        document.getElementById('slider-phase-angle').value = 110;
        document.getElementById('slider-deltav').value = 3.2;
        document.getElementById('slider-pitch').value = 22;
        document.getElementById('weather-quiet').checked = true;
      }
      document.getElementById('val-phase-angle').innerText = `${this.phaseAngle}°`;
      document.getElementById('val-deltav').innerText = `${this.deltaV.toFixed(1)} km/s`;
      document.getElementById('val-pitch').innerText = `${this.pitchAngle}°`;
      
      if (this.world3D) {
        this.world3D.setPhaseAngle(this.phaseAngle);
        this.world3D.updateTrajectoryGeometry(this.deltaV, this.phaseAngle, this.route);
      }
      this.updatePhysicsCalculations();
      if (window.audioService) {
        audioService.speak("Optimal NASA Hohmann transfer baseline locked. Ready for ignition countdown.", "nova");
      }
    }

    updatePhysicsCalculations() {
      const isMars = (this.route === 'mars');
      const targetPhase = isMars ? 44.4 : 110.0;
      const targetDeltaV = isMars ? 3.9 : 3.2;

      const phaseDiff = Math.abs(this.phaseAngle - targetPhase);
      const isWindowValid = phaseDiff <= 7.0;
      const isThrustValid = this.deltaV >= (targetDeltaV - 0.2);
      const isPitchSafe = (this.pitchAngle >= 14 && this.pitchAngle <= 28);
      const isRadiationSafe = (this.weather === 'quiet' || this.hasStormShelter);

      // Trajectory Status
      const statusBadge = document.getElementById('lab-calc-status');
      const transitVal = document.getElementById('lab-calc-time');
      const gforceVal = document.getElementById('lab-calc-gforce');
      const radVal = document.getElementById('lab-calc-radiation');

      if (!statusBadge) return;

      if (!isThrustValid) {
        statusBadge.innerText = "SUB-ORBITAL FALLBACK";
        statusBadge.className = "text-[10px] px-2.5 py-0.5 rounded-full bg-rose-500/20 text-rose-300 font-mono font-bold border border-rose-500/40";
      } else if (!isWindowValid) {
        statusBadge.innerText = "ORBITAL FLYBY MISS";
        statusBadge.className = "text-[10px] px-2.5 py-0.5 rounded-full bg-amber-500/20 text-amber-300 font-mono font-bold border border-amber-500/40";
      } else if (!isPitchSafe) {
        statusBadge.innerText = "MAX-Q DYNAMIC FAIL";
        statusBadge.className = "text-[10px] px-2.5 py-0.5 rounded-full bg-rose-500/20 text-rose-300 font-mono font-bold border border-rose-500/40";
      } else if (!isRadiationSafe) {
        statusBadge.innerText = "DONKI RADIATION HAZARD";
        statusBadge.className = "text-[10px] px-2.5 py-0.5 rounded-full bg-purple-500/20 text-purple-300 font-mono font-bold border border-purple-500/40";
      } else {
        statusBadge.innerText = "INTERCEPT LOCKED (100%)";
        statusBadge.className = "text-[10px] px-2.5 py-0.5 rounded-full bg-emerald-500/20 text-emerald-300 font-mono font-bold border border-emerald-500/40";
      }

      // Transit Duration
      if (isMars) {
        const speedFactor = this.deltaV / 3.9;
        const days = Math.round(259 / Math.max(0.7, speedFactor));
        transitVal.innerText = `${days} Days (~${(days/30).toFixed(1)} Months)`;
      } else {
        transitVal.innerText = "3 Days (72 Hours)";
      }

      // G-Forces
      const g = 1.0 + (this.deltaV * 0.65) * (30 / this.pitchAngle);
      gforceVal.innerText = `${Math.min(6.5, g).toFixed(1)} Gs ${g <= 4.2 ? '(Safe)' : '(High Stress)'}`;

      // Radiation Dose (OSDR NASA Data)
      let mSv = isMars ? 120 : 15;
      if (this.weather === 'm-class') mSv += 85;
      if (this.weather === 'x-class') mSv += 320;
      if (this.hasStormShelter) mSv = Math.round(mSv * 0.28);
      radVal.innerText = `${mSv} mSv ${mSv < 250 ? '(Nominal)' : '(EXCEEDS OSDR LIMIT)'}`;

      // Live 3D Trajectory Update
      if (this.world3D) {
        this.world3D.updateTrajectoryGeometry(this.deltaV, this.phaseAngle, this.route);
      }
    }

    executeLaunch() {
      if (this.isSimulating) return;
      this.isSimulating = true;

      const isMars = (this.route === 'mars');
      const targetPhase = isMars ? 44.4 : 110.0;
      const targetDeltaV = isMars ? 3.9 : 3.2;

      const phaseDiff = Math.abs(this.phaseAngle - targetPhase);
      const isWindowValid = phaseDiff <= 7.0;
      const isThrustValid = this.deltaV >= (targetDeltaV - 0.2);
      const isPitchSafe = (this.pitchAngle >= 14 && this.pitchAngle <= 28);
      const isRadiationSafe = (this.weather === 'quiet' || this.hasStormShelter);

      const isMissionSuccess = isWindowValid && isThrustValid && isPitchSafe && isRadiationSafe;

      // Audio countdown & roar
      if (window.audioService) {
        audioService.playAlert();
        audioService.speak("T-minus 3... 2... 1... Main engine ignition and liftoff of the Ares interplanetary transport vehicle!", "nova");
      }

      const banner = document.getElementById('lab-feedback-banner');
      banner.className = "p-3 rounded-2xl bg-amber-950/80 border border-amber-500/50 text-xs text-amber-200 animate-pulse";
      banner.innerText = "🚀 LIFTOFF! Spacecraft clearing launch tower and commencing gravity turn corridor...";

      // Switch to Rocket/Pad view initially
      if (this.world3D) {
        this.world3D.setViewMode('pad');
        this.world3D.startLaunchSequence({ pitchAngle: this.pitchAngle }, () => {
          this.isSimulating = false;
          this.handleFlightCompletion(isMissionSuccess, {
            isWindowValid,
            isThrustValid,
            isPitchSafe,
            isRadiationSafe,
            phaseDiff
          });
        });

        // After 2.5 seconds, auto-switch to orbital orrery view to watch transfer
        setTimeout(() => {
          if (this.world3D && this.isSimulating) {
            this.world3D.setViewMode('orrery');
            banner.innerText = "🛰️ TRANS-PLANETARY INJECTION: Cruising along Hohmann transfer arc to " + (isMars ? 'Mars' : 'Moon') + "...";
          }
        }, 2800);
      }
    }

    handleFlightCompletion(success, details) {
      const banner = document.getElementById('lab-feedback-banner');
      const modal = document.getElementById('modal-lab-outcome');

      if (success) {
        banner.className = "p-3 rounded-2xl bg-emerald-950/90 border border-emerald-400 text-xs text-emerald-200";
        banner.innerText = `🏆 MISSION ACCOMPLISHED! Perfect Hohmann transfer orbit achieved. Spacecraft captured into ${this.route === 'mars' ? 'Mars Jezero' : 'Lunar Shackleton'} orbit!`;

        if (window.audioService) {
          audioService.playChime();
          audioService.speak("Flight successful! Orbital capture confirmed. Artemis and Ares landing sites clear.", "nova");
        }

        // Show outcome modal
        if (modal) {
          document.getElementById('lab-outcome-title').innerText = "🏆 Interplanetary Flight Successful!";
          document.getElementById('lab-outcome-desc').innerText = `You balanced all flight parameters: ${this.phaseAngle}° phase angle, ${this.deltaV.toFixed(1)} km/s Δv, and safe space weather clearances. Your astronaut crew is ready to establish their surface outpost!`;
          document.getElementById('btn-lab-outcome-proceed').innerText = `Enter 3D Outpost Architect (${this.route === 'mars' ? 'Mars Jezero' : 'Moon Shackleton'}) →`;
          modal.classList.remove('hidden');
          modal.style.display = 'flex';
        }
      } else {
        let failReason = "";
        if (!details.isThrustValid) {
          failReason = `Insufficient Delta-v (${this.deltaV.toFixed(1)} km/s). Rocket could not overcome Earth's gravitational well (required ≥ ${this.route === 'mars' ? '3.7' : '3.1'} km/s). Spacecraft fell back sub-orbitally!`;
        } else if (!details.isWindowValid) {
          failReason = `Planetary Alignment Mismatch! Mars was at ${this.phaseAngle}° instead of the required +44° Hohmann window. The spacecraft missed ${this.route === 'mars' ? 'Mars' : 'Moon'} by ${(details.phaseDiff * 1.8).toFixed(1)} million kilometers!`;
        } else if (!details.isPitchSafe) {
          failReason = `Aerodynamic Max-Q Failure! A launch pitch of ${this.pitchAngle}° placed excessive dynamic shear stress on the fairing during supersonic ascent. Optimal gravity turn corridor is 15° to 25°.`;
        } else if (!details.isRadiationSafe) {
          failReason = `Radiation Dose Failure! A NASA DONKI ${this.weather.toUpperCase()} Solar Flare erupted during transit. Without a storm shelter, astronauts exceeded safe biological limits.`;
        }

        banner.className = "p-3 rounded-2xl bg-rose-950/90 border border-rose-500 text-xs text-rose-200";
        banner.innerText = `⚠️ LAUNCH FAILED: ${failReason}`;

        if (window.audioService) {
          audioService.playAlert();
          audioService.speak("Flight aborted. Review orbital mechanics failure diagnosis and auto-tune parameters to retry.", "nova");
        }

        if (modal) {
          document.getElementById('lab-outcome-title').innerText = "⚠️ Trajectory Anomaly Detected!";
          document.getElementById('lab-outcome-desc').innerText = failReason;
          document.getElementById('btn-lab-outcome-proceed').innerText = "Auto-Tune NASA Parameters & Retry";
          modal.classList.remove('hidden');
          modal.style.display = 'flex';
        }
      }
    }
  }

  // Expose globally
  window.LaunchLabWorld3D = LaunchLabWorld3D;
  window.LaunchLabManager = LaunchLabManager;

})(typeof window !== 'undefined' ? window : this);

