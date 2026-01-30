---
description: Refactor code (extensive research → careful implementation)
agent: builder
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

Checkpoint A: Human reviews scope and impact analysis
- Review `.opencode/sessions/<task>/research.md`
- Options: [continue] [feedback] [abort]

**Phase 2: DESIGN (Architecture)**
- New structure and organization
- Migration path from old to new
- Backward compatibility strategy

**Phase 3: PLAN (Detailed)**
- Incremental refactor phases
- Compatibility guarantees
- Testing approach (old code + new code coexisting)

Checkpoint B: Human approves refactor plan
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

Checkpoint C: Review complete
- Present review findings
- Options: [commit] [test] [create-pr] [all] [manual]

### Success Criteria

- NO behavior changes - code works exactly as before
- All existing tests pass
- New structure is more maintainable
- Backward compatibility maintained throughout
- Clear migration path documented

### Cost & Timeline

- Research: 5-10 minutes (Sonnet 4.5, extensive scope analysis)
- Design: 3-5 minutes (included in plan phase)
- Plan: 10-15 minutes (Opus 4.5, detailed incremental phases)
- Build: 20-40 minutes (Sonnet 4.5, depends on refactor scope)
- Review: 5-10 minutes (Sonnet 4.5, thorough verification)
- **Total**: 40-80 minutes per refactor

### Notes

- Most complex workflow (requires careful planning and verification)
- Backward compatibility is non-negotiable
- Each phase must maintain working state
- All existing tests must pass after each phase
- Can immediately run `/test`, `/commit`, or `/pr` after completion
