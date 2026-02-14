@echo off
setlocal DisableDelayedExpansion

rem === カウント開始値 ===
set /a count=0

rem === 変更したファイルを処理 ===
for %%F in (*.webp) do (
    rem フレイム数の初期化
    set frame=0

    rem フレイム数をカウント
    for /f %%A in ('magick identify -format "%%n" "%%F" 2^>nul') do (
        set frame=%%A
    )

    call :isAnimation "%%F" !frame!
)

if !count! GTR 0 (
    echo File Convert Complete
) else (
    echo No Animated Found
)

pause

exit /b


rem ===================================================

rem アニメーション判定
:isAnimation

rem 変数設定
set "file=%~1"
set /a frame=%2


if %frame% GTR 1 (
    rem 拡張子を設定
    set "ext=.gif"
    set "output=%~n1!ext!"

    rem コンバート webp → gif
    echo Converting "%file%" to "%output%"
    magick "%file%" "%output%"

    rem カウントアップ
    set /a count+=1
) else (
    echo Skip (static): "%file%"
)

exit /b