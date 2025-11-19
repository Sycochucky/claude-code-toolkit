#!/usr/bin/env bash
# Claude Code Time Awareness Installer
# Sets up temporal context for Claude Code with environment variables

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Code Time Awareness Installer     ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo ""

# Determine home directory (works on Windows/WSL/Linux/macOS)
if [ -z "$HOME" ]; then
    HOME=$(cd ~ && pwd)
fi

BIN_DIR="$HOME/bin"
CLAUDE_DIR="$HOME/.claude"
PROMPTS_DIR="$CLAUDE_DIR/prompts"
WRAPPER_SCRIPT="$BIN_DIR/claude-time"
CUSTOM_INSTRUCTIONS="$PROMPTS_DIR/custom_instructions.md"

echo -e "${YELLOW}[1/5]${NC} Creating directories..."

# Create ~/bin directory
if [ ! -d "$BIN_DIR" ]; then
    mkdir -p "$BIN_DIR"
    echo -e "${GREEN}✓${NC} Created $BIN_DIR"
else
    echo -e "${GREEN}✓${NC} $BIN_DIR already exists"
fi

# Create .claude/prompts directory
if [ ! -d "$PROMPTS_DIR" ]; then
    mkdir -p "$PROMPTS_DIR"
    echo -e "${GREEN}✓${NC} Created $PROMPTS_DIR"
else
    echo -e "${GREEN}✓${NC} $PROMPTS_DIR already exists"
fi

echo ""
echo -e "${YELLOW}[2/5]${NC} Creating claude-time wrapper script..."

# Create the claude-time wrapper script
cat > "$WRAPPER_SCRIPT" << 'EOF'
#!/usr/bin/env bash
# Claude Code Time Awareness Wrapper
# Exports comprehensive temporal context before launching Claude Code

# ===== ISO 8601 UTC Timestamp =====
export CLAUDE_TIMESTAMP_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
export CLAUDE_DATE_UTC=$(date -u +"%Y-%m-%d")
export CLAUDE_TIME_UTC=$(date -u +"%H:%M:%S")

# ===== Local Timestamp =====
export CLAUDE_TIMESTAMP_LOCAL=$(date +"%Y-%m-%dT%H:%M:%S%z")
export CLAUDE_DATE_LOCAL=$(date +"%Y-%m-%d")
export CLAUDE_TIME_LOCAL=$(date +"%H:%M:%S")
export CLAUDE_TIMEZONE=$(date +"%Z")
export CLAUDE_TIMEZONE_OFFSET=$(date +"%z")

# ===== Day/Week Context =====
export CLAUDE_DAY_OF_WEEK=$(date +"%A")           # Monday, Tuesday, etc.
export CLAUDE_DAY_OF_WEEK_NUM=$(date +"%u")       # 1-7 (Monday=1)
export CLAUDE_DAY_OF_MONTH=$(date +"%d")          # 01-31
export CLAUDE_DAY_OF_YEAR=$(date +"%j")           # 001-366
export CLAUDE_WEEK_OF_YEAR=$(date +"%V")          # ISO week number 01-53
export CLAUDE_MONTH=$(date +"%B")                 # January, February, etc.
export CLAUDE_MONTH_NUM=$(date +"%m")             # 01-12
export CLAUDE_YEAR=$(date +"%Y")                  # 2025
export CLAUDE_QUARTER=$(( ($(date +%-m)-1)/3 + 1 )) # Q1-Q4

# ===== Time Period Flags =====
HOUR=$(date +%-H)

# Market hours (NYSE: 9:30 AM - 4:00 PM ET)
export CLAUDE_IS_MARKET_HOURS="false"
if [ "$CLAUDE_TIMEZONE" = "EST" ] || [ "$CLAUDE_TIMEZONE" = "EDT" ]; then
    if [ $HOUR -ge 9 ] && [ $HOUR -lt 16 ]; then
        if [ $HOUR -eq 9 ] && [ $(date +%-M) -lt 30 ]; then
            CLAUDE_IS_MARKET_HOURS="false"
        else
            CLAUDE_IS_MARKET_HOURS="true"
        fi
    fi
fi
export CLAUDE_IS_MARKET_HOURS

# Business hours (9 AM - 5 PM local)
export CLAUDE_IS_BUSINESS_HOURS="false"
if [ $HOUR -ge 9 ] && [ $HOUR -lt 17 ]; then
    CLAUDE_IS_BUSINESS_HOURS="true"
fi
export CLAUDE_IS_BUSINESS_HOURS

# Weekend check
export CLAUDE_IS_WEEKEND="false"
if [ "$CLAUDE_DAY_OF_WEEK_NUM" -ge 6 ]; then
    CLAUDE_IS_WEEKEND="true"
