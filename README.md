# GDB MCP Server (FastMCP)

A lightweight MCP server that runs inside GDB. It exposes a single tool, `gdb-command`, which proxies input directly to GDB’s command interpreter and returns the textual output. The server runs over SSE and is started from within GDB via the `mcp-server` command.

## Features
- `gdb-command`: pass any GDB command, get back its output.
- Minimal, self-contained script: `gdb-mcp` (loaded via `source`).

## Requirements
- GDB with Python support enabled.
- Python 3.x and the `fastmcp` library available to GDB’s embedded Python.

Check Python support: `gdb -q -ex "python print('ok')" -ex quit`

Install FastMCP: `python3 -m pip install fastmcp`
If import fails in GDB, ensure `fastmcp` is installed to the same Python environment GDB uses.

## Quick Start

### Option 1: Docker (Recommended)
1) Build the Docker image
```bash
docker build -t gdb-mcp .
```

2) Run the container
```bash
docker run -it --rm -p 3333:3333 gdb-mcp
```

The MCP server will automatically start on port 3333 when GDB launches.

3) Connect an MCP client to the server at `http://localhost:3333`

### Option 2: Local Installation
1) Start GDB with the MCP extension loaded
- `gdb -q -ex 'source ./gdb-mcp'`
- Alternatively, load from within gdb `source ./gdb-mcp`

2) Launch the SSE server from within GDB
- `mcp-server 127.0.0.1 3333`

3) Connect an MCP client to the server
- Configure your MCP client to connect to the SSE server at the host/port selected above and call tool `gdb-command`.

### Tool: gdb-command
- Parameters:
  - `command` (string): the exact GDB command to run (e.g., `info registers`).
- Returns: string (captured GDB output or an error message).

## Notes & Tips
- No timeout or stop control is provided by this script. To interrupt long-running target execution, issue the `interrupt` command.
- Do not bind publicly unless you trust clients; this endpoint can execute arbitrary GDB commands.
- To auto-load, add a line to your `~/.gdbinit`: `source /absolute/path/to/gdb-mcp`.
- There is no builtin 'stop server' functionality. To teardown the server, exit GDB.

## License
MIT — see `LICENSE`.

## Acknowledgements
- Built on top of the excellent `fastmcp` library.
