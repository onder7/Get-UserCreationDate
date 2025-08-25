Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Ana form oluştur
$form = New-Object System.Windows.Forms.Form
$form.Text = "Dosya İsmi Düzenleme Aracı"
$form.Size = New-Object System.Drawing.Size(900, 700)
$form.StartPosition = "CenterScreen"
$form.MinimumSize = New-Object System.Drawing.Size(800, 600)

# Klasör seçim grubu
$folderGroupBox = New-Object System.Windows.Forms.GroupBox
$folderGroupBox.Text = "Klasör Seçimi"
$folderGroupBox.Location = New-Object System.Drawing.Point(10, 10)
$folderGroupBox.Size = New-Object System.Drawing.Size(860, 60)

# Klasör yolu textbox
$folderTextBox = New-Object System.Windows.Forms.TextBox
$folderTextBox.Location = New-Object System.Drawing.Point(10, 25)
$folderTextBox.Size = New-Object System.Drawing.Size(580, 20)
$folderTextBox.ReadOnly = $true

# Klasör seç butonu
$selectFolderButton = New-Object System.Windows.Forms.Button
$selectFolderButton.Text = "Klasör Seç"
$selectFolderButton.Location = New-Object System.Drawing.Point(600, 23)
$selectFolderButton.Size = New-Object System.Drawing.Size(80, 25)

# Tek dosya seç butonu
$selectFileButton = New-Object System.Windows.Forms.Button
$selectFileButton.Text = "Tek Dosya"
$selectFileButton.Location = New-Object System.Drawing.Point(690, 23)
$selectFileButton.Size = New-Object System.Drawing.Size(80, 25)

# Çoklu dosya seç butonu
$selectMultipleButton = New-Object System.Windows.Forms.Button
$selectMultipleButton.Text = "Çoklu Seç"
$selectMultipleButton.Location = New-Object System.Drawing.Point(780, 23)
$selectMultipleButton.Size = New-Object System.Drawing.Size(70, 25)

# Dosya listesi
$fileListView = New-Object System.Windows.Forms.ListView
$fileListView.Location = New-Object System.Drawing.Point(10, 80)
$fileListView.Size = New-Object System.Drawing.Size(860, 300)
$fileListView.View = "Details"
$fileListView.FullRowSelect = $true
$fileListView.GridLines = $true
$fileListView.MultiSelect = $true

# ListView kolonları
$fileListView.Columns.Add("Mevcut İsim", 400) | Out-Null
$fileListView.Columns.Add("Yeni İsim", 300) | Out-Null
$fileListView.Columns.Add("Durum", 100) | Out-Null

# Yeniden adlandırma seçenekleri grubu
$renameGroupBox = New-Object System.Windows.Forms.GroupBox
$renameGroupBox.Text = "Yeniden Adlandırma Seçenekleri"
$renameGroupBox.Location = New-Object System.Drawing.Point(10, 390)
$renameGroupBox.Size = New-Object System.Drawing.Size(860, 180)

# Maksimum karakter sayısı
$maxLengthLabel = New-Object System.Windows.Forms.Label
$maxLengthLabel.Text = "Maksimum karakter sayısı:"
$maxLengthLabel.Location = New-Object System.Drawing.Point(10, 25)
$maxLengthLabel.Size = New-Object System.Drawing.Size(150, 20)

$maxLengthNumeric = New-Object System.Windows.Forms.NumericUpDown
$maxLengthNumeric.Location = New-Object System.Drawing.Point(170, 23)
$maxLengthNumeric.Size = New-Object System.Drawing.Size(80, 20)
$maxLengthNumeric.Minimum = 20
$maxLengthNumeric.Maximum = 255
$maxLengthNumeric.Value = 50

# Ön ek ekleme
$prefixCheckBox = New-Object System.Windows.Forms.CheckBox
$prefixCheckBox.Text = "Ön ek ekle:"
$prefixCheckBox.Location = New-Object System.Drawing.Point(10, 55)
$prefixCheckBox.Size = New-Object System.Drawing.Size(80, 20)

