@echo off
setlocal EnableDelayedExpansion

:inNum

rem 引数で桁数を指定
set /p num=桁数を入力してください:
echo %num%| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo 数値のみ入力してください。
    goto inNum
)

:inSel

rem 間に文字が含まれるか
set /p val=数字の後の節字があるか(0 or 1)

if "%val%"=="1" goto select
if "%val%"=="0" goto select

echo 1 or 0 を入力してください。

goto inSel

:select
if "%val%"=="1" (
    num+=1
    call :func1
) else (
    call :func2
)

pause
exit /b

rem =================================================

:func1
for %%F in (*_*.webp) do (
    set "name=%%~nF"
    set "newname=!name:~%num%!"
    ren "%%F" "!newname!.webp"
    echo Renamed "%%F" to "!newname!.webp"
)
exit /b

:func2
for %%F in (*.webp) do (
    set "name=%%~nF"
    set "newname=!name:~%num%!"
    ren "%%F" "!newname!.webp"
    echo Renamed "%%F" to "!newname!.webp"
)
exit /b