fi
export CLAUDE_IS_WEEKEND

# ===== Unix Timestamp =====
export CLAUDE_UNIX_TIMESTAMP=$(date +%s)

# ===== Relative Time =====
export CLAUDE_HOUR_12=$(date +"%I %p")           # 02 PM
export CLAUDE_HOUR_24=$(date +"%H")              # 14

# ===== Human-Readable Summary =====
export CLAUDE_TIME_SUMMARY="$CLAUDE_DAY_OF_WEEK, $CLAUDE_MONTH $CLAUDE_DAY_OF_MONTH, $CLAUDE_YEAR at $CLAUDE_TIME_LOCAL $CLAUDE_TIMEZONE"

# ===== Display Context (Optional) =====
if [ "$1" = "--show-context" ] || [ "$1" = "-s" ]; then
    echo "╔════════════════════════════════════════════╗"
    echo "║     Claude Code Temporal Context          ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    echo "📅 Current Time: $CLAUDE_TIME_SUMMARY"
    echo ""
    echo "🕐 Local:  $CLAUDE_TIMESTAMP_LOCAL"
    echo "🌍 UTC:    $CLAUDE_TIMESTAMP_UTC"
    echo ""
    echo "📆 Day:     $CLAUDE_DAY_OF_WEEK (Day $CLAUDE_DAY_OF_YEAR of $CLAUDE_YEAR)"
    echo "📊 Week:    Week $CLAUDE_WEEK_OF_YEAR of $CLAUDE_YEAR, Q$CLAUDE_QUARTER"
    echo "⏰ Period:  Business Hours: $CLAUDE_IS_BUSINESS_HOURS | Weekend: $CLAUDE_IS_WEEKEND"
    echo "📈 Market:  Market Hours: $CLAUDE_IS_MARKET_HOURS"
    echo ""
    shift
fi

# Launch Claude Code with temporal context
exec claude "$@"
EOF

chmod +x "$WRAPPER_SCRIPT"
echo -e "${GREEN}✓${NC} Created and made executable: $WRAPPER_SCRIPT"

echo ""
echo -e "${YELLOW}[3/5]${NC} Setting up custom instructions..."

# Create or append to custom_instructions.md
TEMPORAL_CONTEXT='
# Temporal Context Awareness

Claude Code has access to comprehensive temporal information via environment variables:

## Current Time Information

- **UTC Time**: `$CLAUDE_TIMESTAMP_UTC` (ISO 8601)
- **Local Time**: `$CLAUDE_TIMESTAMP_LOCAL` (ISO 8601)
- **Timezone**: `$CLAUDE_TIMEZONE` (offset: `$CLAUDE_TIMEZONE_OFFSET`)
- **Summary**: `$CLAUDE_TIME_SUMMARY`

## Calendar Context

- **Date**: `$CLAUDE_DATE_LOCAL` (Local) / `$CLAUDE_DATE_UTC` (UTC)
- **Day**: `$CLAUDE_DAY_OF_WEEK` (Day `$CLAUDE_DAY_OF_WEEK_NUM` of week)
- **Week**: Week `$CLAUDE_WEEK_OF_YEAR` of `$CLAUDE_YEAR`
- **Month**: `$CLAUDE_MONTH` (`$CLAUDE_MONTH_NUM`)
- **Quarter**: Q`$CLAUDE_QUARTER` of `$CLAUDE_YEAR`
- **Day of Year**: Day `$CLAUDE_DAY_OF_YEAR` of 365/366

## Time Period Flags

- **Business Hours**: `$CLAUDE_IS_BUSINESS_HOURS` (9 AM - 5 PM local)
- **Market Hours**: `$CLAUDE_IS_MARKET_HOURS` (NYSE: 9:30 AM - 4 PM ET)
- **Weekend**: `$CLAUDE_IS_WEEKEND` (Saturday/Sunday)

## Usage in Context

When responding to time-sensitive queries:
- Use `$CLAUDE_DATE_LOCAL` for current date references
- Check `$CLAUDE_IS_BUSINESS_HOURS` for business-context responses
- Reference `$CLAUDE_DAY_OF_WEEK` for day-specific logic
- Use `$CLAUDE_TIMEZONE` for timezone-aware responses

## Unix Timestamp

- **Timestamp**: `$CLAUDE_UNIX_TIMESTAMP` (seconds since epoch)

---

*Temporal context updated on each Claude Code launch via `claude-time` wrapper.*
'

