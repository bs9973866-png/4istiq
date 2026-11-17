@echo off
cd /d "%~dp0"
title 4ISTIQ Paper 26.2 Server
if not exist "paper.jar" (echo paper.jar not found. Run INSTALL-SERVER.bat first.& pause & exit /b 1)
findstr /i /c:"eula=true" eula.txt >nul 2>nul
if errorlevel 1 (echo Read and accept the Minecraft EULA first. Edit eula.txt only if you agree.& pause & exit /b 1)
java -Xms2G -Xmx4G -jar paper.jar --nogui
echo Server stopped.
pause
