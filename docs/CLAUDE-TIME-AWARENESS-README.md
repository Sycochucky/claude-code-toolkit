# Claude Code Time Awareness System

Comprehensive temporal context for Claude Code with environment variables, market hours, and business logic.

## 📋 Overview

This system exports detailed temporal information as environment variables before launching Claude Code, enabling time-aware responses and context-sensitive behavior.

## ✨ Features

- **📅 Complete Date/Time Context** - UTC, local time, timezone information
- **🗓️ Calendar Intelligence** - Day of week, week numbers, quarter tracking
- **⏰ Period Awareness** - Business hours, market hours, weekend detection
- **🌍 Timezone Support** - Full timezone context with offsets
- **🔢 Multiple Formats** - ISO 8601, Unix timestamp, human-readable

## 🚀 Quick Start

### Installation

**Option 1: Bash/Zsh (Linux/macOS/WSL/Git Bash)**
```bash
bash install-claude-time-awareness.sh
```

**Option 2: PowerShell (Windows)**
```powershell
PowerShell -ExecutionPolicy Bypass -File Install-ClaudeTimeAwareness.ps1
```

### Usage

```bash
# Launch Claude Code with time awareness
claude-time

# View temporal context before launching
claude-time --show-context

# Pass arguments to Claude Code
claude-time --model sonnet
```

## 📊 Environment Variables

### Timestamps

| Variable | Example | Description |
|----------|---------|-------------|
| `CLAUDE_TIMESTAMP_UTC` | `2025-11-20T17:06:25Z` | ISO 8601 UTC timestamp |
| `CLAUDE_TIMESTAMP_LOCAL` | `2025-11-20T04:06:25+1100` | ISO 8601 local timestamp |
| `CLAUDE_DATE_UTC` | `2025-11-20` | UTC date |
| `CLAUDE_DATE_LOCAL` | `2025-11-20` | Local date |
| `CLAUDE_TIME_UTC` | `17:06:25` | UTC time |
| `CLAUDE_TIME_LOCAL` | `04:06:25` | Local time |
| `CLAUDE_UNIX_TIMESTAMP` | `1732036485` | Unix epoch timestamp |

### Timezone

| Variable | Example | Description |
|----------|---------|-------------|
| `CLAUDE_TIMEZONE` | `AEDT` | Timezone abbreviation |
| `CLAUDE_TIMEZONE_OFFSET` | `+1100` | UTC offset |

### Calendar Context

| Variable | Example | Description |
|----------|---------|-------------|
| `CLAUDE_DAY_OF_WEEK` | `Thursday` | Day name |
| `CLAUDE_DAY_OF_WEEK_NUM` | `4` | Day number (1-7, Monday=1) |
| `CLAUDE_DAY_OF_MONTH` | `20` | Day of month (01-31) |
| `CLAUDE_DAY_OF_YEAR` | `324` | Day of year (001-366) |
| `CLAUDE_WEEK_OF_YEAR` | `47` | ISO week number (01-53) |
| `CLAUDE_MONTH` | `November` | Month name |
| `CLAUDE_MONTH_NUM` | `11` | Month number (01-12) |
| `CLAUDE_YEAR` | `2025` | Year |
| `CLAUDE_QUARTER` | `4` | Quarter (1-4) |

### Period Flags

| Variable | Example | Description |
|----------|---------|-------------|
| `CLAUDE_IS_BUSINESS_HOURS` | `true`/`false` | 9 AM - 5 PM local time |
| `CLAUDE_IS_MARKET_HOURS` | `true`/`false` | NYSE hours (9:30 AM - 4 PM ET) |
| `CLAUDE_IS_WEEKEND` | `true`/`false` | Saturday or Sunday |

### Formatted Time

| Variable | Example | Description |
|----------|---------|-------------|
| `CLAUDE_HOUR_12` | `04 AM` | 12-hour format with AM/PM |
| `CLAUDE_HOUR_24` | `04` | 24-hour format |
| `CLAUDE_TIME_SUMMARY` | `Thursday, November 20, 2025 at 04:06:25 AEDT` | Human-readable summary |

## 💡 Use Cases

### Example 1: Time-Sensitive Responses

```python
# In your Claude Code session, Claude can now say:
"Today is {CLAUDE_DAY_OF_WEEK}, {CLAUDE_MONTH} {CLAUDE_DAY_OF_MONTH}, {CLAUDE_YEAR}"
# Output: "Today is Thursday, November 20, 2025"
```

### Example 2: Business Logic

```python
# Claude can check business hours:
if CLAUDE_IS_BUSINESS_HOURS == "true":
    # Respond with business-hour appropriate suggestions
    pass
```

### Example 3: Market Hours Trading

```python
# For financial applications:
if CLAUDE_IS_MARKET_HOURS == "true":
    # NYSE is open, real-time trading context
    pass
```

### Example 4: Weekend Context

