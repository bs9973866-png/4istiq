# AI agent runtime

Connects 19 separate player clients to your private Paper 26.2 server.

## Requirements
- Node.js 22+
- Paper 26.2 with AISMP plugin installed
- Ollama running locally with `qwen2.5:3b`

Keep the server private. Offline-mode usernames are not authenticated identities.

## Run on Windows
1. Start Paper and wait until it is ready.
2. Keep Ollama running at `http://127.0.0.1:11434`.
3. Double-click `start.bat`. First run installs dependencies.
4. The 19 clients connect one by one. When all are online, the plugin begins its 60-second countdown.

Manual PowerShell:
```powershell
npm install
$env:MC_HOST="127.0.0.1"
$env:MC_PORT="25565"
$env:MC_VERSION="26.2"
$env:OLLAMA_MODEL="qwen2.5:3b"
npm start
```

Each agent sends its own profile, memory, inventory and surroundings to Ollama. The model chooses a validated peaceful action: explore, gather wood, attempt a starter camp, visit another agent, talk, choose/return home, or rest. It cannot run arbitrary JavaScript, shell commands or server commands. When Ollama is unavailable, agents wait instead of pretending to think.

This is an early prototype. Large-scale city building, farms, trade and advanced diplomacy are not implemented yet. Live compatibility and in-game behavior need testing on your server.
