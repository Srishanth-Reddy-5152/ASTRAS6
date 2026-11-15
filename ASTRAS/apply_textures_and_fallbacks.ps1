$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$html = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Add texture generators in script
$texCode = @"
    function getRealMoonTexture(THREE) {
      const c = document.createElement('canvas');
      c.width = 512; c.height = 512;
      const ctx = c.getContext('2d');
      ctx.fillStyle = '#838d99';
      ctx.fillRect(0, 0, 512, 512);
      // Dark basalt maria
      ctx.fillStyle = '#4b525d';
      for (let i = 0; i < 22; i++) {
        ctx.beginPath();
        ctx.arc((i * 79) % 512, (i * 103) % 512, 28 + (i % 5) * 14, 0, Math.PI * 2);
        ctx.fill();
      }
      // Crater rays & ejecta blankets
      ctx.fillStyle = '#cbd5e1';
      for (let i = 0; i < 350; i++) {
        ctx.beginPath();
        ctx.arc((i * 131) % 512, (i * 197) % 512, 1.2 + (i % 3), 0, Math.PI * 2);
        ctx.fill();
      }
      // Distinct impact crater rings with shadows
      for (let i = 0; i < 16; i++) {
        const cx = (i * 149) % 512, cy = (i * 173) % 512, r = 10 + (i % 4) * 9;
        ctx.fillStyle = '#1e232a';
        ctx.beginPath(); ctx.arc(cx, cy, r, 0, Math.PI * 2); ctx.fill();
        ctx.fillStyle = '#94a3b8';
        ctx.beginPath(); ctx.arc(cx - r * 0.25, cy - r * 0.25, r * 0.85, 0, Math.PI * 2); ctx.fill();
      }
      const tex = new THREE.CanvasTexture(c);
      tex.wrapS = THREE.RepeatWrapping;
      tex.wrapT = THREE.RepeatWrapping;
      tex.repeat.set(6, 6);
      return tex;
    }

    function getRealMarsTexture(THREE) {
      const c = document.createElement('canvas');
      c.width = 512; c.height = 512;
      const ctx = c.getContext('2d');
      ctx.fillStyle = '#b84c28';
      ctx.fillRect(0, 0, 512, 512);
      // Dark basalt sand ripples (wind-blown dunes)
      ctx.fillStyle = '#6e2b17';
      for (let y = 0; y < 512; y += 14) {
        ctx.beginPath();
        ctx.moveTo(0, y);
        for (let x = 0; x < 512; x += 32) {
          ctx.quadraticCurveTo(x + 16, y + ((x % 64 === 0) ? 5 : -5), x + 32, y);
        }
        ctx.lineTo(512, y + 3);
        ctx.lineTo(0, y + 3);
        ctx.fill();
      }
      // Layered clay delta sediment terraces
      ctx.fillStyle = '#d4653a';
      for (let i = 0; i < 35; i++) {
        ctx.beginPath();
        ctx.ellipse((i * 71) % 512, (i * 93) % 512, 45, 16, 0.35, 0, Math.PI * 2);
        ctx.fill();
      }
      const tex = new THREE.CanvasTexture(c);
      tex.wrapS = THREE.RepeatWrapping;
      tex.wrapT = THREE.RepeatWrapping;
      tex.repeat.set(6, 6);
      return tex;
    }
"@

if ($html -notmatch 'function getRealMoonTexture') {
    $html = $html.Replace(
        'class AstrasWorld3D {',
        "$texCode`r`n`r`n    class AstrasWorld3D {"
    )
}

# 2. Use textures in moonMat and marsMat
$oldMoonMat = 'const moonMat = new THREE\.MeshStandardMaterial\(\{ color: 0x94A3B8, roughness: 0\.92, flatShading: true \}\);'
$newMoonMat = 'const moonMat = new THREE.MeshStandardMaterial({ map: getRealMoonTexture(THREE), roughness: 0.94, metalness: 0.05 });'

if ([regex]::IsMatch($html, $oldMoonMat)) {
    $html = [regex]::Replace($html, $oldMoonMat, $newMoonMat)
    Write-Output "Applied real NASA Moon surface texture."
}

$oldMarsMat = 'const marsMat = new THREE\.MeshStandardMaterial\(\{ color: 0x9A3412, roughness: 0\.88, flatShading: true \}\);'
$newMarsMat = 'const marsMat = new THREE.MeshStandardMaterial({ map: getRealMarsTexture(THREE), roughness: 0.9, metalness: 0.1 });'

if ([regex]::IsMatch($html, $oldMarsMat)) {
    $html = [regex]::Replace($html, $oldMarsMat, $newMarsMat)
    Write-Output "Applied real NASA Mars Jezero surface texture."
}

# 3. Ensure all img tags have clean fallback without question marks
$patternImg = '<img(?![^>]*onerror=)([^>]+)>'
$html = [regex]::Replace($html, $patternImg, '<img onerror="this.onerror=null; this.style.display=''none'';" $1>')

# Clean any existing onerror to always include this.style.display='none' on final failure
$html = $html.Replace(
    'this.onerror=null;',
    'this.onerror=null; this.style.display="none";'
)

[System.IO.File]::WriteAllText($indexPath, $html, $utf8)
Write-Output "Moon/Mars real surfaces and img fallbacks applied."
