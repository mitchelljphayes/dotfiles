---
description: Research a topic without implementation (research only)
agent: orchestrate
---

## Exploration Workflow

Execute exploration workflow to understand: **$ARGUMENTS**

### Workflow Phase

**Phase 1: RESEARCH (Comprehensive)**
- Understand system/feature/codebase section
- Find all relevant files
- Understand architecture and data flow
- Identify key patterns and conventions
- Document how it integrates with rest of system

### Output

Generates `.opencode/sessions/<task>/research.md` with comprehensive findings

### Advantages

- No implementation, just understanding
- Quick way to learn a new area of the codebase
- Great preparation before starting a feature
- Can be used to plan future work
- Useful for onboarding to new systems

### Use Cases

- "Explore the authentication system"
- "Explore how database migrations work"
- "Explore the payment processing flow"
- "Explore the admin dashboard structure"
- "Explore background job processing"

### What You'll Get

- Complete list of relevant files
- Architecture and data flow diagrams
- Key functions and classes
- Design patterns used
- Entry points and integration points
- Testing approach
- Any constraints or gotchas

### Notes

- No checkpoint delays - just research and output
- Takes 3-10 minutes depending on scope
- Research document is yours to keep and reference
- Can feed into `/feature` or `/bug` commands later
