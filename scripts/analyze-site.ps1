param([string]$Path)
$h = Get-Content $Path -Raw
$title = [regex]::Match($h, '<title>(.*?)</title>').Groups[1].Value
$desc = [regex]::Match($h, 'name=["'']description["''] content=["''](.*?)["'']').Groups[1].Value
$gen = [regex]::Match($h, 'name=["'']generator["''] content=["''](.*?)["'']').Groups[1].Value
Write-Host "TITLE: $title"
Write-Host "META_DESC: $($desc.Substring(0, [Math]::Min(180, $desc.Length)))"
Write-Host "GENERATOR: $gen"
Write-Host "H1: $([regex]::Matches($h, '<h1').Count)"
Write-Host "H2: $([regex]::Matches($h, '<h2').Count)"
Write-Host "IMG: $([regex]::Matches($h, '<img').Count)"
Write-Host "SCRIPT: $([regex]::Matches($h, '<script').Count)"
Write-Host "CSS_LINKS: $([regex]::Matches($h, 'stylesheet').Count)"
Write-Host "LAZY_LOADING: $([regex]::Matches($h, 'loading=["'']lazy').Count)"
Write-Host "JSONLD_SCHEMA: $([regex]::Matches($h, 'application/ld\+json').Count)"
Write-Host "OG_TAGS: $([regex]::Matches($h, 'property=["'']og:').Count)"
Write-Host "ZALO_MENTIONS: $([regex]::Matches($h, 'zalo', 'IgnoreCase').Count)"
Write-Host "MESSENGER: $([regex]::Matches($h, 'messenger|m\.me', 'IgnoreCase').Count)"
Write-Host "TEL_LINKS: $([regex]::Matches($h, 'tel:').Count)"
Write-Host "WEBP_REFS: $([regex]::Matches($h, '\.webp').Count)"
Write-Host "IFRAME: $([regex]::Matches($h, '<iframe').Count)"
Write-Host "FONT_GOOGLE: $([regex]::Matches($h, 'fonts.googleapis|fonts.bunny').Count)"
$analyticsPattern = 'gtag|googletagmanager|fbq|facebook\.net'
Write-Host "ANALYTICS: $([regex]::Matches($h, $analyticsPattern, 'IgnoreCase').Count)"
Write-Host "HREFLANG: $([regex]::Matches($h, 'hreflang').Count)"
Write-Host "CANONICAL: $([regex]::Matches($h, 'rel=["'']canonical').Count)"