param(
    [string]$ProjectPath = "C:\MyProjects\DL-Furniture"
)

$baseDir = Join-Path $ProjectPath "src\assets\img"
$successCount = 0
$failCount = 0

# Alternative URLs for failed images from Pexels API
$failedImages = @{
    "spa" = @(
        @{
            "file" = 3
            "urls" = @(
                "https://images.pexels.com/photos/1350789/pexels-photo-1350789.jpeg?w=1920&h=1080&fit=crop",
                "https://images.pexels.com/photos/1165795/pexels-photo-1165795.jpeg?w=1920&h=1080&fit=crop"
            )
        }
    )
    "pricing" = @(
        @{
            "file" = 2
            "urls" = @(
                "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?w=1920&h=1080&fit=crop",
                "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?w=1920&h=1080&fit=crop"
            )
        }
        @{
            "file" = 3
            "urls" = @(
                "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?w=1920&h=1080&fit=crop",
                "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?w=1920&h=1080&fit=crop"
            )
        }
        @{
            "file" = 4
            "urls" = @(
                "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?w=1920&h=1080&fit=crop",
                "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?w=1920&h=1080&fit=crop"
            )
        }
    )
    "restaurant" = @(
        @{
            "file" = 1
            "urls" = @(
                "https://images.pexels.com/photos/958546/pexels-photo-958546.jpeg?w=1920&h=1080&fit=crop",
                "https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?w=1920&h=1080&fit=crop"
            )
        }
        @{
            "file" = 3
            "urls" = @(
                "https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?w=1920&h=1080&fit=crop",
                "https://images.pexels.com/photos/958546/pexels-photo-958546.jpeg?w=1920&h=1080&fit=crop"
            )
        }
    )
}

function Download-Image {
    param(
        [string[]]$Urls,
        [string]$SavePath,
        [int]$RetryCount = 3
    )
    
    foreach ($url in $Urls) {
        $attempt = 0
        while ($attempt -lt $RetryCount) {
            try {
                $attempt++
                Invoke-WebRequest -Uri $url `
                    -OutFile $SavePath `
                    -TimeoutSec 30 `
                    -ErrorAction Stop
                
                if (Test-Path $SavePath) {
                    $size = (Get-Item $SavePath).Length / 1MB
                    Write-Host "  OK ($([Math]::Round($size, 2))MB)" -ForegroundColor Green
                    return $true
                }
            }
            catch {
                if ($attempt -lt $RetryCount) {
                    Start-Sleep -Seconds 1
                }
            }
        }
    }
    
    Write-Host "  FAILED" -ForegroundColor Red
    return $false
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host "  Retrying Failed Images..." -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

foreach ($category in $failedImages.Keys) {
    $catDir = Join-Path $baseDir $category
    
    if (-not (Test-Path $catDir)) {
        Write-Host "ERROR: Directory not found: $catDir" -ForegroundColor Red
        continue
    }
    
    Write-Host "Retrying $category/" -ForegroundColor Yellow
    
    foreach ($item in $failedImages[$category]) {
        $fileName = "$($item.file).jpg"
        $savePath = Join-Path $catDir $fileName
        
        Write-Host "  [$($item.file)] $fileName..." -ForegroundColor Gray -NoNewline
        
        if (Download-Image -Urls $item.urls -SavePath $savePath) {
            $successCount++
        } else {
            $failCount++
        }
        
        Start-Sleep -Milliseconds 500
    }
    
    Write-Host ""
}

Write-Host "=================================================" -ForegroundColor Yellow
Write-Host "Retry Complete!" -ForegroundColor Yellow
Write-Host "Success: $successCount | Failed: $failCount" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Yellow" })
Write-Host "=================================================" -ForegroundColor Yellow
