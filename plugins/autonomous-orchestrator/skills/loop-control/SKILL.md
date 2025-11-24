---
name: Loop Control Patterns
description: Use this skill when implementing autonomous loops, iteration control, progress detection, or stopping conditions for agent workflows
version: 1.0.0
---

# Loop Control Patterns for Autonomous Agents

This skill provides patterns and best practices for implementing robust autonomous execution loops.

## Core Loop Architecture

### Basic Loop Structure

```python
class AutonomousLoop:
    def __init__(self, config):
        self.max_loops = config.get('max_loops', 10)
        self.current_loop = 0
        self.state = {}
        self.decisions = []
        self.progress_history = []

    def run(self, goal):
        self.initialize(goal)

        while self.should_continue():
            self.current_loop += 1
            self.checkpoint()

            # Core loop iteration
            evaluation = self.evaluate_state()
            tasks = self.select_tasks(evaluation)
            results = self.execute_tasks(tasks)
            self.integrate_results(results)

            # Progress tracking
            progress = self.measure_progress()
            self.progress_history.append(progress)

        return self.finalize()

    def should_continue(self):
        # Check all stopping conditions
        if self.current_loop >= self.max_loops:
            return False
        if self.goal_achieved():
            return False
        if self.is_stalled():
            return False
        if self.user_requested_stop():
            return False
        return True
```

## Stopping Criteria Patterns

### 1. Goal Achievement Detection

```python
def goal_achieved(self):
    """Check if success criteria are met."""
    criteria = self.state.get('success_criteria', [])
    results = self.state.get('results', {})

    for criterion in criteria:
        if not self.criterion_met(criterion, results):
            return False
    return True

def criterion_met(self, criterion, results):
    """Evaluate a single success criterion."""
    criterion_type = criterion.get('type')

    if criterion_type == 'file_exists':
        return os.path.exists(criterion['path'])
    elif criterion_type == 'tests_pass':
        return results.get('test_results', {}).get('passed', False)
    elif criterion_type == 'metric_threshold':
        metric = results.get(criterion['metric'], 0)
        return metric >= criterion['threshold']
    # Add more criterion types as needed
    return False
```

### 2. Diminishing Returns Detection

```python
def is_stalled(self):
    """Detect when progress has stalled."""
    if len(self.progress_history) < 3:
        return False  # Not enough data

    # Check last N iterations for progress
    recent = self.progress_history[-3:]

    # If progress hasn't improved, we're stalled
    if all(p <= recent[0] for p in recent[1:]):
        return True

    # If variance is too low, we're cycling
    variance = self.calculate_variance(recent)
    if variance < 0.01:  # Threshold for meaningful change
        return True

    return False

def measure_progress(self):
    """Quantify progress toward goal."""
    total_tasks = len(self.state.get('all_tasks', []))
    completed_tasks = len(self.state.get('completed_tasks', []))

    if total_tasks == 0:
        return 0.0

    return completed_tasks / total_tasks
```

### 3. Resource-Based Stopping

```python
def check_resource_limits(self):
    """Stop if resource constraints are hit."""
    # Time-based
    elapsed = time.time() - self.start_time
    if elapsed > self.config.get('max_time_seconds', 3600):
        return True

    # Token-based (for LLM calls)
    tokens_used = self.state.get('tokens_consumed', 0)
    if tokens_used > self.config.get('max_tokens', 100000):
        return True

    # Cost-based
    cost = self.state.get('estimated_cost', 0)
    if cost > self.config.get('max_cost', 10.0):
        return True

    return False
```

## State Management Patterns

### Task Board State

```python
class TaskBoard:
    def __init__(self):
        self.tasks = {
            'open': [],
            'in_progress': [],
            'blocked': [],
            'completed': [],
            'skipped': []
        }
        self.decisions = []

    def add_task(self, task, priority='medium'):
        task['priority'] = priority
        task['created_at'] = datetime.now()
        task['state'] = 'open'
        self.tasks['open'].append(task)

    def start_task(self, task_id):
        task = self.find_task(task_id)
        self.move_task(task, 'open', 'in_progress')
        task['started_at'] = datetime.now()

    def complete_task(self, task_id, outcome):
        task = self.find_task(task_id)
        self.move_task(task, 'in_progress', 'completed')
        task['completed_at'] = datetime.now()
        task['outcome'] = outcome

    def log_decision(self, decision, rationale):
        self.decisions.append({
            'loop': self.current_loop,
            'decision': decision,
            'rationale': rationale,
            'timestamp': datetime.now()
        })
```

### Checkpointing for Recovery

