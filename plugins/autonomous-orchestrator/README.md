# Autonomous Orchestrator Plugin

Multi-agent plugin optimized for **autonomous agent loops** and complex, self-directed workflows with intelligent model routing.

## Features

- **Orchestrator Agent (Opus)** - Central planner, router, and loop controller
- **Head Dev Coder Agent (Sonnet)** - Systems engineer for implementation
- **Intelligent Model Routing** - Haiku/Sonnet/Opus based on task complexity
- **Loop Control Patterns** - Built-in stopping criteria and progress detection

## Installation

```bash
# From the claude-code-toolkit marketplace
claude plugin install autonomous-orchestrator
```

## Usage

### Launch an Autonomous Workflow

```
/orchestrate Build a complete authentication system with JWT tokens
```

### Configuration Options

- `MAX_LOOPS=N` - Maximum iterations (default: 10)
- `MODE=single|loop` - Force execution mode
- `VERBOSE=true` - Detailed progress updates

Example:
```
/orchestrate MAX_LOOPS=20 Refactor the database layer for better performance
```

## Agents

### Orchestrator (Opus)

The strategic brain of the system:
- Analyzes goals and creates phased plans
- Maintains task board with state tracking
- Routes tasks to appropriate models
- Detects diminishing returns and stops intelligently

**Model Routing Logic:**
| Task Type | Model | Examples |
|-----------|-------|----------|
| Trivial | Haiku | Format, lint, validate, quick checks |
| Standard | Sonnet | Functions, classes, tests, docs |
| Complex | Opus | Architecture, debugging, strategic decisions |

### Head Dev Coder (Sonnet)

The implementation specialist:
- Multi-agent system architecture
- Task queues and worker pools
- Tool integrations (APIs, databases, CLI)
- Monitoring and observability

## Loop Control

The orchestrator stops when:
1. **Goal Achieved** - Success criteria met
2. **Diminishing Returns** - No progress in recent iterations
3. **MAX_LOOPS Reached** - Configurable limit (default: 10)
4. **Blocked** - Requires user input

## Output Report

After completion, you receive:
- Summary of accomplishments
- Loop history with decisions
- Model usage breakdown
- Generated artifacts list
- Recommendations for next steps

## License

MIT
