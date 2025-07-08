$mountDir = X
$driverRoot = X

# Проверка, существует ли монтированная директория
if (-not (Test-Path $mountDir)) {
    Write-Error "Образ не смонтирован или указан неверный путь: $mountDir"
    exit
}

# Поиск всех .inf файлов по шаблону пути
Get-ChildItem -Path $driverRoot -Recurse -Filter "*.inf" | 
    Where-Object { $_.FullName -match [regex]::Escape("\2k19\amd64\") } |
    ForEach-Object {
        $infPath = $_.FullName
        Write-Host "Добавляю драйвер: $infPath"
        dism /Image:"$mountDir" /Add-Driver /Driver:"$infPath" /ForceUnsigned
    }