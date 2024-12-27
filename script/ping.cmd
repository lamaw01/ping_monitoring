@REM set "_ip=124.232.23.2"
@REM ping %_ip% -n 1 | find /i "TTL=">nul
@REM if errorlevel 1 (
@REM     echo ping %_ip% failure
@REM ) else ( 
@REM     echo ping %_ip% success
@REM )


@REM @setlocal enableextensions enabledelayedexpansion
@REM @echo off
@REM set ipaddr=%1
@REM :loop
@REM set state=down
@REM for /f "tokens=5,6,7" %%a in ('ping -n 1 !ipaddr!') do (
@REM     if "x%%b"=="xunreachable." goto :endloop
@REM     if "x%%a"=="xReceived" if "x%%c"=="x1,"  set state=up
@REM )
@REM :endloop
@REM echo.Link is !state!
@REM ping -n 1 8.8.8.8 >nul: 2>nul:
@REM goto :loop
@REM endlocal

@echo off
cls
set ip=%1
ping -n 1 -4 %ip% | find "TTL"
if not errorlevel 1 set error=win
if errorlevel 1 set error=fail
cls
echo Result: %error%