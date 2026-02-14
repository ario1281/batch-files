# ================================
# Rename FIle Tool
# ================================

# ===  リネーム部分  ===
$prefix = Read-Host "リネーム後ファイル名を入力してください"
$DIGIT = 4

# === 　拡張子部分　 ===
$ext_b = Read-Host "変換前の拡張子を入力してください（必須）"
$ext_a = Read-Host "変換後の拡張子を入力してください（任意）"
$TMP_EXT = "tmp"

# === カウント開始値 ===
$script:count = 1

if ([string]::IsNullOrWhiteSpace($ext_b)) {
    Write-Host "変換前の拡張子が未入力です"
    Pause
    exit
}

# === 一時拡張子へ変更 ===
Get-ChildItem -File -Filter "*.$ext_b" | ForEach-Object {
    $newName = "$($_.BaseName).$TMP_EXT"
    Rename-Item $_.FullName $newName
}

# === tmpファイルを処理 ===
$files = Get-ChildItem -File -Filter "*.$TMP_EXT"
if ($files.Count -eq 0) {
    Write-Host "Empty File"
    Pause
    exit
}

foreach ($file in $files) {
    # 拡張子決定
    if ([string]::IsNullOrWhiteSpace($ext_a)) {
        $ext = ".$ext_b"
    }
    else {
        $ext = ".$ext_a"
    }

    # ゼロ埋め
    $num = $count.ToString("D$DIGIT")

    # 出力名決定
    if ([string]::IsNullOrWhiteSpace($prefix)) {
        $output = "$($file.BaseName)$ext"
    }
    else {
        $output = "$prefix$num$ext"
    }

    Write-Host "Renaming '$($file.Name)' to '$output'"
    Rename-Item $file.FullName $output

    # カウントアップ
    $script:count++
}

Write-Host "Extension Change Complete"

Pause
