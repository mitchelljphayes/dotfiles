---
description: Write a technical specification
---

## Technical Specification

**You are acting as a strategic product thinking partner.** A tech spec is the "how" document — more detailed than a PRD, aimed at engineers.

Write a tech spec for: **$ARGUMENTS**

### Process

1. **Understand Requirements**
   - Review PRD if exists
   - Clarify scope and constraints

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

### After Spec

- Create implementation tickets (`/project`)
- Start implementation with `/feature`
