# OCR review images using Windows.Media.Ocr (no install needed)
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Runtime.WindowsRuntime | Out-Null

# Map generic WinRT IAsyncOperation<T> to .NET Task and await it
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() |
    Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]

function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait() | Out-Null
    return $netTask.Result
}

# Load WinRT types
$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
$null = [Windows.Graphics.Imaging.BitmapDecoder, Windows.Graphics.Imaging, ContentType = WindowsRuntime]
$null = [Windows.Media.Ocr.OcrEngine, Windows.Media.Ocr, ContentType = WindowsRuntime]

$engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
if ($null -eq $engine) {
    Write-Output "NO_ENGINE"
    exit 1
}

$dir = 'C:\MyProjects\DL-Furniture\src\assets\img\for_review'
$files = [System.IO.Directory]::GetFiles($dir, '*.jpg')

foreach ($path in $files) {
    Write-Output "===== FILE: $path ====="
    try {
        $file = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync($path)) ([Windows.Storage.StorageFile])
        $stream = Await ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
        $decoder = Await ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
        $bitmap = Await ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
        $result = Await ($engine.RecognizeAsync($bitmap)) ([Windows.Media.Ocr.OcrResult])
        Write-Output "--- OCR TEXT ---"
        Write-Output $result.Text
        Write-Output "--- LINES ($($result.Lines.Count)) ---"
        foreach ($line in $result.Lines) {
            Write-Output $line.Text
        }
    } catch {
        Write-Output ("OCR_ERROR: " + $_.Exception.Message)
    }
    Write-Output ""
}