$prefixTextBox = New-Object System.Windows.Forms.TextBox
$prefixTextBox.Location = New-Object System.Drawing.Point(100, 53)
$prefixTextBox.Size = New-Object System.Drawing.Size(150, 20)
$prefixTextBox.Text = "S_GOP_CL10_"

# Gereksiz kelimeleri çıkar
$removeWordsCheckBox = New-Object System.Windows.Forms.CheckBox
$removeWordsCheckBox.Text = "Gereksiz kelimeleri çıkar"
$removeWordsCheckBox.Location = New-Object System.Drawing.Point(10, 85)
$removeWordsCheckBox.Size = New-Object System.Drawing.Size(200, 20)
$removeWordsCheckBox.Checked = $true

# Sıralı numaralandırma
$numberingCheckBox = New-Object System.Windows.Forms.CheckBox
$numberingCheckBox.Text = "Sıralı numaralandırma ekle"
$numberingCheckBox.Location = New-Object System.Drawing.Point(10, 115)
$numberingCheckBox.Size = New-Object System.Drawing.Size(180, 20)

# Butonlar
$previewButton = New-Object System.Windows.Forms.Button
$previewButton.Text = "Önizleme"
$previewButton.Location = New-Object System.Drawing.Point(600, 25)
$previewButton.Size = New-Object System.Drawing.Size(100, 30)

$renameButton = New-Object System.Windows.Forms.Button
$renameButton.Text = "Yeniden Adlandır"
$renameButton.Location = New-Object System.Drawing.Point(710, 25)
$renameButton.Size = New-Object System.Drawing.Size(120, 30)
$renameButton.BackColor = [System.Drawing.Color]::LightGreen

$resetButton = New-Object System.Windows.Forms.Button
$resetButton.Text = "Sıfırla"
$resetButton.Location = New-Object System.Drawing.Point(600, 65)
$resetButton.Size = New-Object System.Drawing.Size(100, 30)

$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Listeyi Temizle"
$clearButton.Location = New-Object System.Drawing.Point(710, 65)
$clearButton.Size = New-Object System.Drawing.Size(120, 30)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 580)
$progressBar.Size = New-Object System.Drawing.Size(860, 20)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 610)
$statusLabel.Size = New-Object System.Drawing.Size(860, 20)
$statusLabel.Text = "Hazır"

# Global değişken
$global:selectedFolder = ""

# Tek dosya seç fonksiyonu
$selectFileButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "Yeniden adlandırılacak dosyayı seçin"
    $openFileDialog.Filter = "Tüm Dosyalar (*.*)|*.*|PDF Dosyaları (*.pdf)|*.pdf|Word Dosyaları (*.doc;*.docx)|*.doc;*.docx|Excel Dosyaları (*.xls;*.xlsx)|*.xls;*.xlsx"
    $openFileDialog.FilterIndex = 1
    
    if ($openFileDialog.ShowDialog() -eq "OK") {
        $fileListView.Items.Clear()
        $global:selectedFolder = Split-Path $openFileDialog.FileName
        $folderTextBox.Text = $global:selectedFolder + " (Tek dosya seçildi)"
        
        # Seçilen dosyayı listeye ekle
        $file = Get-Item $openFileDialog.FileName
        $item = New-Object System.Windows.Forms.ListViewItem
        $item.Text = $file.Name
        $item.SubItems.Add("") # Yeni isim (boş)
        $item.SubItems.Add("Bekliyor") # Durum
        $item.Tag = $file.FullName
        $fileListView.Items.Add($item) | Out-Null
        
        $statusLabel.Text = "1 dosya seçildi: $($file.Name)"
    }
})

