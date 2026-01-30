---
description: Resume last workflow from checkpoint
agent: builder
---

Resume the most recent workflow.

1. Find latest session in `.opencode/sessions/`
2. Read `metadata.json` to understand state:
   - Which phases completed
   - Current phase
   - Last checkpoint status
3. Show summary of where we left off
4. Ask to continue from last checkpoint

If multiple sessions exist, list them and ask which to resume.

If no sessions found, inform user and suggest starting fresh with `/feature`, `/bug`, or `/refactor`.