```python
# Adjust behavior for weekends:
if CLAUDE_IS_WEEKEND == "true":
    # Suggest weekend-appropriate tasks
    pass
```

## 📁 Files Created

### `~/bin/claude-time`

Bash/Zsh wrapper script that:
1. Exports all temporal environment variables
2. Optionally displays temporal context
3. Launches Claude Code with the enriched environment

### `~/.claude/prompts/custom_instructions.md`

Updated with temporal context documentation that Claude Code reads on startup, making it aware of all available time variables.

## 🔧 Configuration

### PATH Configuration

The installer automatically adds `~/bin` to your PATH in:
- `~/.bashrc` (Bash)
- `~/.zshrc` (Zsh)
- `~/.config/fish/config.fish` (Fish)
- `~/.profile` (fallback)

On Windows with PowerShell:
- User PATH environment variable
- PowerShell profile with alias

### Custom Instructions

The temporal context is appended to `~/.claude/prompts/custom_instructions.md`. You can edit this file to customize how Claude interprets temporal data.

## 🎯 Advanced Usage

### Scripting with Time Awareness

```bash
# Create time-aware scripts
#!/bin/bash
source ~/bin/claude-time

if [ "$CLAUDE_IS_BUSINESS_HOURS" = "true" ]; then
    echo "Running business hours logic..."
fi
```

### Debugging

```bash
# View all time variables
claude-time --show-context

# Check specific variables
env | grep CLAUDE_
```

### Integration with Other Tools

```bash
# Use in cron jobs
0 9 * * 1-5 ~/bin/claude-time --version >> /var/log/claude-time.log

# Combine with other commands
claude-time && echo "Current time: $CLAUDE_TIME_SUMMARY"
```

## 🌍 Timezone Support

The system automatically detects your local timezone and provides:
- **UTC time** for universal reference
- **Local time** with timezone offset
- **Timezone name** (EST, PST, AEDT, etc.)
- **Offset** from UTC (+0000, -0500, +1100, etc.)

## 📈 Market Hours

NYSE (New York Stock Exchange) market hours detection:
- **Pre-market**: Before 9:30 AM ET
- **Market Hours**: 9:30 AM - 4:00 PM ET (`CLAUDE_IS_MARKET_HOURS=true`)
- **After-hours**: After 4:00 PM ET

Note: Currently only supports Eastern Time detection. Adjust as needed for other markets.

## 🛠️ Troubleshooting

### PATH not updated

**Problem**: `claude-time: command not found`

**Solution**:
```bash
# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc

# Or add manually
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Permissions Issue

**Problem**: Permission denied when running `claude-time`

**Solution**:
```bash
chmod +x ~/bin/claude-time
```

### Variables Not Set

**Problem**: `CLAUDE_*` variables are empty

**Solution**:
```bash
# Run with source to export to current shell
source ~/bin/claude-time --show-context
```

## 🔄 Updating

To update the system:

1. **Re-run the installer** (it will skip existing files)
2. **Or manually update** `~/bin/claude-time`

```bash
# Re-run installer
bash install-claude-time-awareness.sh
```

## 🗑️ Uninstallation

```bash
# Remove wrapper script
rm ~/bin/claude-time

# Remove custom instructions (or edit manually)
# Edit ~/.claude/prompts/custom_instructions.md
# and remove the "Temporal Context Awareness" section

# Remove PATH entry from shell config
# Edit ~/.bashrc or ~/.zshrc
# and remove the line: export PATH="$HOME/bin:$PATH"
```

## 📝 Examples

### Check Current Context

```bash
$ claude-time --show-context
╔════════════════════════════════════════════╗
║     Claude Code Temporal Context          ║
╚════════════════════════════════════════════╝

📅 Current Time: Thursday, November 20, 2025 at 04:06:25 AEDT

🕐 Local:  2025-11-20T04:06:25+1100
🌍 UTC:    2025-11-19T17:06:25Z

📆 Day:     Thursday (Day 324 of 2025)
📊 Week:    Week 47 of 2025, Q4
⏰ Period:  Business Hours: false | Weekend: false
📈 Market:  Market Hours: false
```

### Use in Shell Scripts

```bash
#!/bin/bash
# backup-script.sh

# Source time variables
eval "$(~/bin/claude-time --show-context | grep '^export')"

BACKUP_NAME="backup-$CLAUDE_DATE_LOCAL-$CLAUDE_TIME_LOCAL.tar.gz"
tar -czf "$BACKUP_NAME" /important/data/
```

## 🤝 Contributing

Suggestions for improvements:
- Additional timezone support
- More market hours (NASDAQ, LSE, TSE, etc.)
- Custom business hour definitions
- Holiday detection
- Lunar calendar support

## 📄 License

MIT License - Feel free to use and modify

## 🎉 Credits

Created for Claude Code time awareness and temporal context enrichment.

---

**Version**: 1.0.0
**Last Updated**: November 2025
**Compatible With**: Bash, Zsh, Fish, PowerShell
