[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$files = @('dist\index.html', 'dist\san-pham\index.html', 'dist\du-an\index.html')
foreach ($f in $files) {
  if (Test-Path $f) {
    $c = Get-Content $f -Raw -Encoding UTF8
    Write-Host "$f | size=$($c.Length) chars"
  } else {
    Write-Host "$f MISSING"
  }
}
Write-Host '---SEO TAG COUNTS IN dist/index.html---'
$h = Get-Content 'dist\index.html' -Raw -Encoding UTF8
Write-Host ('meta-desc  = ' + [regex]::Matches($h, 'name="description"').Count)
Write-Host ('robots     = ' + [regex]::Matches($h, 'name="robots"').Count)
Write-Host ('canonical  = ' + [regex]::Matches($h, 'rel="canonical"').Count)
Write-Host ('og-tags    = ' + [regex]::Matches($h, 'property="og:').Count)
Write-Host ('twitter    = ' + [regex]::Matches($h, 'name="twitter:').Count)
Write-Host ('jsonld     = ' + [regex]::Matches($h, 'application/ld\+json').Count)
Write-Host ('h1         = ' + [regex]::Matches($h, '<h1').Count)
Write-Host ('h2         = ' + [regex]::Matches($h, '<h2').Count)
Write-Host ('img        = ' + [regex]::Matches($h, '<img').Count)
Write-Host ('title      = ' + [regex]::Match($h, '<title>(.*?)</title>').Groups[1].Value)