@echo off
:: Set the target IPv4 address
set "target=12.23.124.6"

:: Ping the target and check the result
ping -n 1 %target% >nul
if %errorlevel%==0 (
    echo win
) else (
    echo fail
)
