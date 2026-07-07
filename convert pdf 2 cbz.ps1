# ===== 設定 =====
$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pdfFiles = Get-ChildItem $baseDir -Filter *.pdf

if ($pdfFiles.Count -eq 0) {
    Write-Host "PDFが見つかりません"
    exit
}

foreach ($pdf in $pdfFiles) {

    $name = [System.IO.Path]::GetFileNameWithoutExtension($pdf.Name)
    $workDir = Join-Path $baseDir $name

    # 作業フォルダ作成
    New-Item -ItemType Directory -Path $workDir -Force | Out-Null

    Write-Host "変換中: $($pdf.Name)" -ForegroundColor Yellow

    # ===== PDF → 画像 =====
    $outputPattern = Join-Path $workDir "page_%03d.png"

    & gswin64c `
        -dNOPAUSE `
        -dBATCH `
        -sDEVICE=png16m `
        -r200 `
        "-sOutputFile=$outputPattern" `
        $pdf.FullName

    # ===== ZIP化 =====
    $zipPath = Join-Path $baseDir ($name + ".zip")
    Compress-Archive -Path (Join-Path $workDir "*") -DestinationPath $zipPath -Force

    # ===== CBZへリネーム =====
    $cbzPath = Join-Path $baseDir ($name + ".cbz")
    Rename-Item $zipPath $cbzPath -Force

    # ===== 成功チェック =====
    if (Test-Path $cbzPath) {

        # 作業フォルダ削除
        Remove-Item $workDir -Recurse -Force

        # ★ PDF削除（ここが追加部分）
        Remove-Item $pdf.FullName -Force

        Write-Host "完了 & PDF削除: $cbzPath" -ForegroundColor Green
    }
    else {
        Write-Host "エラー: CBZ作成失敗のためPDFは削除しません" -ForegroundColor Red
    }
}

Write-Host "すべて完了"