---
description: Implement a new feature (research → plan → build → review)
---

## Feature Implementation Workflow

Execute full feature implementation workflow for: **$ARGUMENTS**

### Phase 1: RESEARCH (Deep)

Before writing any code, thoroughly understand the landscape:

- Understand architecture and patterns relevant to this feature
- Identify where similar functionality exists
- Find dependencies and integration points
- Discover testing conventions
- Map all constraints and compatibility considerations

**Present your research findings and wait for my approval before proceeding.**

### Phase 2: PLAN (Detailed)

Design the implementation based on research:

- Create 2-5 focused implementation phases
- Each phase must be independently testable
- Document rollback strategy
- Plan for comprehensive testing

**Present the plan and wait for my approval before building.**

### Phase 3: BUILD (Implementation)

Execute each phase from the plan:

- After each phase: verify tests pass and success criteria met
- If tests fail: retry fix (max 2x) before asking for guidance
- Use the todo list to track progress through phases

### Phase 4: REVIEW (Comprehensive)

After building, review your own work:

- Verify changes match plan intent and research findings
- Check security, performance, and code quality
- Ensure no breaking changes to existing functionality
- Run the full test suite

**Present review findings with options: [commit] [test] [create-pr] [manual]**

### Success Criteria

- Feature implemented exactly as planned
- All tests pass (existing + new)
- Code follows codebase patterns and conventions
- No breaking changes to existing functionality
