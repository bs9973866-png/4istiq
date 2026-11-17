@echo off
chcp 65001 >nul
title 4ISTIQ - Build AI SMP plugin
where mvn >nul 2>nul
if errorlevel 1 (
  echo Maven is not installed. Download the built JAR from:
  echo https://github.com/bs9973866-png/4istiq/actions
  pause
  exit /b 1
)
java -version
mvn --batch-mode clean package
if errorlevel 1 (
  echo BUILD FAILED. Copy the complete error log when asking for help.
  pause
  exit /b 1
)
if not exist "target\ai-smp-1.0.0.jar" (
  echo Build finished but the plugin JAR was not found.
  pause
  exit /b 1
)
if not exist "plugins" mkdir plugins
copy /Y "target\ai-smp-1.0.0.jar" "plugins\ai-smp-1.0.0.jar"
echo SUCCESS: plugin copied to plugins folder.
pause
