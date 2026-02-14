# ================================
# WebP to GIF (Animated Only)
# ================================

# === カウント初期設定 ===
$script:count = 0

# === 変更するファイル ===
Get-ChildItem -Filter *.webp | ForEach-Object {
    # フレーム数取得
    $file = $_.FullName
    $frame = (magick identify "$file" 2>$null | Measure-Object).Count

    if ($frame -gt 1) {
        # 変換
        Write-Host "Converting $($_.Name)"
        $output = [System.IO.Path]::ChangeExtension($file, ".gif")
        magick "$file" -coalesce -layers optimize "$output"

        # ファイルの消去
        Remove-Item "$file"

        # カウントアップ
        $script:count++
    }
    else {
        Write-Host "Skip (static): $($_.Name)"
    }
}

if ($script:count -gt 0) {
    Write-Host "File Convert Complete"
}
else {
    Write-Host "No Animated Found"
}

Pause
