---
description: Fix a bug (focused research → plan → fix → verify)
agent: pipeline
---

## Bug Fix Workflow

Execute bug fix workflow for: **$ARGUMENTS**

### Workflow Phases

**Phase 1: RESEARCH (Focused)**
- Root cause analysis - where is the bug?
- How the buggy code currently works
- What behavior is expected vs. actual
- Where similar code patterns exist (regression risk)
- Existing tests related to this area

**Phase 2: PLAN (Light)**
- Fix approach and test cases
- Expected behavior after fix
- Regression test plan
- Document any side effects

Checkpoint A: Human approves fix approach before build
- Review `.opencode/sessions/<task>/plan.md`
- Options: [continue] [revise] [abort]

**Phase 3: BUILD (Focused)**
- Implement the fix
- Add regression tests
- Verify existing tests still pass

**Phase 4: REVIEW (Targeted)**
- Verify fix addresses root cause
- Check for similar issues elsewhere
- Verify regression tests are comprehensive

Between Checkpoint A and the final summary, the pipeline runs autonomously: build, test, review, and commit proceed without further approval prompts.

Checkpoint B: Final summary
- Confirm the PR (if opened) is up, summarize what shipped
- Options: [done] [follow-up]

### Success Criteria

- Root cause identified and fixed
- All existing tests still pass
- New regression tests added
- No side effects or new bugs introduced
- Similar code patterns checked for same issue

### Notes

- Lighter workflow than features (faster research and planning)
- Two checkpoints only: plan approval and final ship summary
- Focus is on root cause and preventing regressions
