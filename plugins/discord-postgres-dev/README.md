# Discord-Postgres Dev Plugin

Expert agents for building modern Discord bots with PostgreSQL using 2025 best practices.

## What This Plugin Provides

**3 Specialized Agents:**

1. **discordpy-expert** - Discord.py 2.4+ development
   - Slash commands with autocomplete
   - UI components (buttons, modals, select menus)
   - Event listeners and background tasks
   - Cogs and modular architecture

2. **postgres-expert** - PostgreSQL database operations
   - Schema design with SQLAlchemy 2.0+
   - High-performance queries with asyncpg
   - Migrations with Alembic
   - Query optimization and indexing

3. **bot-builder** - Complete feature coordinator
   - Builds end-to-end features
   - Integrates Discord + PostgreSQL
   - Leveling systems, moderation, economy, etc.

## Installation

1. Install the plugin:
   ```bash
   # From local directory
   claude plugin install ./discord-postgres-dev

   # Or if published to marketplace
   claude plugin install discord-postgres-dev@your-marketplace
   ```

2. The plugin is now available! Use the agents via the Task tool.

## Usage

### Method 1: Via Task Tool (In Code)

```python
# In your Claude Code session, use the Task tool:
Task(
    subagent_type="discord-postgres-dev:discordpy-expert",
    prompt="Create a /poll command with interactive buttons",
    description="Create poll command"
)
```

### Method 2: Direct Invocation

When working in Claude Code, the agents are available in the agent selector menu.

## Example Workflows

### Build a Complete Leveling System

Use **bot-builder**:
```
Prompt: "Create a complete leveling system with:
- XP from messages
- /rank command to check rank
- /leaderboard with pagination
- Level-up announcements
- PostgreSQL tracking"
```

### Create Just a Discord Command

Use **discordpy-expert**:
```
Prompt: "Create a /poll command with:
- Up to 10 poll options
- Interactive buttons for voting
- Live vote count updates
- Results display"
```

### Design Database Schema

Use **postgres-expert**:
```
Prompt: "Design a PostgreSQL schema for:
- User inventory system
- Item catalog
- Transaction history
- Trade system"
```

## 2025 Technologies

All agents use the latest 2025 libraries:
- **discord.py 2.4+** - Full Discord API v10
- **Python 3.11+** - Modern async/await
- **PostgreSQL 15+** - Latest database features
- **asyncpg 0.29+** - High-performance async driver
- **SQLAlchemy 2.0+** - Modern async ORM
- **Alembic 1.13+** - Database migrations
- **Pydantic v2** - Data validation

See `references/requirements-2025.txt` for complete list.

## Agent Capabilities

### discordpy-expert
- ✅ Slash commands with `app_commands`
- ✅ Interactive UI (buttons, select menus, modals)
- ✅ Event listeners
- ✅ Background tasks
- ✅ Context menus
- ✅ Error handling
- ✅ Cogs architecture

### postgres-expert
- ✅ SQLAlchemy 2.0 models
- ✅ asyncpg raw queries
- ✅ Alembic migrations
- ✅ Complex queries
- ✅ Indexing strategies
- ✅ Transactions
- ✅ Query optimization

### bot-builder
- ✅ Complete feature implementation
- ✅ Discord + Database integration
- ✅ End-to-end workflows
- ✅ Production-ready code
- ✅ Error handling
- ✅ Best practices

## When to Use Each Agent

| Agent | Use When You Need |
|-------|-------------------|
| **bot-builder** | Complete features (leveling, moderation, economy) |
| **discordpy-expert** | Discord commands, events, UI components |
| **postgres-expert** | Database design, queries, optimization |

## Requirements

- Python 3.11+
- PostgreSQL 15+
- Discord Bot Token
- See `references/requirements-2025.txt`

## Support

These agents provide comprehensive, production-ready code with:
- Modern async patterns
- Full type hints
- Error handling
- Performance optimization
- 2025 best practices

---

**Version:** 1.0.0
**Author:** Discord Bot Developer
**License:** MIT
