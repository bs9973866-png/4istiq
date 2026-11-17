$ErrorActionPreference = "Stop"
$Version = "26.2"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root
Write-Host "4ISTIQ - Paper $Version installer" -ForegroundColor Cyan

$java = Get-Command java -ErrorAction SilentlyContinue
if (-not $java) { Write-Host "Java 25+ not found. Install it from https://adoptium.net/temurin/releases/" -ForegroundColor Red; Read-Host "Enter"; exit 1 }
# java -version writes to stderr; capture it through cmd.exe so PowerShell's
# $ErrorActionPreference = Stop does not turn the version banner into an error.
$javaText = (cmd.exe /d /c "java -version 2>&1" | Out-String)
if ($LASTEXITCODE -ne 0 -or $javaText -notmatch '"(\d+)') { throw "Could not detect Java version: $javaText" }
$javaMajor = [int]$Matches[1]
if ($javaMajor -lt 25) { Write-Host "Paper 26.2 needs Java 25+. Detected Java $javaMajor." -ForegroundColor Red; Read-Host "Enter"; exit 1 }
Write-Host "Java $javaMajor detected." -ForegroundColor Green

# PaperMC retired its old v2 API. Use the supported Fill v3 endpoint.
$headers = @{
  "User-Agent" = "4ISTIQ-Server-Installer/1.0 (https://github.com/bs9973866-png/4istiq)"
  "Accept" = "application/json"
}
$api = "https://fill.papermc.io/v3/projects/paper/versions/$Version/builds"
Write-Host "Checking stable Paper $Version builds..."
$builds = Invoke-RestMethod -Uri $api -Headers $headers -Method Get
if ($builds.ok -eq $false) { throw "Paper API error: $($builds.message)" }
$buildInfo = $builds | Where-Object { $_.channel -eq "STABLE" } | Select-Object -First 1
if (-not $buildInfo) { throw "No stable Paper builds found for Minecraft $Version." }
$download = $buildInfo.downloads.'server:default'
if (-not $download.url -or -not $download.name) { throw "Paper API did not return a server download URL." }

$downloadName = $download.name
$downloadUrl = $download.url
$expectedHash = $download.checksums.sha256
$serverJar = Join-Path $Root "paper.jar"
if (Test-Path $serverJar) {
  $answer = Read-Host "paper.jar exists. Replace it with build $($buildInfo.id)? (y/N)"
  if ($answer -match '^(y|yes)$') { Remove-Item $serverJar -Force }
}
if (-not (Test-Path $serverJar)) {
  Write-Host "Downloading $downloadName ..."
  Invoke-WebRequest -Uri $downloadUrl -Headers $headers -OutFile $serverJar
  if ($expectedHash) {
    $actualHash = (Get-FileHash -Path $serverJar -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $expectedHash.ToLowerInvariant()) {
      Remove-Item $serverJar -Force
      throw "SHA-256 verification failed. The downloaded file was removed; run the installer again."
    }
    Write-Host "Download checksum verified." -ForegroundColor Green
  }
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
Write-Host "Server files prepared (Paper build $($buildInfo.id))." -ForegroundColor Green
Write-Host "Read eula.txt. If you agree to the Minecraft EULA, change eula=false to eula=true."
Write-Host "Then run START-SERVER.bat."
Read-Host "Press Enter to close"
