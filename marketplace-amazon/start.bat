@echo off
echo ========================================
echo  MarketZone - Iniciando Servidor PHP
echo ========================================
echo.

REM Usar el PHP incluido en el proyecto con su php.ini configurado
"..\php\php.exe" -c "..\php\php.ini" -S localhost:8080 -t .

echo.
pause

