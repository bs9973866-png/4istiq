# 4ISTIQ — AI SMP 26.2

Windows server setup and autonomous-agent simulation prototype.

## Requirements
- Windows 10/11
- Java 25+
- Node.js 22+ for AI clients
- Ollama with `qwen2.5:3b`

## Install server
1. Run `INSTALL-SERVER.bat`.
2. Read `eula.txt`; set `eula=true` only if you agree to the Minecraft EULA.
3. Start Paper with `START-SERVER.bat`.

## Build and install AI plugin
GitHub Actions builds the plugin automatically after repository changes:
1. Open https://github.com/bs9973866-png/4istiq/actions
2. Open the latest successful **Build AI SMP** run.
3. Download and extract artifact `ai-smp-plugin`.
4. Copy `ai-smp-1.0.0.jar` into the server's `plugins` folder.
5. Restart Paper.

If Maven is installed locally, run `BUILD-PLUGIN.bat`; it builds and copies the JAR.

## Start agents
1. Start Paper and wait for Done.
2. Check that AISMP appears in `/plugins`.
3. Keep Ollama running and verify `ollama list` shows `qwen2.5:3b`.
4. Run `agent-runtime/start.bat`.
5. Wait for all 19 clients and the automatic 60-second countdown.

Commands: `/aismp status`, `/aismp start`, `/aismp stop`.

## Current prototype scope
19 real player clients, three peaceful factions, local Ollama decisions, exploration, wood gathering, starter-camp attempts, social chat and persistent memories. This is an early prototype, not a finished human-level civilization simulator. Mineflayer/Paper 26.2 compatibility must be validated on your live server.

## Security
The server uses `online-mode=false`; offline usernames are not authenticated. Keep it private, enable whitelist, and do not expose it directly to the public internet. PvP is disabled.
