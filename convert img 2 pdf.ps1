# ===== 基本設定 =====
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$folderName = Split-Path $baseDir -Leaf
$outputPdf = Join-Path $baseDir ($folderName + ".pdf")

Write-Host "=== 処理開始 ===" -ForegroundColor Cyan
Write-Host "作業フォルダ: $baseDir"
Write-Host "出力PDF: $outputPdf"
Write-Host ""

# ===== 対象ファイル取得 =====
Write-Host "画像ファイルを検索中..." -ForegroundColor Yellow

$files = Get-ChildItem $baseDir -File | Where-Object {
    $_.Extension -match "\.(webp|jpg|jpeg|png)$"
} | Sort-Object Name

if ($files.Count -eq 0) {
    Write-Error "画像ファイルが見つかりません"
    exit
}

Write-Host "検出ファイル数: $($files.Count)"
Write-Host ""

# ===== ファイル一覧表示（任意）=====
$i = 0
foreach ($file in $files) {
    $i++
    Write-Progress -Activity "ファイル確認中" `
        -Status "$i / $($files.Count): $($file.Name)" `
        -PercentComplete (($i / $files.Count) * 100)
}
Write-Progress -Activity "ファイル確認中" -Completed

Write-Host "ファイル確認完了" -ForegroundColor Green
Write-Host ""

# ===== PDF変換開始 =====
Write-Host "PDF変換開始..." -ForegroundColor Yellow

$startTime = Get-Date

magick $files.FullName `
    -auto-orient `
    -resize 2000x2000\> `
    -quality 75 `
    -sampling-factor 4:2:0 `
    -strip `
    $outputPdf

$endTime = Get-Date
$duration = $endTime - $startTime

# ===== 結果表示 =====
if (Test-Path $outputPdf) {
    Write-Host ""
    Write-Host "=== 完了 ===" -ForegroundColor Green
    Write-Host "出力ファイル: $outputPdf"
    Write-Host ("処理時間: {0:N2} 秒" -f $duration.TotalSeconds)
} else {
    Write-Error "PDFの作成に失敗しました"
}