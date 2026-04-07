# Replicate Plugin for OpenCode

An [OpenCode](https://opencode.ai) plugin + skill that lets your AI agent search, explore, and run ML models on [Replicate](https://replicate.com) directly from the terminal.

## Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/lucataco/replicate-opencode-plugin/main/install.sh | bash
```

Then set your API token and start OpenCode:

```bash
export REPLICATE_API_TOKEN=r8_your_token_here
opencode
```

The installer writes the plugin into your project's `.opencode/` directory. OpenCode then auto-discovers it and runs `bun install` there to resolve dependencies.

## What It Does

The plugin registers four tools that the LLM agent can call during a conversation:

| Tool | Description |
|---|---|
| `replicate_search` | Search for models by task or name. Enriches results with official status and creation date. |
| `replicate_schema` | Get a model's input/output OpenAPI schema. Always call this before running a model. |
| `replicate_run` | Run a prediction. Handles sync wait (60s) and automatic polling until completion. |
| `replicate_whoami` | Check the authenticated Replicate account. |

It also ships a **companion skill** (`skills/replicate/SKILL.md` in this repo, installed to `.opencode/skills/replicate/SKILL.md`) that injects workflow guidance into the agent's system prompt: how to plan multi-step creative tasks, which models to prefer, and how to present outputs.

## Setup

### Option A: Per-project install

Copy the repo files into a project's `.opencode/` directory:

```bash
mkdir -p /path/to/your/project/.opencode/plugins /path/to/your/project/.opencode/skills/replicate
cp plugins/replicate.ts /path/to/your/project/.opencode/plugins/
cp skills/replicate/SKILL.md /path/to/your/project/.opencode/skills/replicate/
cp package.json /path/to/your/project/.opencode/package.json
```

### Option B: Global install

Install the plugin and skill globally so they're available in every project:

```bash
# Plugin
cp plugins/replicate.ts ~/.config/opencode/plugins/

# Skill
mkdir -p ~/.config/opencode/skills/replicate
cp skills/replicate/SKILL.md ~/.config/opencode/skills/replicate/

# Dependencies (if you don't already have a package.json here)
cp package.json ~/.config/opencode/package.json
```

### Set your API token

Get a token from [replicate.com/account/api-tokens](https://replicate.com/account/api-tokens), then:

```bash
export REPLICATE_API_TOKEN=r8_your_token_here
```

Add this to your shell profile (`.bashrc`, `.zshrc`, etc.) to persist it.

### Verify

Start OpenCode and ask:

> "What's my Replicate username?"

The agent should call `replicate_whoami` and return your account info.

## Usage

Just ask the agent to do things with ML models:

- **"Generate an image of a cat in a spacesuit"** — searches for an image model, checks its schema, runs it
- **"Search for video generation models on Replicate"** — returns enriched search results
- **"Run black-forest-labs/flux-schnell with prompt 'a sunset over mountains'"** — runs the model directly
- **"Make a short commercial for my coffee shop"** — plans a multi-step workflow across several models
- **"Translate this video to Spanish"** — chains speech recognition, translation, TTS, and lip sync models

The companion skill teaches the agent the recommended workflow: **search -> schema -> run -> present output**.

## How It Works

The plugin is a TypeScript module loaded by OpenCode's plugin system. It exports a `ReplicatePlugin` function that registers four tools using the `@opencode-ai/plugin` SDK.

Each tool makes direct HTTP `fetch` calls to `https://api.replicate.com/v1`. The `replicate_run` tool uses the `Prefer: wait=60` header for synchronous mode, then falls back to polling every 2 seconds if the prediction hasn't completed.

Tool argument schemas are defined using [Zod](https://zod.dev) via the `@opencode-ai/plugin` package.

## File Structure

Source layout in this repo:

```text
.
├── package.json                 # Dependency template copied into .opencode/
├── plugins/
│   └── replicate.ts             # Plugin source - 4 tools
└── skills/
    └── replicate/
        └── SKILL.md             # Workflow guidance injected into agent prompt
```

Installed layout inside a project:

```text
.opencode/
├── package.json
├── plugins/
│   └── replicate.ts
└── skills/
    └── replicate/
        └── SKILL.md
```

## Requirements

- [OpenCode](https://opencode.ai) (v0.1+)
- A [Replicate API token](https://replicate.com/account/api-tokens)
- [Bun](https://bun.sh) (OpenCode uses it automatically to install plugin dependencies)

## License

[Apache 2.0](LICENSE)
