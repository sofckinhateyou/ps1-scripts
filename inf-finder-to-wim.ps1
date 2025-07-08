$mountDir = "D:\mount\win"
$driverRoot = "D:\iso\virtio-win-0.1.266"

# Получаем все .inf файлы рекурсивно
$infFiles = Get-ChildItem -Path $driverRoot -Recurse -Include *.inf

if ($infFiles.Count -eq 0) {
    Write-Host "INF-файлы не найдены." -ForegroundColor Red
    exit
}

Write-Host "Найдено INF-драйверов: $($infFiles.Count)" -ForegroundColor Yellow

foreach ($inf in $infFiles) {
    $driverPath = $inf.DirectoryName
    Write-Host "Добавляю драйвер: $driverPath" -ForegroundColor Green

    # Выполняем DISM
    $process = Start-Process dism.exe -ArgumentList "/Add-Driver /Image=`"$mountDir`" /Driver=`"$driverPath`"" -Wait -NoNewWindow -PassThru

    if ($process.ExitCode -ne 0) {
        Write-Host "Ошибка при добавлении драйвера: $driverPath (Код: $($process.ExitCode))" -ForegroundColor Red
    }
}

pause