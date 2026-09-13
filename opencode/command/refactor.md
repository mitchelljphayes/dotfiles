---
description: Refactor code (extensive research → careful implementation)
agent: pipeline
---

## Refactor Workflow

Execute refactor workflow for: **$ARGUMENTS**

### Workflow Phases

**Phase 1: RESEARCH (Extensive)**
- ALL usages of the code being refactored
- What depends on this code? What does it depend on?
- Coupling analysis - how tightly bound is it?
- Migration path - how can we move from old to new?
- Backward compatibility concerns

**Phase 2: DESIGN (Architecture)**
- New structure and organization
- Migration path from old to new
- Backward compatibility strategy

**Phase 3: PLAN (Detailed)**
- Incremental refactor phases
- Compatibility guarantees
- Testing approach (old code + new code coexisting)

Checkpoint A: Human approves refactor plan before build
- Review `.opencode/sessions/<task>/plan.md`
- Options: [continue] [revise] [abort]

**Phase 4: BUILD (Careful)**
- Execute each phase carefully
- Maintain backward compatibility
- Verify existing tests pass after each phase
- Never proceed without fix if phase fails

**Phase 5: REVIEW (Thorough)**
- Verify NO behavior changes
- Check all existing tests pass
- Verify new structure is maintainable

Between Checkpoint A and the final summary, the pipeline runs autonomously: build, test, review, and commit proceed without further approval prompts.

Checkpoint B: Final summary
- Confirm the PR (if opened) is up, summarize what shipped
- Options: [done] [follow-up]

### Success Criteria

- NO behavior changes - code works exactly as before
- All existing tests pass
- New structure is more maintainable
- Backward compatibility maintained throughout
- Clear migration path documented

### Notes

- Most complex workflow (requires careful planning and verification)
- Two checkpoints only: plan approval and final ship summary
- Backward compatibility is non-negotiable
- Each phase must maintain working state
- All existing tests must pass after each phase
