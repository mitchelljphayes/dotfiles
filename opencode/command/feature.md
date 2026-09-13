---
description: Implement a new feature (research → plan → build → review)
agent: pipeline
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

**Phase 2: PLAN (Detailed)**
- Design the feature architecture based on research
- Create 2-5 focused implementation phases
- Each phase must be independently testable
- Document rollback strategy
- Plan for comprehensive testing

Checkpoint A: Human approves plan before build
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

Between Checkpoint A and the final summary, the pipeline runs autonomously: build, test, review, and commit proceed without further approval prompts.

Checkpoint B: Final summary
- Confirm the PR (if opened) is up, summarize what shipped
- Options: [done] [follow-up]

### Success Criteria

- Feature implemented exactly as planned
- All tests pass (existing + new)
- Code follows codebase patterns and conventions
- No breaking changes to existing functionality
- Rollback strategy documented and verified

### Notes

- Two checkpoints only: plan approval (before build) and final ship summary
- Each phase creates artifacts in `.opencode/sessions/<task>/`
- If build phase fails after retries, escalate for guidance
