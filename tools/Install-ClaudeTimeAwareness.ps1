# Claude Code Time Awareness Installer (PowerShell)
# Sets up temporal context for Claude Code with environment variables

$ErrorActionPreference = "Stop"

Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║  Claude Code Time Awareness Installer     ║" -ForegroundColor Blue
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

$BinDir = Join-Path $env:USERPROFILE "bin"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$PromptsDir = Join-Path $ClaudeDir "prompts"
$WrapperScript = Join-Path $BinDir "claude-time.ps1"
$CustomInstructions = Join-Path $PromptsDir "custom_instructions.md"

Write-Host "[1/5] Creating directories..." -ForegroundColor Yellow

# Create ~/bin directory
if (!(Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
    Write-Host "✓ Created $BinDir" -ForegroundColor Green
} else {
    Write-Host "✓ $BinDir already exists" -ForegroundColor Green
}

# Create .claude/prompts directory
if (!(Test-Path $PromptsDir)) {
    New-Item -ItemType Directory -Path $PromptsDir -Force | Out-Null
    Write-Host "✓ Created $PromptsDir" -ForegroundColor Green
} else {
    Write-Host "✓ $PromptsDir already exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "[2/5] Creating claude-time wrapper script..." -ForegroundColor Yellow

# Create the claude-time wrapper PowerShell script
$WrapperContent = @'
# Claude Code Time Awareness Wrapper (PowerShell)
# Exports comprehensive temporal context before launching Claude Code

# ===== ISO 8601 UTC Timestamp =====
$env:CLAUDE_TIMESTAMP_UTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$env:CLAUDE_DATE_UTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
$env:CLAUDE_TIME_UTC = (Get-Date).ToUniversalTime().ToString("HH:mm:ss")

# ===== Local Timestamp =====
$LocalTime = Get-Date
$env:CLAUDE_TIMESTAMP_LOCAL = $LocalTime.ToString("yyyy-MM-ddTHH:mm:sszzz")
$env:CLAUDE_DATE_LOCAL = $LocalTime.ToString("yyyy-MM-dd")
$env:CLAUDE_TIME_LOCAL = $LocalTime.ToString("HH:mm:ss")
$env:CLAUDE_TIMEZONE = [TimeZoneInfo]::Local.StandardName
$env:CLAUDE_TIMEZONE_OFFSET = $LocalTime.ToString("zzz")

# ===== Day/Week Context =====
$env:CLAUDE_DAY_OF_WEEK = $LocalTime.ToString("dddd")
$env:CLAUDE_DAY_OF_WEEK_NUM = [int]$LocalTime.DayOfWeek
if ($env:CLAUDE_DAY_OF_WEEK_NUM -eq 0) { $env:CLAUDE_DAY_OF_WEEK_NUM = 7 }  # Sunday = 7
$env:CLAUDE_DAY_OF_MONTH = $LocalTime.ToString("dd")
$env:CLAUDE_DAY_OF_YEAR = $LocalTime.DayOfYear.ToString("000")
$env:CLAUDE_WEEK_OF_YEAR = (Get-Culture).Calendar.GetWeekOfYear($LocalTime, 'FirstFourDayWeek', 'Monday').ToString("00")
$env:CLAUDE_MONTH = $LocalTime.ToString("MMMM")
$env:CLAUDE_MONTH_NUM = $LocalTime.ToString("MM")
$env:CLAUDE_YEAR = $LocalTime.ToString("yyyy")
$env:CLAUDE_QUARTER = [Math]::Ceiling($LocalTime.Month / 3)

# ===== Time Period Flags =====
$Hour = $LocalTime.Hour

# Business hours (9 AM - 5 PM local)
$env:CLAUDE_IS_BUSINESS_HOURS = "false"
if ($Hour -ge 9 -and $Hour -lt 17) {
    $env:CLAUDE_IS_BUSINESS_HOURS = "true"
}

# Weekend check (Saturday=6, Sunday=0)
$env:CLAUDE_IS_WEEKEND = "false"
if ($LocalTime.DayOfWeek -eq 'Saturday' -or $LocalTime.DayOfWeek -eq 'Sunday') {
    $env:CLAUDE_IS_WEEKEND = "true"
}

# Market hours (NYSE: 9:30 AM - 4:00 PM ET) - simplified check
$env:CLAUDE_IS_MARKET_HOURS = "false"
if ($env:CLAUDE_TIMEZONE -match "Eastern" -and $Hour -ge 9 -and $Hour -lt 16) {
    if ($Hour -eq 9 -and $LocalTime.Minute -lt 30) {
        $env:CLAUDE_IS_MARKET_HOURS = "false"
    } else {
        $env:CLAUDE_IS_MARKET_HOURS = "true"
    }
}

# ===== Unix Timestamp =====
$UnixEpoch = Get-Date -Date "1970-01-01 00:00:00Z"
$env:CLAUDE_UNIX_TIMESTAMP = [int]($LocalTime.ToUniversalTime() - $UnixEpoch).TotalSeconds

# ===== Relative Time =====
$env:CLAUDE_HOUR_12 = $LocalTime.ToString("hh tt")
$env:CLAUDE_HOUR_24 = $LocalTime.ToString("HH")

# ===== Human-Readable Summary =====
$env:CLAUDE_TIME_SUMMARY = "$($env:CLAUDE_DAY_OF_WEEK), $($env:CLAUDE_MONTH) $($env:CLAUDE_DAY_OF_MONTH), $($env:CLAUDE_YEAR) at $($env:CLAUDE_TIME_LOCAL) $($env:CLAUDE_TIMEZONE)"

# ===== Display Context (Optional) =====
if ($args -contains "--show-context" -or $args -contains "-s") {
    Write-Host "╔════════════════════════════════════════════╗"
    Write-Host "║     Claude Code Temporal Context          ║"
    Write-Host "╚════════════════════════════════════════════╝"
    Write-Host ""
    Write-Host "📅 Current Time: $($env:CLAUDE_TIME_SUMMARY)"
    Write-Host ""
    Write-Host "🕐 Local:  $($env:CLAUDE_TIMESTAMP_LOCAL)"
    Write-Host "🌍 UTC:    $($env:CLAUDE_TIMESTAMP_UTC)"
    Write-Host ""
    Write-Host "📆 Day:     $($env:CLAUDE_DAY_OF_WEEK) (Day $($env:CLAUDE_DAY_OF_YEAR) of $($env:CLAUDE_YEAR))"
    Write-Host "📊 Week:    Week $($env:CLAUDE_WEEK_OF_YEAR) of $($env:CLAUDE_YEAR), Q$($env:CLAUDE_QUARTER)"
    Write-Host "⏰ Period:  Business Hours: $($env:CLAUDE_IS_BUSINESS_HOURS) | Weekend: $($env:CLAUDE_IS_WEEKEND)"
    Write-Host "📈 Market:  Market Hours: $($env:CLAUDE_IS_MARKET_HOURS)"
    Write-Host ""

    $args = $args | Where-Object { $_ -ne "--show-context" -and $_ -ne "-s" }
}

# Launch Claude Code with temporal context
& claude $args
'@

Set-Content -Path $WrapperScript -Value $WrapperContent
Write-Host "✓ Created: $WrapperScript" -ForegroundColor Green

Write-Host ""
Write-Host "[3/5] Setting up custom instructions..." -ForegroundColor Yellow

$TemporalContext = @'

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
'@

if (Test-Path $CustomInstructions) {
    $Content = Get-Content $CustomInstructions -Raw
    if ($Content -match "# Temporal Context Awareness") {
        Write-Host "⚠  Temporal context already exists in $CustomInstructions" -ForegroundColor Yellow
        Write-Host "⚠  Skipping to avoid duplicates" -ForegroundColor Yellow
    } else {
        Add-Content -Path $CustomInstructions -Value $TemporalContext
        Write-Host "✓ Appended temporal context to $CustomInstructions" -ForegroundColor Green
    }
} else {
    Set-Content -Path $CustomInstructions -Value $TemporalContext
    Write-Host "✓ Created $CustomInstructions with temporal context" -ForegroundColor Green
}

Write-Host ""
Write-Host "[4/5] Verifying PATH configuration..." -ForegroundColor Yellow

# Check if ~/bin is in PATH
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($CurrentPath -like "*$BinDir*") {
    Write-Host "✓ $BinDir is already in PATH" -ForegroundColor Green
} else {
    Write-Host "⚠  $BinDir is NOT in PATH" -ForegroundColor Yellow
    Write-Host "⚠  Adding to user PATH..." -ForegroundColor Yellow

    $NewPath = "$BinDir;$CurrentPath"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")

    Write-Host "✓ Added $BinDir to user PATH" -ForegroundColor Green
    Write-Host "⚠  Restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[5/5] Verifying installation..." -ForegroundColor Yellow

if (Test-Path $WrapperScript) {
    Write-Host "✓ Wrapper script created successfully" -ForegroundColor Green

    # Create a convenient alias in PowerShell profile
    $ProfilePath = $PROFILE.CurrentUserAllHosts
    $AliasCommand = "Set-Alias -Name claude-time -Value '$WrapperScript'"

    if (Test-Path $ProfilePath) {
        $ProfileContent = Get-Content $ProfilePath -Raw
        if ($ProfileContent -notmatch "claude-time") {
            Add-Content -Path $ProfilePath -Value "`n# Claude Time Awareness`n$AliasCommand"
            Write-Host "✓ Added alias to PowerShell profile: $ProfilePath" -ForegroundColor Green
        }
    } else {
        New-Item -Path $ProfilePath -ItemType File -Force | Out-Null
        Set-Content -Path $ProfilePath -Value "# Claude Time Awareness`n$AliasCommand"
        Write-Host "✓ Created PowerShell profile with alias" -ForegroundColor Green
    }
} else {
    Write-Host "✗ Wrapper script was not created" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       Installation Complete! 🎉            ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Blue
Write-Host ""
Write-Host "1. " -NoNewline; Write-Host "Restart your terminal" -ForegroundColor Yellow
Write-Host "   (or run: " -NoNewline; Write-Host ". `$PROFILE" -ForegroundColor Green -NoNewline; Write-Host ")"
Write-Host ""
Write-Host "2. " -NoNewline; Write-Host "Launch Claude Code with time awareness:" -ForegroundColor Yellow
Write-Host "   " -NoNewline; Write-Host "claude-time" -ForegroundColor Green
Write-Host ""
Write-Host "3. " -NoNewline; Write-Host "View temporal context before launching:" -ForegroundColor Yellow
Write-Host "   " -NoNewline; Write-Host "claude-time --show-context" -ForegroundColor Green
Write-Host ""
Write-Host "Files Created:" -ForegroundColor Blue
Write-Host "  • $WrapperScript"
Write-Host "  • $CustomInstructions"
Write-Host ""
Write-Host "Happy time-aware coding! ⏰" -ForegroundColor Green
