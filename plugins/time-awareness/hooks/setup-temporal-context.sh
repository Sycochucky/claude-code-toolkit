#!/usr/bin/env bash
# Claude Code Temporal Context Hook
# Exports comprehensive temporal environment variables on session start

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
export CLAUDE_DAY_OF_WEEK=$(date +"%A")
export CLAUDE_DAY_OF_WEEK_NUM=$(date +"%u")
export CLAUDE_DAY_OF_MONTH=$(date +"%d")
export CLAUDE_DAY_OF_YEAR=$(date +"%j")
export CLAUDE_WEEK_OF_YEAR=$(date +"%V")
export CLAUDE_MONTH=$(date +"%B")
export CLAUDE_MONTH_NUM=$(date +"%m")
export CLAUDE_YEAR=$(date +"%Y")
export CLAUDE_QUARTER=$(( ($(date +%-m)-1)/3 + 1 ))

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
export CLAUDE_HOUR_12=$(date +"%I %p")
export CLAUDE_HOUR_24=$(date +"%H")

# ===== Human-Readable Summary =====
export CLAUDE_TIME_SUMMARY="$CLAUDE_DAY_OF_WEEK, $CLAUDE_MONTH $CLAUDE_DAY_OF_MONTH, $CLAUDE_YEAR at $CLAUDE_TIME_LOCAL $CLAUDE_TIMEZONE"

# ===== Output temporal context to session =====
echo "🕐 Temporal Context Loaded: $CLAUDE_TIME_SUMMARY"
echo "📅 $CLAUDE_DATE_LOCAL | ⏰ Week $CLAUDE_WEEK_OF_YEAR, Q$CLAUDE_QUARTER | 🌍 $CLAUDE_TIMEZONE"
echo "💼 Business Hours: $CLAUDE_IS_BUSINESS_HOURS | 📈 Market Hours: $CLAUDE_IS_MARKET_HOURS | 🎉 Weekend: $CLAUDE_IS_WEEKEND"