if [ -f "$CUSTOM_INSTRUCTIONS" ]; then
    # Check if temporal context already exists
    if grep -q "# Temporal Context Awareness" "$CUSTOM_INSTRUCTIONS"; then
        echo -e "${YELLOW}⚠${NC}  Temporal context already exists in $CUSTOM_INSTRUCTIONS"
        echo -e "${YELLOW}⚠${NC}  Skipping to avoid duplicates (remove manually if needed)"
    else
        echo "$TEMPORAL_CONTEXT" >> "$CUSTOM_INSTRUCTIONS"
        echo -e "${GREEN}✓${NC} Appended temporal context to $CUSTOM_INSTRUCTIONS"
    fi
else
    echo "$TEMPORAL_CONTEXT" > "$CUSTOM_INSTRUCTIONS"
    echo -e "${GREEN}✓${NC} Created $CUSTOM_INSTRUCTIONS with temporal context"
fi

echo ""
echo -e "${YELLOW}[4/5]${NC} Verifying PATH configuration..."

# Check if ~/bin is in PATH
if [[ ":$PATH:" == *":$BIN_DIR:"* ]]; then
    echo -e "${GREEN}✓${NC} $BIN_DIR is already in PATH"
else
    echo -e "${YELLOW}⚠${NC}  $BIN_DIR is NOT in PATH"
    echo -e "${YELLOW}⚠${NC}  Adding to shell configuration..."

    # Detect shell and add to appropriate config file
    SHELL_NAME=$(basename "$SHELL")

    case "$SHELL_NAME" in
        bash)
            if [ -f "$HOME/.bashrc" ]; then
                CONFIG_FILE="$HOME/.bashrc"
            else
                CONFIG_FILE="$HOME/.bash_profile"
            fi
            ;;
        zsh)
            CONFIG_FILE="$HOME/.zshrc"
            ;;
        fish)
            CONFIG_FILE="$HOME/.config/fish/config.fish"
            ;;
        *)
            CONFIG_FILE="$HOME/.profile"
            ;;
    esac

    # Add PATH export
    if [ -f "$CONFIG_FILE" ]; then
        if ! grep -q "export PATH=\"\$HOME/bin:\$PATH\"" "$CONFIG_FILE"; then
            echo "" >> "$CONFIG_FILE"
            echo "# Added by Claude Code Time Awareness Installer" >> "$CONFIG_FILE"
            echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$CONFIG_FILE"
            echo -e "${GREEN}✓${NC} Added $BIN_DIR to PATH in $CONFIG_FILE"
        else
            echo -e "${GREEN}✓${NC} PATH configuration already exists in $CONFIG_FILE"
        fi
    else
        echo -e "${RED}✗${NC} Could not find shell config file: $CONFIG_FILE"
        echo -e "${YELLOW}ℹ${NC}  Manually add: export PATH=\"\$HOME/bin:\$PATH\""
    fi
fi

echo ""
echo -e "${YELLOW}[5/5]${NC} Verifying installation..."

# Test the wrapper script
if [ -x "$WRAPPER_SCRIPT" ]; then
    echo -e "${GREEN}✓${NC} Wrapper script is executable"

    # Test temporal context generation
    echo -e "${GREEN}✓${NC} Testing temporal context generation..."
    bash "$WRAPPER_SCRIPT" --show-context --version 2>&1 | head -n 10

else
    echo -e "${RED}✗${NC} Wrapper script is not executable"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       Installation Complete! 🎉            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "1. ${YELLOW}Reload your shell configuration:${NC}"
echo "   ${GREEN}source ~/.bashrc${NC}  # or ~/.zshrc for zsh"
echo ""
echo "2. ${YELLOW}Launch Claude Code with time awareness:${NC}"
echo "   ${GREEN}claude-time${NC}"
echo ""
echo "3. ${YELLOW}View temporal context before launching:${NC}"
echo "   ${GREEN}claude-time --show-context${NC}"
echo ""
echo "4. ${YELLOW}Verify environment variables:${NC}"
echo "   ${GREEN}claude-time --show-context --version${NC}"
echo ""
echo -e "${BLUE}Files Created:${NC}"
echo "  • $WRAPPER_SCRIPT"
echo "  • $CUSTOM_INSTRUCTIONS"
echo ""
echo -e "${BLUE}Environment Variables Available:${NC}"
echo "  • CLAUDE_TIMESTAMP_UTC, CLAUDE_TIMESTAMP_LOCAL"
echo "  • CLAUDE_DAY_OF_WEEK, CLAUDE_WEEK_OF_YEAR"
echo "  • CLAUDE_IS_BUSINESS_HOURS, CLAUDE_IS_MARKET_HOURS"
echo "  • CLAUDE_IS_WEEKEND, CLAUDE_TIMEZONE"
echo "  • And more! Check $CUSTOM_INSTRUCTIONS"
echo ""
echo -e "${GREEN}Happy time-aware coding! ⏰${NC}"
