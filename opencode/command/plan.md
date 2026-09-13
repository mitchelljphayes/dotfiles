---
description: Research and plan without implementing (research → plan only)
agent: pipeline
---

## Planning Workflow

Execute research and planning workflow for: **$ARGUMENTS**

This workflow stops after planning - no implementation. Use when you want to:
- Think through a feature before committing to build it
- Get a cost/complexity estimate
- Review the approach with your team
- Create specs for someone else to implement

### Workflow Phases

**Phase 1: RESEARCH (Deep)**
- Understand architecture and patterns relevant to this task
- Identify where similar functionality exists
- Find dependencies and integration points
- Discover testing conventions
- Map all constraints and compatibility considerations

**Phase 2: PLAN (Detailed)**
- Design the architecture based on research
- Create 2-5 focused implementation phases
- Each phase must be independently testable
- Document rollback strategy
- Estimate complexity and risk

Checkpoint: Plan presentation
- Review `.opencode/sessions/<task>/plan.md`
- Options: [build] [revise] [done]

This is a plan-only command. It ends at the plan presentation checkpoint — no build, review, or PR.

### Output

Session artifacts in `.opencode/sessions/<task>/`:
- `code-research.md` - Codebase analysis and findings
- `best-practices.md` - Standards and patterns research
- `plan.md` - Implementation plan with phases

### Next Steps

After planning, you can:
- `/feature` or `/bug` to implement (will use existing plan)
- `/resume` to continue from where you left off
- Share `plan.md` with your team for review
- Refine the plan with feedback
