# Unity MCP and `cm` from WSL

Unity runs on **Windows**; the MCP server and `cm` run in **WSL** (Ubuntu). Nothing is installed on Windows (no git,
Python or `uv`). With `mirrored` networking, `localhost` is the same on both sides.

## One-time setup

1. **WSL in mirrored mode.** In `C:\Users\<user>\.wslconfig`: `networkingMode=Mirrored`. Apply it with
   `wsl --shutdown` (PowerShell), then check in WSL: `wslinfo --networking-mode` should print `mirrored`.
2. **`uv` in WSL:** `curl -LsSf https://astral.sh/uv/install.sh | sh` (installs to `~/.local/bin`).
3. **The package in the Unity project.** Put `Packages/com.coplaydev.unity-mcp/` (the `MCPForUnity` folder of
   `CoplayDev/unity-mcp`, tag `v10.3.0`) in the project and reference it in `Packages/manifest.json`:
   `"com.coplaydev.unity-mcp": "file:com.coplaydev.unity-mcp"`. It is embedded so Unity does not need git.
4. **systemd user service** (no `enable`: it must not autostart, the server uses a lot of RAM).
   `~/.config/systemd/user/unity-mcp.service`:
   ```
   [Unit]
   Description=Unity MCP server (HTTP, localhost:8080)

   [Service]
   ExecStart=/home/<user>/.local/bin/uvx --from mcpforunityserver mcp-for-unity --transport http --http-url http://localhost:8080
   Restart=no
   ```
   Then `systemctl --user daemon-reload`.
5. **Register it in Claude Code:** `claude mcp add --transport http UnityMCP http://localhost:8080/mcp`.

## Every session

1. `systemctl --user start unity-mcp` (stop it with `systemctl --user stop unity-mcp`).
2. Open the project in Unity 2022.3.62f3. If the "MCP for Unity Setup" wizard shows Python/UV "Not Found", press
   **Next**: it looks in the Windows PATH and is not needed.
3. **Window > MCP for Unity**: transport **HTTP**, URL `http://localhost:8080`, connect. "Start Server" is not needed
   (the server already runs in WSL).
4. In Claude Code, `/mcp` reconnects if needed. The resource `mcpforunity://instances` should list the project.

## `cm` (Unity Version Control) in WSL

apt package `plasticscm-client-core`:

```
sudo install -d /etc/apt/keyrings
wget -O - https://uvcs.unity3d.com/linux/keys/public | sudo gpg --dearmor -o /etc/apt/keyrings/uvcs.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/uvcs.gpg] https://uvcs.unity3d.com/linux/repos/deb stable main" | sudo tee /etc/apt/sources.list.d/uvcs.list
sudo apt-get update && sudo apt-get install -y plasticscm-client-core
cm configure
```

In `cm configure`:
1. Language: **1** (English).
2. **Server address: `4674243965897@cloud`**.
3. Sign-in system: **0 - Unity ID**. It prints a URL: open it in the Windows browser and sign in. Option 1 (Email)
   only works if the account has a password.
4. Proxy: **N**.

Check with `cm status` inside the project (repo `202310505proyecto/202310505proyecto@4674243965897@cloud`,
branch `/main`).