```python
class CheckpointManager:
    def __init__(self, checkpoint_dir):
        self.checkpoint_dir = checkpoint_dir

    def save(self, state, loop_number):
        """Save state for recovery."""
        checkpoint_file = os.path.join(
            self.checkpoint_dir,
            f'checkpoint_{loop_number}.json'
        )
        with open(checkpoint_file, 'w') as f:
            json.dump({
                'loop': loop_number,
                'state': state,
                'timestamp': datetime.now().isoformat()
            }, f, indent=2)

    def load_latest(self):
        """Load most recent checkpoint."""
        checkpoints = sorted(glob.glob(
            os.path.join(self.checkpoint_dir, 'checkpoint_*.json')
        ))
        if not checkpoints:
            return None
        with open(checkpoints[-1]) as f:
            return json.load(f)

    def recover(self):
        """Resume from last checkpoint."""
        checkpoint = self.load_latest()
        if checkpoint:
            return checkpoint['state'], checkpoint['loop']
        return {}, 0
```

## Model Routing Logic

### Cost-Capability Routing

```python
class ModelRouter:
    MODELS = {
        'haiku': {'capability': 1, 'cost': 0.25, 'speed': 1.0},
        'sonnet': {'capability': 2, 'cost': 3.0, 'speed': 0.7},
        'opus': {'capability': 3, 'cost': 15.0, 'speed': 0.4}
    }

    def select_model(self, task):
        """Route task to appropriate model."""
        complexity = self.assess_complexity(task)
        stakes = task.get('stakes', 'normal')

        # High stakes always get Opus
        if stakes == 'high':
            return 'opus'

        # Route by complexity
        if complexity == 'trivial':
            return 'haiku'
        elif complexity == 'standard':
            return 'sonnet'
        else:  # complex
            return 'opus'

    def assess_complexity(self, task):
        """Assess task complexity for routing."""
        task_type = task.get('type', '')

        trivial_types = ['format', 'lint', 'validate', 'check']
        complex_types = ['architect', 'debug', 'design', 'analyze']

        if any(t in task_type.lower() for t in trivial_types):
            return 'trivial'
        if any(t in task_type.lower() for t in complex_types):
            return 'complex'
        return 'standard'
```

## Error Handling & Recovery

### Retry with Backoff

```python
async def execute_with_retry(self, task, max_retries=3):
    """Execute task with exponential backoff retry."""
    last_error = None

    for attempt in range(max_retries):
        try:
            result = await self.execute_task(task)
            return result
        except RecoverableError as e:
            last_error = e
            wait_time = (2 ** attempt) + random.uniform(0, 1)
            await asyncio.sleep(wait_time)
            self.log(f"Retry {attempt + 1}/{max_retries} after {wait_time:.1f}s")
        except UnrecoverableError as e:
            self.log(f"Unrecoverable error: {e}")
            raise

    # All retries exhausted
    self.log(f"Task failed after {max_retries} retries: {last_error}")
    return {'status': 'failed', 'error': str(last_error)}
```

### Alternative Approach Pattern

```python
def handle_stall(self):
    """Try alternative approaches when stuck."""
    alternatives = self.generate_alternatives()

    for i, approach in enumerate(alternatives[:2]):  # Try max 2
        self.log_decision(
            f"Trying alternative approach {i+1}",
            approach['rationale']
        )

        # Reset relevant state
        self.rollback_to_checkpoint()

        # Try the alternative
        result = self.execute_approach(approach)

        if result['success']:
            return result

    # All alternatives failed
    return {
        'success': False,
        'action': 'stop',
        'reason': 'All approaches exhausted'
    }
```

## Observability Patterns

### Structured Logging

```python
class LoopLogger:
    def __init__(self, loop_id):
        self.loop_id = loop_id

    def log(self, level, message, **context):
        entry = {
            'timestamp': datetime.now().isoformat(),
            'loop_id': self.loop_id,
            'level': level,
            'message': message,
            **context
        }
        print(json.dumps(entry))

    def loop_start(self, iteration, state_summary):
        self.log('INFO', 'Loop iteration started',
                 iteration=iteration,
                 open_tasks=state_summary['open_tasks'],
                 completed_tasks=state_summary['completed_tasks'])

    def loop_end(self, iteration, outcome):
        self.log('INFO', 'Loop iteration completed',
                 iteration=iteration,
                 outcome=outcome,
                 duration_ms=outcome.get('duration_ms'))

    def decision(self, decision, rationale):
        self.log('INFO', 'Decision made',
                 decision=decision,
                 rationale=rationale)
```

## Summary Report Template

When completing an autonomous workflow, generate a report:

```markdown
## Autonomous Workflow Report

### Goal
[Original goal statement]

### Outcome
[SUCCESS / PARTIAL / FAILED]

### Summary
[1-3 sentences describing what was accomplished]

### Execution Details
- **Total Loops:** N
- **Duration:** X minutes
- **Tasks Completed:** M/T

### Loop History
| Loop | Action | Model | Outcome |
|------|--------|-------|---------|
| 1    | ...    | ...   | ...     |

### Key Decisions
1. [Decision and rationale]
2. [Decision and rationale]

### Artifacts Generated
- [File/artifact 1]
- [File/artifact 2]

### Remaining Work
- [ ] [Task if incomplete]

### Recommendations
- [Suggestion for next steps or monitoring]
```

Use these patterns to build robust, observable, and controllable autonomous agent loops.
