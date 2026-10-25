$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$srcPath = Join-Path $root 'assets\icon.png'
$res = Join-Path $root 'android\app\src\main\res'
$cream = [System.Drawing.ColorTranslator]::FromHtml('#FEF8EF')

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$cropSide = [Math]::Min($src.Width, $src.Height)
$crop = New-Object System.Drawing.Rectangle ([int](($src.Width - $cropSide) / 2)), ([int](($src.Height - $cropSide) / 2)), $cropSide, $cropSide
$icon = New-Object System.Drawing.Bitmap $cropSide, $cropSide
$g = [System.Drawing.Graphics]::FromImage($icon)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.DrawImage($src, (New-Object System.Drawing.Rectangle 0, 0, $cropSide, $cropSide), $crop, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$src.Dispose()

function Save-Icon([int]$size, [string]$path, [bool]$round) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    if ($round) {
        $g.Clear([System.Drawing.Color]::Transparent)
        $clip = New-Object System.Drawing.Drawing2D.GraphicsPath
        $clip.AddEllipse(0, 0, $size, $size)
        $g.SetClip($clip)
    }
    $g.DrawImage($icon, 0, 0, $size, $size)
    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$mipmaps = @{ 'mdpi' = 48; 'hdpi' = 72; 'xhdpi' = 96; 'xxhdpi' = 144; 'xxxhdpi' = 192 }
foreach ($key in $mipmaps.Keys) {
    $size = $mipmaps[$key]
    Save-Icon $size (Join-Path $res "mipmap-$key\ic_launcher.png") $false
    Save-Icon $size (Join-Path $res "mipmap-$key\ic_launcher_round.png") $true
    Save-Icon ([int]($size * 9 / 4)) (Join-Path $res "mipmap-$key\ic_launcher_foreground.png") $false
}

foreach ($file in Get-ChildItem -Path $res -Recurse -Filter 'splash.png') {
    $probe = [System.Drawing.Image]::FromFile($file.FullName)
    $width = $probe.Width
    $height = $probe.Height
    $probe.Dispose()

    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($cream)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $draw = [int]([Math]::Min($width, $height) * 0.28)
    $g.DrawImage($icon, [int](($width - $draw) / 2), [int](($height - $draw) / 2), $draw, $draw)
    $g.Dispose()
    $bmp.Save($file.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$icon.Dispose()
Write-Host 'Android icons and splash screens regenerated.'
