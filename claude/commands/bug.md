---
description: Fix a bug (focused research → plan → fix → verify)
---

## Bug Fix Workflow

Execute bug fix workflow for: **$ARGUMENTS**

### Phase 1: RESEARCH (Focused)

- Root cause analysis — where is the bug?
- How the buggy code currently works
- What behavior is expected vs. actual
- Where similar code patterns exist (regression risk)
- Existing tests related to this area

**Present root cause analysis and wait for my approval.**

### Phase 2: PLAN (Light)

- Fix approach and test cases
- Expected behavior after fix
- Regression test plan
- Document any side effects

**Present fix approach and wait for my approval.**

### Phase 3: BUILD (Focused)

- Implement the fix
- Add regression tests
- Verify existing tests still pass

### Phase 4: REVIEW (Targeted)

- Verify fix addresses root cause
- Check for similar issues elsewhere
- Verify regression tests are comprehensive

**Present review findings with options: [commit] [test] [create-pr] [manual]**

### Success Criteria

- Root cause identified and fixed
- All existing tests still pass
- New regression tests added
- No side effects or new bugs introduced
- Similar code patterns checked for same issue
