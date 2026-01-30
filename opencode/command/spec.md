---
description: Write a technical specification
agent: planner
---

## Technical Specification

Write a technical spec for: **$ARGUMENTS**

### What's a Tech Spec?

A tech spec is more detailed than a PRD - it's the "how" document for engineers:
- Architecture decisions
- API designs
- Data models
- Integration points
- Technical trade-offs

### Process

1. **Understand Requirements**
   - Review PRD if exists
   - Clarify scope and constraints
   - Identify stakeholders

2. **Research**
   - Existing architecture
   - Similar implementations
   - Technical constraints

3. **Design**
   - High-level architecture
   - Component breakdown
   - Data flow
   - API contracts

4. **Document Trade-offs**
   - Options considered
   - Why this approach
   - What we're NOT doing

### Spec Structure

```markdown
# Technical Spec: [Feature Name]

## Overview
Brief summary of what we're building technically.

## Background
Why we're building this, link to PRD.

## Goals & Non-Goals
What this spec covers and explicitly doesn't.

## Architecture

### High-Level Design
[Diagram or description]

### Components
- Component A: purpose
- Component B: purpose

### Data Model
[Schema, types, relationships]

### API Design
[Endpoints, contracts]

## Implementation Plan
Suggested order of implementation.

## Security Considerations
Auth, data access, etc.

## Testing Strategy
How to verify this works.

## Open Questions
Things still to resolve.

## Alternatives Considered
Other approaches and why we didn't choose them.
```

### Output Options

- Save locally to `.opencode/sessions/<task>/spec.md`
- Create as Confluence page
- Both

### After Spec

- Create implementation tickets (`/project`)
- Hand off to Builder for implementation