# Çoklu dosya seç fonksiyonu
$selectMultipleButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "Yeniden adlandırılacak dosyaları seçin"
    $openFileDialog.Filter = "Tüm Dosyalar (*.*)|*.*|PDF Dosyaları (*.pdf)|*.pdf|Word Dosyaları (*.doc;*.docx)|*.doc;*.docx|Excel Dosyaları (*.xls;*.xlsx)|*.xls;*.xlsx"
    $openFileDialog.FilterIndex = 1
    $openFileDialog.Multiselect = $true
    
    if ($openFileDialog.ShowDialog() -eq "OK") {
        $fileListView.Items.Clear()
        
        if ($openFileDialog.FileNames.Count -gt 0) {
            $global:selectedFolder = Split-Path $openFileDialog.FileNames[0]
            $folderTextBox.Text = $global:selectedFolder + " ($($openFileDialog.FileNames.Count) dosya seçildi)"
            
            foreach ($filePath in $openFileDialog.FileNames) {
                $file = Get-Item $filePath
                $item = New-Object System.Windows.Forms.ListViewItem
                $item.Text = $file.Name
                $item.SubItems.Add("") # Yeni isim (boş)
                $item.SubItems.Add("Bekliyor") # Durum
                $item.Tag = $file.FullName
                $fileListView.Items.Add($item) | Out-Null
            }
            
            $statusLabel.Text = "$($openFileDialog.FileNames.Count) dosya seçildi"
        }
    }
})
$selectFolderButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Düzenlenecek dosyaların bulunduğu klasörü seçin"
    
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $global:selectedFolder = $folderBrowser.SelectedPath
        $folderTextBox.Text = $global:selectedFolder
        
        # Dosyaları yükle
        LoadFiles
    }
})

