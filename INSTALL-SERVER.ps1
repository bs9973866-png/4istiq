$ErrorActionPreference = "Stop"
$Version = "26.2"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root
Write-Host "4ISTIQ - Paper $Version installer" -ForegroundColor Cyan

$java = Get-Command java -ErrorAction SilentlyContinue
if (-not $java) { Write-Host "Java 25+ not found. Install it from https://adoptium.net/temurin/releases/" -ForegroundColor Red; Read-Host "Enter"; exit 1 }
$javaText = (& java -version 2>&1 | Out-String)
if ($javaText -notmatch '"(\d+)') { throw "Could not detect Java version: $javaText" }
$javaMajor = [int]$Matches[1]
if ($javaMajor -lt 25) { Write-Host "Paper 26.2 needs Java 25+. Detected Java $javaMajor." -ForegroundColor Red; Read-Host "Enter"; exit 1 }
Write-Host "Java $javaMajor detected." -ForegroundColor Green

$api = "https://api.papermc.io/v2/projects/paper/versions/$Version"
Write-Host "Checking Paper builds..."
$versionInfo = Invoke-RestMethod -Uri $api
$build = ($versionInfo.builds | Measure-Object -Maximum).Maximum
if (-not $build) { throw "No Paper builds found for $Version." }
$downloadName = "paper-$Version-$build.jar"
$serverJar = Join-Path $Root "paper.jar"
if (Test-Path $serverJar) {
  $answer = Read-Host "paper.jar exists. Replace it with build $build? (y/N)"
  if ($answer -match '^(y|yes)$') { Remove-Item $serverJar -Force }
}
if (-not (Test-Path $serverJar)) {
  Write-Host "Downloading $downloadName ..."
  Invoke-WebRequest -Uri "$api/builds/$build/downloads/$downloadName" -OutFile $serverJar
}
New-Item -ItemType Directory -Force -Path (Join-Path $Root "plugins") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Root "world") | Out-Null
$properties = @"
motd=4ISTIQ AI SMP
server-port=25565
online-mode=false
difficulty=normal
gamemode=survival
max-players=30
view-distance=8
simulation-distance=6
spawn-protection=0
pvp=false
"@
if (-not (Test-Path (Join-Path $Root "server.properties"))) { Set-Content (Join-Path $Root "server.properties") $properties -Encoding ASCII }
if (-not (Test-Path (Join-Path $Root "eula.txt"))) { Set-Content (Join-Path $Root "eula.txt") "eula=false" -Encoding ASCII }
Write-Host "Server files prepared." -ForegroundColor Green
Write-Host "Read eula.txt. If you agree to the Minecraft EULA, change eula=false to eula=true."
Write-Host "Then run START-SERVER.bat."
Read-Host "Press Enter to close"
