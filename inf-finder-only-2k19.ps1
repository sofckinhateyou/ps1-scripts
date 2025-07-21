$mountWim = "D:\iso\MSWIN\windowsServer_2019\17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_ru-ru\sources\boot.wim"
$mountDir = "D:\mount"
dism /Mount-Wim /WimFile:"$mountWim" /Index:1 /MountDir:"$mountDir"

$mountDir = "D:\mount"
$driverRoot = "D:\iso\virtio-win-0.1.266"

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

dism /Unmount-Image /MountDir:"$mountDir" /Commit

# .\oscdimg -l"Custom_Server_2019_4" -t -u1 -b"D:\iso\MSWIN\windowsServer_2019\17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_ru-ru\boot\etfsboot.com" "D:\iso\MSWIN\windowsServer_2019\17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_ru-ru" "D:\iso\Custom_Server_maxedit_2019.iso"