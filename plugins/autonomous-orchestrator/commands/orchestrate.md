---
name: orchestrate
description: Execute autonomous orchestration - analyze, plan, execute with tools
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "TodoWrite"]
---

# ⛔ EXECUTE MODE - NOT REPORT MODE

**User Goal:** $ARGUMENTS

## YOU MUST DO THIS NOW:

### Step 1: Call tools to understand the project
```
1. Glob("**/*") - see all files
2. Read("index.html") or main entry file - see what's used
```

### Step 2: Create todo list
```
TodoWrite([
  {content: "Analyze files", status: "in_progress", activeForm: "Analyzing"},
  {content: "Execute changes", status: "pending", activeForm: "Executing"},
  {content: "Verify results", status: "pending", activeForm: "Verifying"}
])
```

### Step 3: Execute with REAL tool calls
```
For deletions: Bash("del filename.js")
For edits: Edit(file, old_string, new_string)
For creates: Write(file, content)
```

### Step 4: Verify each change
```
Bash("dir") or Read(file) after each change
```

## CRITICAL RULES

- **NO TOOL CALL = NO CHANGE HAPPENED**
- If you say "deleted file.js" without calling Bash("del file.js"), YOU FAILED
- Call tools FIRST, then describe what happened
- Update TodoWrite after each task

## START NOW

Call Glob to see the files, then Read the main file, then TodoWrite your plan, then EXECUTE.

**DO NOT just write a report. CALL THE TOOLS.**
