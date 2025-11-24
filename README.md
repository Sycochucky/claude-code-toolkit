# Claude Code Toolkit

A collection of powerful plugins and tools to supercharge your Claude Code experience.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)

## 🚀 What's Included

### 🔌 Plugins

1. **[Time Awareness Plugin](./plugins/time-awareness/)** - Automatic temporal context
   - 20+ environment variables with date/time info
   - Business hours, market hours, weekend detection
   - Runs automatically on every session start
   - No wrapper scripts needed!

2. **[Discord-Postgres Dev](./plugins/discord-postgres-dev/)** - Expert agents for Discord bot development
   - Discord.py 2.4+ expert agent
   - PostgreSQL expert agent (asyncpg, SQLAlchemy 2.0+)
   - Complete bot builder coordinator
   - 2025 modern libraries and patterns

3. **[Autonomous Orchestrator](./plugins/autonomous-orchestrator/)** - Multi-agent autonomous workflows
   - Orchestrator agent (Opus) for planning and loop control
   - Head Dev Coder agent (Sonnet) for implementation
   - Intelligent model routing (Haiku/Sonnet/Opus)
   - Built-in stopping criteria and progress detection

### 🛠️ Tools

- **[Time Awareness Installer](./tools/)** - Shell installer for time-awareness wrapper script
  - Bash/Zsh version for Linux/macOS/WSL
  - PowerShell version for Windows
  - Exports temporal variables before launching Claude Code

### 📚 Documentation

Complete guides and examples in the [`docs/`](./docs/) folder.

---

## 📦 Quick Start

### Installing Plugins

**Method 1: From GitHub (Recommended)**
```bash
# Add this repository as a marketplace
claude plugin marketplace add Sycochucky/claude-code-toolkit

# Install individual plugins
claude plugin install time-awareness@Sycochucky-claude-code-toolkit
claude plugin install discord-postgres-dev@Sycochucky-claude-code-toolkit
claude plugin install autonomous-orchestrator@Sycochucky-claude-code-toolkit
```

**Method 2: Local Installation**
```bash
# Clone the repository
git clone https://github.com/Sycochucky/claude-code-toolkit.git
cd claude-code-toolkit

# Add as local marketplace
claude plugin marketplace add ./plugins/time-awareness
claude plugin marketplace add ./plugins/discord-postgres-dev

# Install plugins
claude plugin install time-awareness@local-time-awareness
claude plugin install discord-postgres-dev@local-discord-postgres
```

---

## 🔌 Plugins

### Time Awareness Plugin

**Automatic temporal context for Claude Code**

Exports 20+ environment variables on every session start:
- Timestamps (UTC, local, Unix)
- Calendar context (day of week, week number, quarter)
- Smart flags (business hours, market hours, weekend)
- Timezone information

**Features:**
- ✅ No wrapper scripts needed
- ✅ Automatic on every session
- ✅ SessionStart hook
- ✅ Comprehensive time data

**Installation:**
```bash
claude plugin install time-awareness@Sycochucky-claude-code-toolkit
```

**Usage:**
Just restart Claude Code! The hook runs automatically and you'll see:
```
🕐 Temporal Context Loaded: Thursday, November 20, 2025 at 04:15:30 AEDT
📅 2025-11-20 | ⏰ Week 47, Q4 | 🌍 AEDT
💼 Business Hours: false | 📈 Market Hours: false | 🎉 Weekend: false
```

[Full Documentation →](./plugins/time-awareness/README.md)

---

### Discord-Postgres Dev Plugin

**Expert agents for modern Discord bot development**

Three specialized agents using 2025 best practices:
- **discordpy-expert** - Discord.py 2.4+ (commands, events, UI)
- **postgres-expert** - PostgreSQL (schema, queries, optimization)
- **bot-builder** - Complete feature coordinator

**Features:**
- ✅ discord.py 2.4+ with slash commands
- ✅ asyncpg + SQLAlchemy 2.0 async ORM
- ✅ Pydantic v2 validation
- ✅ Production-ready patterns

**Installation:**
```bash
claude plugin install discord-postgres-dev@Sycochucky-claude-code-toolkit
```

**Usage:**
```python
# Use via Task tool
Task(
    subagent_type="discord-postgres-dev:bot-builder",
    prompt="Create a leveling system with /rank and /leaderboard",
    description="Build leveling system"
)
```

[Full Documentation →](./plugins/discord-postgres-dev/README.md)

---

### Autonomous Orchestrator Plugin

**Multi-agent system for autonomous workflows**

Two specialized agents with intelligent model routing:
- **orchestrator** (Opus) - Planning, routing, loop control
- **head-dev-coder** (Sonnet) - Implementation, systems engineering

**Features:**
- ✅ Autonomous execution loops with stopping criteria
- ✅ Intelligent model routing (Haiku/Sonnet/Opus)
- ✅ Task board management and progress tracking
- ✅ Diminishing returns detection
- ✅ Loop control patterns skill

