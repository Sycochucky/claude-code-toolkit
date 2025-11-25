---
name: orchestrate
description: Launch an autonomous orchestration workflow for complex, multi-step goals
allowed-tools: ["Task", "Read", "Write", "Edit", "Grep", "Glob", "Bash", "TodoWrite", "WebSearch", "WebFetch"]
---

# Autonomous Orchestration Workflow

You are initiating an **autonomous orchestration workflow**. This is a self-directed, multi-phase execution system optimized for complex goals.

## Workflow Initialization

**User Goal:** $ARGUMENTS

### Step 1: Launch the Orchestrator

Use the Task tool to spawn the **orchestrator** agent with model `opus`:

```
Task: orchestrator agent
Prompt: [Include the full user goal and any context from the conversation]
Model: opus
```

The orchestrator will:
1. Analyze the goal and clarify if absolutely necessary
2. Create a phased plan with milestones
3. Set up the task board
4. Begin the autonomous execution loop

### Step 2: Orchestrator Loop Behavior

The orchestrator will autonomously:

1. **Evaluate State** - Check progress against goal
2. **Select Tasks** - Pick highest-priority unblocked work
3. **Route to Models**:
   - **Haiku** for fast checks and simple ops
   - **Sonnet** for standard coding and writing
   - **Opus** for architecture and strategic decisions
4. **Delegate to Head Dev Coder** for complex implementations
5. **Integrate Results** - Update task board and project state
6. **Loop or Stop** based on:
   - Goal achieved
   - Diminishing returns (no progress in N loops)
   - MAX_LOOPS reached (default: 10)
   - User constraint hit

### Step 3: Reporting

When the workflow completes, expect a report containing:

- **Summary** - What was accomplished
- **Loop Behavior** - Iterations and key decisions
- **Model Usage** - Which models handled what
- **Artifacts** - Code, configs, or docs generated
- **Next Steps** - Suggestions for extension

## Configuration Options

You can customize the workflow by specifying:

- `MAX_LOOPS=N` - Maximum iterations (default: 10)
- `MODE=single|loop` - Force single-pass or loop mode
- `VERBOSE=true` - Detailed progress updates

Example: `/orchestrate MAX_LOOPS=20 Build a complete REST API with auth`

## CRITICAL: Execution Requirement

**The orchestrator MUST actually execute changes, not just report them.**

Every file modification, deletion, or creation requires:
1. A tool call (Edit, Write, Bash) to make the change
2. A verification call (Read, Bash dir/ls) to confirm it worked
3. Only then can the task be marked complete

If the orchestrator reports "completed" without tool calls that changed files, it has failed.

## Safety Features

The orchestrator includes built-in safety:

- **Loop counting** - Never runs indefinitely
- **Progress detection** - Stops if stalled
- **Decision logging** - All choices are recorded
- **Graceful stopping** - Clean termination with status

## When to Use This

Use `/orchestrate` for:
- Multi-phase feature implementations
- Codebase-wide refactoring
- Complex debugging requiring exploration
- Open-ended optimization goals
- Any task that benefits from autonomous iteration

Do NOT use for:
- Simple, single-step tasks
- Questions that need direct answers
- Tasks requiring constant user input

---

**Starting autonomous orchestration for:** $ARGUMENTS
