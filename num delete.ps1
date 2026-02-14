# ================================
# Number Delete FileName Tool
# ================================

# --- 桁数入力 ---
while ($true) {
    $num = Read-Host "桁数を入力してください"

    if ($num -match '^\d+$') {
        $num = [int]$num
        break
    }
    else {
        Write-Host "数値のみ入力してください。"
    }
}

# --- 節字有無 ---
while ($true) {
    $val = Read-Host "数字の後の節字があるか (0 or 1)"

    if ($val -eq "0" -or $val -eq "1") {
        break
    }
    else {
        Write-Host "1 or 0 を入力してください。"
    }
}

# 1 の場合は +1
if ($val -eq "1") {
    $num++
    $files = Get-ChildItem -Filter "*_*.webp"
}
else {
    $files = Get-ChildItem -Filter "*.webp"
}

# --- リネーム処理 ---
foreach ($file in $files) {

    $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

    if ($name.Length -gt $num) {

        $newname = $name.Substring($num)
        $newfile = "$newname.webp"

        Rename-Item $file.FullName $newfile
        Write-Host "Renamed $($file.Name) to $newfile"
    }
    else {
        Write-Host "Skip (桁数不足): $($file.Name)"
    }
}

Write-Host "処理完了"
Pause
