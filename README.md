# Homebrew Tap for sqry

[sqry](https://sqry.dev) is a lean, focused **semantic code search tool**
built in Rust. It understands code structure through AST analysis so
you can search by what code *means*, not just what it says.

## Install

```bash
brew tap verivus-oss/sqry
brew install verivus-oss/sqry/sqry
```

## Upgrade

```bash
brew update
brew upgrade sqry
```

## Uninstall

```bash
brew uninstall sqry
brew untap verivus-oss/sqry
```

## Included binaries

The formula installs:

- `sqry` — CLI
- `sqry-mcp` — MCP server for AI assistants
- `sqry-lsp` — language server
- `sqryd` — daemon for warm, shared graph sessions

## More info

## What gets installed

The formula installs four binaries into your Homebrew prefix:

| Binary       | Purpose                                                      |
|--------------|--------------------------------------------------------------|
| `sqry`       | CLI for indexing, searching, and graph queries               |
| `sqry-mcp`   | MCP server for AI assistants (34 JSON-RPC tools)             |
| `sqry-lsp`   | LSP server for editor integration                            |
| `sqryd`      | Workspace-aware daemon (memory-resident graph cache, IPC)    |

## Quick start

```bash
sqry index .            # build the semantic graph for the current repo
sqry search "user auth" # semantic search over the indexed graph
sqryd start             # start the daemon for low-latency MCP/LSP use
```

See [sqry.dev](https://sqry.dev) for the full documentation, query
language reference, and integration guides.

## Auto-publishing

This tap is auto-published on every GitHub release of
[verivus-oss/sqry](https://github.com/verivus-oss/sqry). To track
the latest release run:

```bash
brew update && brew upgrade sqry
```

## License

The formula is published under the same MIT license as sqry itself.