**Installation:**
```bash
claude plugin install autonomous-orchestrator@Sycochucky-claude-code-toolkit
```

**Usage:**
```bash
# Launch an autonomous workflow
/orchestrate Build a complete authentication system with JWT tokens

# With configuration
/orchestrate MAX_LOOPS=20 Refactor the database layer for performance
```

**Model Routing:**
| Complexity | Model | Use Cases |
|------------|-------|-----------|
| Trivial | Haiku | Format, lint, validate, quick checks |
| Standard | Sonnet | Functions, classes, tests, docs |
| Complex | Opus | Architecture, debugging, strategy |

[Full Documentation →](./plugins/autonomous-orchestrator/README.md)

---

## 🛠️ Tools

### Time Awareness Installer (Legacy)

**Shell installer for time-awareness wrapper script**

Before the plugin existed, this was the way to add time awareness via a wrapper script.

**Note:** The plugin is now recommended over the wrapper script!

**Files:**
- `install-claude-time-awareness.sh` - Bash/Zsh installer
- `Install-ClaudeTimeAwareness.ps1` - PowerShell installer

**Installation:**
```bash
bash tools/install-claude-time-awareness.sh
```

Then use:
```bash
claude-time --show-context
```

[Full Documentation →](./docs/CLAUDE-TIME-AWARENESS-README.md)

---

## 🏗️ Repository Structure

```
claude-code-toolkit/
├── plugins/                      # Claude Code plugins
│   ├── time-awareness/          # Time awareness plugin
│   │   ├── .claude-plugin/
│   │   ├── hooks/
│   │   └── README.md
│   ├── discord-postgres-dev/    # Discord + PostgreSQL plugin
│   │   ├── .claude-plugin/
│   │   ├── agents/
│   │   ├── references/
│   │   └── README.md
│   └── autonomous-orchestrator/ # Multi-agent autonomous workflows
│       ├── .claude-plugin/
│       ├── agents/
│       ├── commands/
│       ├── skills/
│       └── README.md
├── tools/                        # Standalone tools
│   ├── install-claude-time-awareness.sh
│   └── Install-ClaudeTimeAwareness.ps1
├── docs/                         # Documentation
│   └── CLAUDE-TIME-AWARENESS-README.md
├── README.md                     # This file
└── LICENSE                       # MIT License
```

---

## 📖 Documentation

### Plugin Development

- [Creating Plugins](./docs/creating-plugins.md) *(Coming soon)*
- [Hook System Guide](./docs/hooks-guide.md) *(Coming soon)*
- [Agent Development](./docs/agent-development.md) *(Coming soon)*

### Plugin Guides

- [Time Awareness Plugin](./plugins/time-awareness/README.md)
- [Discord-Postgres Dev Plugin](./plugins/discord-postgres-dev/README.md)
- [Autonomous Orchestrator Plugin](./plugins/autonomous-orchestrator/README.md)
- [Time Awareness Tool (Legacy)](./docs/CLAUDE-TIME-AWARENESS-README.md)

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-plugin`)
3. **Commit your changes** (`git commit -m 'Add amazing plugin'`)
4. **Push to the branch** (`git push origin feature/amazing-plugin`)
5. **Open a Pull Request**

### Ideas for Contributions

- New plugins for specific workflows
- Additional agents for discord-postgres-dev
- More time-awareness features (holidays, custom periods)
- Documentation improvements
- Bug fixes and optimizations

---

## 📋 Requirements

- **Claude Code** (latest version)
- **Bash/Zsh** (for shell scripts on Linux/macOS/WSL)
- **PowerShell** (for Windows scripts)
- **Git** (for cloning and version control)

### Plugin-Specific Requirements

**Time Awareness:**
- Bash 4.0+ or Zsh
- `date` command (standard on all Unix-like systems)

**Discord-Postgres Dev:**
- Python 3.11+
- PostgreSQL 15+ (for actual bot development)

---

## 🐛 Issues & Support

Found a bug or have a feature request?

- **[Open an Issue](https://github.com/Sycochucky/claude-code-toolkit/issues)**
- **[Start a Discussion](https://github.com/Sycochucky/claude-code-toolkit/discussions)**

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Acknowledgments

- Built for [Claude Code](https://claude.ai/code) by Anthropic
- Inspired by the Claude Code plugin ecosystem
- Community contributions welcome!

---

## 🔗 Links

- [Claude Code Documentation](https://code.claude.com/docs)
- [Claude Code Plugins](https://claude-plugins.dev)
- [Anthropic](https://anthropic.com)

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/Sycochucky/claude-code-toolkit?style=social)
![GitHub forks](https://img.shields.io/github/forks/Sycochucky/claude-code-toolkit?style=social)
![GitHub issues](https://img.shields.io/github/issues/Sycochucky/claude-code-toolkit)
![GitHub pull requests](https://img.shields.io/github/issues-pr/Sycochucky/claude-code-toolkit)

---

**Made with ❤️ for the Claude Code community**
