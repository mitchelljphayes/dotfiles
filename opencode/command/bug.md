---
description: Fix a bug (focused research → plan → fix → verify)
agent: orchestrate
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

Checkpoint A: Human reviews root cause analysis
- Review `.opencode/sessions/<task>/research.md`
- Options: [continue] [feedback] [abort]

**Phase 2: PLAN (Light)**
- Fix approach and test cases
- Expected behavior after fix
- Regression test plan
- Document any side effects

Checkpoint B: Human approves fix approach
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

Checkpoint C: Review complete
- Present review findings
- Options: [commit] [test] [create-pr] [all] [manual]

### Success Criteria

- Root cause identified and fixed
- All existing tests still pass
- New regression tests added
- No side effects or new bugs introduced
- Similar code patterns checked for same issue

### Cost & Timeline

- Research: 3-5 minutes (Sonnet 4.5)
- Plan: 2-3 minutes (Opus 4.5)
- Build: 5-15 minutes (Sonnet 4.5, depends on fix complexity)
- Review: 2-3 minutes (Sonnet 4.5)
- **Total**: 12-25 minutes per bug fix

### Notes

- Lighter workflow than features (faster research and planning)
- Focus is on root cause and preventing regressions
- Can immediately run `/test`, `/commit`, or `/pr` after completion
