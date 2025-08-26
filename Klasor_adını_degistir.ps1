
# PowerShell Script - Klasör adını değiştir
# "S_GOP_CL8 Ground Handling Supplier Audit Checklist for Ramp Handling" klasörünü yeniden adlandırır

# Ana dizini belirleyin (klasörün bulunduğu üst dizin)
$parentPath = "D:\fname\"



# Eski klasör adı
$oldFolderName = "fname"

# Yeni klasör adı - istediğiniz gibi değiştirebilirsiniz
$newFolderName = "fname"

# Klasörün tam yolları
$oldFolderPath = Join-Path $parentPath $oldFolderName
$newFolderPath = Join-Path $parentPath $newFolderName

# Eski klasörün var olup olmadığını kontrol et
if (Test-Path $oldFolderPath -PathType Container) {
    
    # Yeni klasör adıyla bir klasör zaten var mı kontrol et
    if (Test-Path $newFolderPath) {
        Write-Host "UYARI: '$newFolderName' adında bir klasör zaten mevcut!" -ForegroundColor Yellow
        Write-Host "Mevcut klasör yolu: $newFolderPath" -ForegroundColor Yellow
    } else {
        try {
            # Klasörü yeniden adlandır
            Rename-Item -Path $oldFolderPath -NewName $newFolderName
            Write-Host "✓ Klasör başarıyla yeniden adlandırıldı:" -ForegroundColor Green
            Write-Host "  Eski ad: $oldFolderName" -ForegroundColor Gray
            Write-Host "  Yeni ad: $newFolderName" -ForegroundColor Green
            Write-Host "  Yeni yol: $newFolderPath" -ForegroundColor Green
        }
        catch {
            Write-Host "HATA: Klasör yeniden adlandırılamadı!" -ForegroundColor Red
            Write-Host "Hata detayı: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Olası nedenler:" -ForegroundColor Yellow
            Write-Host "- Klasör şu anda kullanımda olabilir" -ForegroundColor Yellow
            Write-Host "- Yeterli yetkiniz olmayabilir" -ForegroundColor Yellow
            Write-Host "- Klasör içindeki dosyalar açık olabilir" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "HATA: Belirtilen klasör bulunamadı!" -ForegroundColor Red
    Write-Host "Aranan klasör: $oldFolderPath" -ForegroundColor Red
    Write-Host "" 
    Write-Host "Mevcut klasörleri kontrol edin:" -ForegroundColor Cyan
    
    # Ana dizindeki klasörleri listele
    if (Test-Path $parentPath) {
        Get-ChildItem -Path $parentPath -Directory | ForEach-Object {
            Write-Host "  📁 $($_.Name)" -ForegroundColor White
        }
    } else {
        Write-Host "Ana dizin de bulunamadı: $parentPath" -ForegroundColor Red
    }
}

Write-Host "`nİşlem tamamlandı!" -ForegroundColor Cyan
