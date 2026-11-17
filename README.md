# 4ISTIQ — Paper 26.2 server

Clean Windows server setup for the AI SMP project.

## Requirements
- Windows 10/11
- Java 25 or newer
- Internet connection for first installation

## Install
1. Download this repository as ZIP and extract it, or clone it with Git.
2. Double-click INSTALL-SERVER.bat.
3. Wait for the installer to download the latest available Paper 26.2 build.
4. Read the Minecraft EULA in eula.txt. If you agree, change eula=false to eula=true.
5. Double-click START-SERVER.bat.

The installer creates plugins/, world/, server.properties and eula.txt. The server JAR and generated worlds are intentionally not stored in Git.

## AI SMP
The plugins folder is prepared for the AI SMP plugin. The plugin JAR will be added after the server baseline is verified. Ollama runs separately on the same PC; its default local API is http://127.0.0.1:11434.

## Security
This starter configuration uses online-mode=false for the offline test setup. Offline mode does not authenticate player identities. Keep the server private and do not expose it to the public internet. pvp=false is set by default.

## Memory
The start script allocates up to 4 GB to Paper, leaving memory for Windows and Ollama. Adjust -Xmx4G only if enough RAM is available.
