$mountDir = X
$driverRoot = X

# ��������, ���������� �� ������������� ����������
if (-not (Test-Path $mountDir)) {
    Write-Error "����� �� ����������� ��� ������ �������� ����: $mountDir"
    exit
}

# ����� ���� .inf ������ �� ������� ����
Get-ChildItem -Path $driverRoot -Recurse -Filter "*.inf" | 
    Where-Object { $_.FullName -match [regex]::Escape("\2k19\amd64\") } |
    ForEach-Object {
        $infPath = $_.FullName
        Write-Host "�������� �������: $infPath"
        dism /Image:"$mountDir" /Add-Driver /Driver:"$infPath" /ForceUnsigned
    }