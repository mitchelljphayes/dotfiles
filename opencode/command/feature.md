---
description: Implement a new feature (research → plan → build → review)
agent: builder
---

## Feature Implementation Workflow

Execute full feature implementation workflow for: **$ARGUMENTS**

### Workflow Phases

**Phase 1: RESEARCH (Deep)**
- Understand architecture and patterns relevant to this feature
- Identify where similar functionality exists
- Find dependencies and integration points
- Discover testing conventions
- Map all constraints and compatibility considerations

Checkpoint A: Human reviews research
- Review `.opencode/sessions/<task>/research.md`
- Options: [continue] [feedback] [abort]

**Phase 2: PLAN (Detailed)**
- Design the feature architecture based on research
- Create 2-5 focused implementation phases
- Each phase must be independently testable
- Document rollback strategy
- Plan for comprehensive testing

Checkpoint B: Human approves plan
- Review `.opencode/sessions/<task>/plan.md`
- Options: [continue] [revise] [abort]

**Phase 3: BUILD (Implementation)**
- Execute each phase from the plan
- After each phase: verify tests pass and success criteria met
- If tests fail: auto-retry (max 2x) before escalating
- Monitor context usage

**Phase 4: REVIEW (Comprehensive)**
- Verify changes match plan intent and research findings
- Check security, performance, and code quality
- Delegate to specialized subagents as needed
- Document findings

Checkpoint C: Review complete
- Present review findings
- Options: [commit] [test] [create-pr] [all] [manual]

### Success Criteria

- Feature implemented exactly as planned
- All tests pass (existing + new)
- Code follows codebase patterns and conventions
- No breaking changes to existing functionality
- Rollback strategy documented and verified

### Cost & Timeline

- Research: 3-7 minutes (Sonnet 4.5)
- Plan: 5-10 minutes (Opus 4.5)
- Build: 10-30 minutes (Sonnet 4.5, depends on feature complexity)
- Review: 3-5 minutes (Sonnet 4.5)
- **Total**: 20-50 minutes per feature

### Notes

- You'll be prompted at checkpoints to review and approve progress
- Each phase creates artifacts in `.opencode/sessions/<task>/`
- If build phase fails, you'll be asked for guidance before retry
- After completion, can immediately run `/test`, `/commit`, or `/pr`
