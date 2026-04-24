---
description: Refactor code (extensive research → careful implementation)
---

## Refactor Workflow

Execute refactor workflow for: **$ARGUMENTS**

### Phase 1: RESEARCH (Extensive)

- ALL usages of the code being refactored
- What depends on this code? What does it depend on?
- Coupling analysis — how tightly bound is it?
- Migration path — how can we move from old to new?
- Backward compatibility concerns

**Present scope and impact analysis. Wait for my approval.**

### Phase 2: DESIGN & PLAN

- New structure and organization
- Migration path from old to new
- Backward compatibility strategy
- Incremental refactor phases
- Testing approach (old code + new code coexisting)

**Present refactor plan. Wait for my approval.**

### Phase 3: BUILD (Careful)

- Execute each phase carefully
- Maintain backward compatibility throughout
- Verify existing tests pass after each phase
- Never proceed if a phase fails — ask for guidance

### Phase 4: REVIEW (Thorough)

- Verify NO behavior changes — code works exactly as before
- Check all existing tests pass
- Verify new structure is more maintainable

**Present review findings with options: [commit] [test] [create-pr] [manual]**

### Success Criteria

- NO behavior changes — code works exactly as before
- All existing tests pass
- New structure is more maintainable
- Backward compatibility maintained throughout
- Clear migration path documented
