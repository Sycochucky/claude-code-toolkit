# Time Awareness Plugin

Automatic temporal context for Claude Code via SessionStart hook.

## What It Does

This plugin automatically exports **20+ temporal environment variables** every time Claude Code starts, providing comprehensive time, date, and calendar context.

## Installation

```bash
# Add as local marketplace
claude plugin marketplace add ./time-awareness-plugin

# Install the plugin
claude plugin install time-awareness@local-time-awareness
```

Or if you've published it:
```bash
claude plugin install time-awareness@your-marketplace
```

## How It Works

**SessionStart Hook**: When Claude Code starts, the `setup-temporal-context.sh` script runs automatically and exports all temporal environment variables to the session.

You'll see a message like:
```
🕐 Temporal Context Loaded: Thursday, November 20, 2025 at 04:15:30 AEDT
📅 2025-11-20 | ⏰ Week 47, Q4 | 🌍 AEDT
💼 Business Hours: false | 📈 Market Hours: false | 🎉 Weekend: false
```

## Available Environment Variables

### Timestamps
- `CLAUDE_TIMESTAMP_UTC` - ISO 8601 UTC (e.g., `2025-11-20T17:15:30Z`)
- `CLAUDE_TIMESTAMP_LOCAL` - ISO 8601 local (e.g., `2025-11-20T04:15:30+1100`)
- `CLAUDE_DATE_UTC` - UTC date (e.g., `2025-11-20`)
- `CLAUDE_DATE_LOCAL` - Local date (e.g., `2025-11-20`)
- `CLAUDE_TIME_UTC` - UTC time (e.g., `17:15:30`)
- `CLAUDE_TIME_LOCAL` - Local time (e.g., `04:15:30`)
- `CLAUDE_UNIX_TIMESTAMP` - Unix epoch timestamp

### Timezone
- `CLAUDE_TIMEZONE` - Timezone name (e.g., `AEDT`, `EST`, `PST`)
- `CLAUDE_TIMEZONE_OFFSET` - UTC offset (e.g., `+1100`, `-0500`)

### Calendar Context
- `CLAUDE_DAY_OF_WEEK` - Day name (e.g., `Thursday`)
- `CLAUDE_DAY_OF_WEEK_NUM` - Day number 1-7 (Monday=1)
- `CLAUDE_DAY_OF_MONTH` - Day of month (01-31)
- `CLAUDE_DAY_OF_YEAR` - Day of year (001-366)
- `CLAUDE_WEEK_OF_YEAR` - ISO week number (01-53)
- `CLAUDE_MONTH` - Month name (e.g., `November`)
- `CLAUDE_MONTH_NUM` - Month number (01-12)
- `CLAUDE_YEAR` - Year (e.g., `2025`)
- `CLAUDE_QUARTER` - Quarter (1-4)

### Period Flags
- `CLAUDE_IS_BUSINESS_HOURS` - `true`/`false` (9 AM - 5 PM local)
- `CLAUDE_IS_MARKET_HOURS` - `true`/`false` (NYSE: 9:30 AM - 4 PM ET)
- `CLAUDE_IS_WEEKEND` - `true`/`false` (Saturday/Sunday)

### Formatted Time
- `CLAUDE_HOUR_12` - 12-hour format (e.g., `04 AM`)
- `CLAUDE_HOUR_24` - 24-hour format (e.g., `04`)
- `CLAUDE_TIME_SUMMARY` - Human-readable (e.g., `Thursday, November 20, 2025 at 04:15:30 AEDT`)

## Usage Examples

### In Claude Code Sessions

Claude Code now has access to these variables throughout the session:

**Example 1: Time-aware responses**
```
User: "What day is it?"
Claude: "Today is $CLAUDE_DAY_OF_WEEK, $CLAUDE_MONTH $CLAUDE_DAY_OF_MONTH, $CLAUDE_YEAR"
Output: "Today is Thursday, November 20, 2025"
```

**Example 2: Business logic**
```
User: "Should we deploy now?"
Claude: *Checks $CLAUDE_IS_BUSINESS_HOURS and $CLAUDE_DAY_OF_WEEK*
        "It's currently after business hours on a weekday.
         Consider deploying during business hours for better monitoring."
```

**Example 3: Context-aware suggestions**
```
User: "Plan my day"
Claude: *Checks $CLAUDE_IS_WEEKEND*
        "It's Thursday, a workday. Here's a productivity-focused schedule..."
```

## Technical Details

### Hook Configuration

`hooks/hooks.json`:
```json
{
  "SessionStart": [
    {
      "name": "setup-temporal-context",
      "description": "Export comprehensive temporal environment variables",
      "command": "bash",
      "args": ["${CLAUDE_PLUGIN_ROOT}/hooks/setup-temporal-context.sh"]
    }
  ]
}
```

### Hook Script

`hooks/setup-temporal-context.sh` - Bash script that:
1. Calculates all temporal values using `date` command
2. Exports environment variables
3. Prints confirmation message to session

## Advantages Over Wrapper Script

✅ **Automatic** - No need to remember to use `claude-time` wrapper
✅ **Seamless** - Works with normal `claude` command
✅ **Integrated** - Runs on every session start
✅ **Clean** - No PATH modifications needed
✅ **Portable** - Easy to share as a plugin

## Troubleshooting

### Variables Not Available

**Check if plugin is installed:**
```bash
claude plugin list
```

**Check if hook is running:**
Look for the temporal context message when Claude Code starts:
```
🕐 Temporal Context Loaded: ...
```

### Permission Issues

**Make hook executable:**
```bash
chmod +x ~/.claude/plugins/time-awareness/hooks/setup-temporal-context.sh
```

## Customization

### Modify Hook Script

Edit `hooks/setup-temporal-context.sh` to:
- Add custom time periods
- Change business hours definition
- Add holiday detection
- Support additional timezones

### Add More Hooks

You can add additional hooks to `hooks/hooks.json`:
- `PreToolUse` - Before each tool call
- `UserPromptSubmit` - When user submits a prompt
- `Stop` - When session ends

## Version

**1.0.0** - Initial release with SessionStart hook

## License

MIT License

---

**No wrapper scripts needed** - Just install the plugin and go! 🎉