# Dosyaları yükleme fonksiyonu
function LoadFiles {
    $fileListView.Items.Clear()
    
    if (-not $global:selectedFolder) { return }
    
    try {
        $files = Get-ChildItem -Path $global:selectedFolder -File
        $statusLabel.Text = "$($files.Count) dosya bulundu"
        
        foreach ($file in $files) {
            $item = New-Object System.Windows.Forms.ListViewItem
            $item.Text = $file.Name
            $item.SubItems.Add("") # Yeni isim (boş)
            $item.SubItems.Add("Bekliyor") # Durum
            $item.Tag = $file.FullName
            $fileListView.Items.Add($item) | Out-Null
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Dosyalar yüklenirken hata: $($_.Exception.Message)", "Hata", "OK", "Error")
    }
}

# Yeni isim oluşturma fonksiyonu
function GenerateNewName($originalName, $index = 0) {
    $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($originalName)
    $extension = [System.IO.Path]::GetExtension($originalName)
    
    $newName = $nameWithoutExt
    
    # Gereksiz kelimeleri çıkar
    if ($removeWordsCheckBox.Checked) {
        $wordsToRemove = @("Ground Handling Audit Checklist For Passenger Handling Service", 
                          "Pax Services Audit Checklist", 
                          "Supplier Audit Checklist_Passenger Handling Service",
                          "Rev ", "Revision ")
        
        foreach ($word in $wordsToRemove) {
            $newName = $newName -replace [regex]::Escape($word), ""
        }
        
        # Fazla boşlukları temizle
        $newName = $newName -replace '\s+', '_'
        $newName = $newName.Trim('_')
    }
    
    # Ön ek ekle
    if ($prefixCheckBox.Checked -and $prefixTextBox.Text) {
        $newName = $prefixTextBox.Text + $newName
    }
    
    # Sıralı numaralandırma
    if ($numberingCheckBox.Checked) {
        $newName = $newName + "_" + ($index + 1).ToString("00")
    }
    
    # Maksimum uzunluk kontrolü
    $maxLength = $maxLengthNumeric.Value - $extension.Length
    if ($newName.Length -gt $maxLength) {
        $newName = $newName.Substring(0, $maxLength)
    }
    
    return $newName + $extension
}

# Önizleme fonksiyonu
$previewButton.Add_Click({
    if ($fileListView.Items.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Önce dosyaları yükleyin!", "Uyarı", "OK", "Warning")
        return
    }
    
    for ($i = 0; $i -lt $fileListView.Items.Count; $i++) {
        $item = $fileListView.Items[$i]
        $originalName = $item.Text
        $newName = GenerateNewName $originalName $i
        
        $item.SubItems[1].Text = $newName
        $item.SubItems[2].Text = "Önizleme"
        $item.BackColor = [System.Drawing.Color]::LightYellow
    }
    
    $statusLabel.Text = "Önizleme tamamlandı. Değişiklikleri onaylamak için 'Yeniden Adlandır' butonuna basın."
})

# Yeniden adlandırma fonksiyonu
$renameButton.Add_Click({
    if ($fileListView.Items.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Önce dosyaları yükleyin!", "Uyarı", "OK", "Warning")
        return
    }
    
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Dosyaları yeniden adlandırmak istediğinizden emin misiniz?`nBu işlem geri alınamaz!", 
        "Onay", 
        "YesNo", 
        "Question"
    )
    
    if ($result -eq "No") { return }
    
    $progressBar.Maximum = $fileListView.Items.Count
    $progressBar.Value = 0
    $successCount = 0
    $errorCount = 0
    
    for ($i = 0; $i -lt $fileListView.Items.Count; $i++) {
        $item = $fileListView.Items[$i]
        $originalPath = $item.Tag
        $newName = $item.SubItems[1].Text
        
        if (-not $newName) {
            $newName = GenerateNewName $item.Text $i
            $item.SubItems[1].Text = $newName
        }
        
        try {
            $newPath = Join-Path (Split-Path $originalPath) $newName
            
            if (Test-Path $newPath) {
                $item.SubItems[2].Text = "Var olan dosya"
                $item.BackColor = [System.Drawing.Color]::Orange
                $errorCount++
            }
            else {
                Rename-Item -Path $originalPath -NewName $newName -ErrorAction Stop
                $item.SubItems[2].Text = "Başarılı"
                $item.BackColor = [System.Drawing.Color]::LightGreen
                $successCount++
            }
        }
        catch {
            $item.SubItems[2].Text = "Hata: $($_.Exception.Message)"
            $item.BackColor = [System.Drawing.Color]::LightCoral
            $errorCount++
        }
        
        $progressBar.Value = $i + 1
        $form.Refresh()
    }
    
    $statusLabel.Text = "Tamamlandı! Başarılı: $successCount, Hatalı: $errorCount"
    [System.Windows.Forms.MessageBox]::Show(
        "İşlem tamamlandı!`nBaşarılı: $successCount`nHatalı: $errorCount", 
        "Sonuç", 
        "OK", 
        "Information"
    )
})

# Sıfırlama fonksiyonu
$resetButton.Add_Click({
    for ($i = 0; $i -lt $fileListView.Items.Count; $i++) {
        $item = $fileListView.Items[$i]
        $item.SubItems[1].Text = ""
        $item.SubItems[2].Text = "Bekliyor"
        $item.BackColor = [System.Drawing.Color]::White
    }
    $progressBar.Value = 0
    $statusLabel.Text = "Liste sıfırlandı"
})

# Liste temizleme fonksiyonu
$clearButton.Add_Click({
    $fileListView.Items.Clear()
    $progressBar.Value = 0
    $statusLabel.Text = "Liste temizlendi"
})

# Kontrolleri form'a ekle
$folderGroupBox.Controls.AddRange(@($folderTextBox, $selectFolderButton, $selectFileButton, $selectMultipleButton))
$renameGroupBox.Controls.AddRange(@(
    $maxLengthLabel, $maxLengthNumeric,
    $prefixCheckBox, $prefixTextBox,
    $removeWordsCheckBox, $numberingCheckBox,
    $previewButton, $renameButton, $resetButton, $clearButton
))

$form.Controls.AddRange(@(
    $folderGroupBox, $fileListView, $renameGroupBox, 
    $progressBar, $statusLabel
))

# Form'u göster
$form.ShowDialog() | Out-Null
