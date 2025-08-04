# Get-UserCreationDate
Windows Kullanıcı Hesabı Oluşturulma Tarihini Gösteren PowerShell Scripti
Aşağıdaki PowerShell scripti, bir Windows kullanıcı hesabının ne zaman oluşturulduğunu gösterir

<#
.SYNOPSIS
    Bir Windows kullanıcı hesabının oluşturulma tarihini gösterir.
.DESCRIPTION
    Bu script, belirtilen kullanıcı hesabının ne zaman oluşturulduğunu gösterir.
    Eğer kullanıcı adı belirtilmezse, tüm yerel kullanıcı hesaplarını ve oluşturulma tarihlerini listeler.
.PARAMETER UserName
    (Opsiyonel) Bilgilerini görüntülemek istediğiniz kullanıcı adı.
.EXAMPLE
    .\Get-UserCreationDate.ps1
    Tüm yerel kullanıcı hesaplarını ve oluşturulma tarihlerini listeler.
.EXAMPLE
    .\Get-UserCreationDate.ps1 -UserName "Ahmet"
    "Ahmet" kullanıcısının oluşturulma tarihini gösterir.
#>

param(
    [string]$UserName
)

function Get-UserCreationDate {
    param(
        [string]$Username
    )
    
    try {
        $user = Get-LocalUser -Name $Username -ErrorAction Stop
        $sid = $user.SID
        $userPath = "Registry::HKLM\SAM\SAM\Domains\Account\Users\$($sid.Value)"
        
        # Bu kısım sistem izinleri gerektirir, bu nedenle alternatif bir yöntem kullanıyoruz
        $wmiUser = Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.Name -eq $Username -and $_.LocalAccount -eq $true }
        
        if ($wmiUser) {
            $creationDate = $wmiUser.ConvertToDateTime($wmiUser.InstallDate)
            return $creationDate
        }
        else {
            # Alternatif yöntem (daha az kesin)
            $profilePath = "C:\Users\$Username"
            if (Test-Path $profilePath) {
                $creationDate = (Get-Item $profilePath).CreationTime
                return $creationDate
            }
            else {
                return "Kullanıcı profili bulunamadı, kesin oluşturulma tarihi belirlenemiyor."
            }
        }
    }
    catch {
        return "Hata: $_"
    }
}

# Ana script kısmı
if ($UserName) {
    $creationDate = Get-UserCreationDate -Username $UserName
    Write-Host "`nKullanıcı: $UserName" -ForegroundColor Cyan
    Write-Host "Oluşturulma Tarihi: $creationDate`n" -ForegroundColor Green
}
else {
    Write-Host "`nTüm Yerel Kullanıcılar ve Oluşturulma Tarihleri:`n" -ForegroundColor Yellow
    
    $allUsers = Get-LocalUser
    foreach ($user in $allUsers) {
        $creationDate = Get-UserCreationDate -Username $user.Name
        Write-Host "Kullanıcı: $($user.Name)" -ForegroundColor Cyan
        Write-Host "Oluşturulma Tarihi: $creationDate`n" -ForegroundColor Green
    }
}

## Notlar

1. Scriptin tam doğru sonuç verebilmesi için yönetici haklarıyla çalıştırılması gerekir.
2. Bazı sistemlerde SAM kayıt defteri anahtarlarına erişim kısıtlı olabilir, bu durumda script alternatif yöntemler kullanır.
3. Windows 10/11 ve Windows Server'ın modern sürümlerinde çalışır.

Daha kesin sonuçlar için Active Directory ortamlarında `Get-ADUser` cmdlet'i kullanılabilir, ancak bu script yerel hesaplar için tasarlanmıştır.





