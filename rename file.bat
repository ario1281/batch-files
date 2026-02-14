@echo off
setlocal enabledelayedexpansion

rem ===  リネーム部分  ===
set /p prefix=リネーム後ファイル名を入力してください : 
set /a DIGIT=4

rem ===　 拡張子部分 　===
set /p ext_b=変換前の拡張子を入力してください（必須）: 
set /p ext_a=変換後の拡張子を入力してください（任意）: 
set TMP_EXT=tmp

rem === カウント開始値 ===
set /a count=1

if "%ext_b%"=="" (
    echo 変換前の拡張子が未入力です
    pause
    exit /b
)

rem === 一時拡張子へ変更 ===
for %%F in (*.%ext_b%) do (
    ren "%%F" "%%~nF.%TMP_EXT%"
)

rem === 現在のディレクトリ内の全ファイルを処理 ===
for %%F in (*.%TMP_EXT%) do (
    rem 拡張子を設定
    if "%ext_a%"=="" (
        set "ext=.%ext_b%"
    ) else (
        set "ext=.%ext_a%"
    )

    rem 数字をゼロ埋め
    set "num=0000!count!"
    set "num=!num:~-%DIGIT%!"

    rem ファイル名を設定
    if "!prefix!"=="" (
        rem 元のファイル名＋拡張子
        set "output=%%~nF!ext!"
    ) else (
        rem リネーム名＋連番＋拡張子
        set "output=!prefix!!num!!ext!"
    )

    echo Renaming "%%F" to "!output!"
    ren "%%F" "!output!"

    rem カウントアップ
    set /a count+=1
)

if !count! GTR 0 (
    echo Extention Change Complete
) else (
    echo Empty File
)

pause