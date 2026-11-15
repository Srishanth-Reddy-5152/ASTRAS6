$indexPath = "c:\Users\HP\.antigravity-ide\ASTRAS\index.html"
$utf8 = [System.Text.Encoding]::UTF8
$content = [System.IO.File]::ReadAllText($indexPath, $utf8)

# 1. Add assets_data.js script tag in head if missing
if ($content -notmatch 'assets_data.js') {
    $content = $content.Replace(
        '<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>',
        "<script src=`"assets_data.js`"></script>`r`n  <script src=`"https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js`"></script>"
    )
}

# 2. Add getAstrasAsset helper function in script
if ($content -notmatch 'function getAstrasAsset') {
    $helperJs = @"
    function getAstrasAsset(name) {
      if (typeof window !== 'undefined' && window.ASTRAS_ASSETS && window.ASTRAS_ASSETS[name]) {
        return window.ASTRAS_ASSETS[name];
      }
      return 'assets/' + name + '.png';
    }
"@
    $content = $content.Replace(
        'class AudioService {',
        "$helperJs`r`n`r`n    class AudioService {"
    )
}

[System.IO.File]::WriteAllText($indexPath, $content, $utf8)
Write-Output "Applied assets_data.js script link and getAstrasAsset helper."
