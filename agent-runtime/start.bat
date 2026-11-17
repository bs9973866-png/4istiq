@echo off
chcp 65001 >nul
title AI SMP - single agent test
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js 22 or newer is required.
  pause
  exit /b 1
)
if not exist node_modules (
  echo Installing AI agent dependencies...
  call npm install
  if errorlevel 1 (
    echo Dependency installation failed.
    pause
    exit /b 1
  )
)
set MC_HOST=127.0.0.1
set MC_PORT=25565
set MC_VERSION=26.2
set AI_BOT=AI_Vega
echo Starting selected agent: %AI_BOT%
echo To run all agents later, change AI_BOT=ALL in start.bat.
call npm start
pause
