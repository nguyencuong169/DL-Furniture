param(
    [string]$ProjectPath = "C:\MyProjects\DL-Furniture"
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$baseDir = Join-Path $ProjectPath "src\assets\img"
$successCount = 0
$failCount = 0

# Image URLs organized by category (curated from Unsplash)
$imageUrls = @{
    "spa" = @(
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1586023492125-27b46c1e1dc2?w=1920&h=1080&fit=crop"
    )
    "restaurant" = @(
        "https://images.unsplash.com/photo-1595521624273-5f0520344d47?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1517457373614-b7152f800fd1?w=1920&h=1080&fit=crop"
    )
    "pricing" = @(
        "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1586023492125-27b46c1e1dc2?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1578476326172-f545306dd798?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1606541895490-9e2901c485b8?w=1920&h=1080&fit=crop"
    )
    "team" = @(
        "https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1552664730-d307ca884978?w=1920&h=1080&fit=crop"
    )
    "news" = @(
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1578476326172-f545306dd798?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1606541895490-9e2901c485b8?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1517457373614-b7152f800fd1?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1595521624273-5f0520344d47?w=1920&h=1080&fit=crop"
    )
    "slider" = @(
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1586023492125-27b46c1e1dc2?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1578476326172-f545306dd798?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1606541895490-9e2901c485b8?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1517457373614-b7152f800fd1?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1595521624273-5f0520344d47?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1576228538604-0e75aa1d06a7?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1600210491742-f049cd451bba?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=1920&h=1080&fit=crop",
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1920&h=1080&fit=crop"
    )
}

function Download-Image {
    param(
        [string]$Url,
        [string]$SavePath,
        [int]$RetryCount = 3
    )
    
    $attempt = 0
    
    while ($attempt -lt $RetryCount) {
        try {
            $attempt++
            Write-Host "  [$attempt/$RetryCount] $(Split-Path $SavePath -Leaf)..." -ForegroundColor Gray -NoNewline
            
            Invoke-WebRequest -Uri $Url `
                -OutFile $SavePath `
                -TimeoutSec 30 `
                -ErrorAction Stop
            
            if (Test-Path $SavePath) {
                $size = (Get-Item $SavePath).Length / 1MB
                Write-Host " OK ($([Math]::Round($size, 2))MB)" -ForegroundColor Green
                return $true
            }
        }
        catch {
            if ($attempt -lt $RetryCount) {
                Write-Host " RETRY" -ForegroundColor Yellow -NoNewline
                Start-Sleep -Seconds 1
            }
        }
    }
    
    Write-Host " FAILED" -ForegroundColor Red
    return $false
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  Walnut Wood Furniture Image Downloader" -ForegroundColor Cyan
Write-Host "  Downloading high-quality 4K images" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

foreach ($category in $imageUrls.Keys) {
    $catDir = Join-Path $baseDir $category
    $urls = $imageUrls[$category]
    
    if (-not (Test-Path $catDir)) {
        Write-Host "ERROR: Directory not found: $catDir" -ForegroundColor Red
        continue
    }
    
    Write-Host "Downloading $category/" -ForegroundColor Yellow
    
    for ($i = 0; $i -lt $urls.Count; $i++) {
        $fileName = "$($i + 1).jpg"
        $savePath = Join-Path $catDir $fileName
        $url = $urls[$i]
        
        if (Download-Image -Url $url -SavePath $savePath) {
            $successCount++
        } else {
            $failCount++
        }
        
        # Polite delay to respect server
        Start-Sleep -Milliseconds 500
    }
    
    Write-Host ""
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Download Complete!" -ForegroundColor Cyan
Write-Host "Success: $successCount | Failed: $failCount" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Yellow" })
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

if ($failCount -gt 0) {
    Write-Host "Note: Some downloads may have failed due to network issues." -ForegroundColor Yellow
    Write-Host "You can manually download from:" -ForegroundColor Yellow
    Write-Host "  - Unsplash: https://unsplash.com/s/photos/walnut-wood-furniture" -ForegroundColor Gray
    Write-Host "  - Pexels: https://www.pexels.com/search/wooden%20furniture%204k/" -ForegroundColor Gray
    Write-Host "  - Pixabay: https://pixabay.com/search/walnut%20wood%20interior/" -ForegroundColor Gray
}
