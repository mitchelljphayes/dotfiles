---
description: Summarize progress and prepare for context continuation
---

## Context Compaction

Compact current workflow state for handoff or continuation.

### What to Produce

Summarize the current state as a structured artifact:

1. **Progress Summary**: What's been done so far
2. **Current Status**: Where we are in the workflow
3. **Key Findings**: Important context discovered
4. **Remaining Work**: What's left to do
5. **File Inventory**: Key files touched or identified

### Output Format

```markdown
## Session Summary

### Completed
- [What was done]

### Current State
- [Where we are]

### Key Context
- [Important findings, decisions, patterns discovered]

### Remaining
- [What's left]

### Files
- [Key files with brief notes]
```

Present this summary so it can be copy-pasted into a new session if needed, or used to continue in the current session with clear context.
