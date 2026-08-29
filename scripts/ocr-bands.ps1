param(
  [string]$Source = 'C:\MyProjects\DL-Furniture\.continue\process-full.png',
  [int]$BandHeight = 1200
)
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Runtime.WindowsRuntime | Out-Null

$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() |
  Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]

function Await($WinRtTask, $ResultType) {
  $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
  $netTask = $asTask.Invoke($null, @($WinRtTask))
  $netTask.Wait() | Out-Null
  return $netTask.Result
}

$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
$null = [Windows.Graphics.Imaging.BitmapDecoder, Windows.Graphics.Imaging, ContentType = WindowsRuntime]
$null = [Windows.Media.Ocr.OcrEngine, Windows.Media.Ocr, ContentType = WindowsRuntime]

$engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
if ($null -eq $engine) { Write-Output 'NO_ENGINE'; exit 1 }

$img = [System.Drawing.Image]::FromFile($Source)
$bandDir = 'C:\MyProjects\DL-Furniture\.continue\bands'
if (-not (Test-Path $bandDir)) { New-Item -ItemType Directory -Path $bandDir | Out-Null }

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 90L)

try {
  for ($y = 0; $y -lt $img.Height; $y += $BandHeight) {
    $h = [Math]::Min($BandHeight, $img.Height - $y)
    $rect = New-Object System.Drawing.Rectangle(0, $y, $img.Width, $h)
    $band = (New-Object System.Drawing.Bitmap($img.Width, $h))
    $g = [System.Drawing.Graphics]::FromImage($band)
    $g.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $img.Width, $h)), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $bandPath = Join-Path $bandDir ('band_' + $y + '.jpg')
    $band.Save($bandPath, $codec, $encParams)
    $band.Dispose()

    $file = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync($bandPath)) ([Windows.Storage.StorageFile])
    $stream = Await ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = Await ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $bitmap = Await ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $result = Await ($engine.RecognizeAsync($bitmap)) ([Windows.Media.Ocr.OcrResult])
    Write-Output ('BAND y=' + $y + ' : ' + $result.Text)
  }
} finally {
  $img.Dispose()
}
