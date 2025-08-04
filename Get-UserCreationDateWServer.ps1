<#
.SYNOPSIS
    Bir Windows kullanıcı hesabının oluşturulma tarihini gösterir.
.DESCRIPTION
    Bu script, belirtilen kullanıcı hesabının ne zaman oluşturulduğunu gösterir.
    Kullanıcı profil klasörünün oluşturulma tarihini kullanır.
.PARAMETER UserName
    Bilgilerini görüntülemek istediğiniz kullanıcı adı.
.EXAMPLE
    .\Get-UserCreationDate.ps1 -UserName "Ahmet"
    "Ahmet" kullanıcısının oluşturulma tarihini gösterir.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserName
)

try {
    # Kullanıcının var olup olmadığını kontrol et
    $user = Get-LocalUser -Name $UserName -ErrorAction Stop
    
    # Profil yolunu oluştur
    $profilePath = Join-Path -Path $env:SystemDrive -ChildPath "Users\$UserName"
    
    if (Test-Path $profilePath) {
        $creationDate = (Get-Item $profilePath).CreationTime
        Write-Host "`nKullanıcı: $UserName" -ForegroundColor Cyan
        Write-Host "Profil Oluşturulma Tarihi: $creationDate`n" -ForegroundColor Green
    }
    else {
        # Profil yoksa, SAM veritabanındaki bilgileri kullan (daha karmaşık ve yönetici izni gerektirir)
        $sid = $user.SID
        $userRegPath = "HKLM:\SAM\SAM\Domains\Account\Users\$($sid.Value)"
        
        if (Test-Path $userRegPath) {
            $binaryData = (Get-ItemProperty -Path $userRegPath -Name "F").F
            # Burada binary veriyi tarihe çevirmek gerekir (karmaşık)
            Write-Host "`nKullanıcı: $UserName" -ForegroundColor Cyan
            Write-Host "Uyarı: Kesin oluşturulma tarihi belirlenemedi. Profil klasörü bulunamadı.`n" -ForegroundColor Yellow
        }
        else {
            Write-Host "`nKullanıcı: $UserName" -ForegroundColor Cyan
            Write-Host "Hata: Kullanıcı bilgilerine erişilemedi. Yönetici olarak çalıştırdığınızdan emin olun.`n" -ForegroundColor Red
        }
    }
}
catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    Write-Host "`nHata: '$UserName' kullanıcısı bulunamadı.`n" -ForegroundColor Red
}
catch {
    Write-Host "`nHata: $($_.Exception.Message)`n" -ForegroundColor Red
}
