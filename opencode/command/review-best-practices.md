---
description: Review codebase practices and research industry best practices
agent: orchestrate
---

## Review Best Practices Workflow

Execute best practices review for: **$ARGUMENTS**

### Workflow Phases

**Phase 1: INTERNAL REVIEW (Codebase Analysis)**
- Analyze current practices in the specified area of the codebase
- Identify patterns, conventions, and approaches being used
- Note strengths and potential gaps in current implementation
- Document specific file locations and code examples
- Understand the context and constraints of current approach

Output: Internal findings section of best-practices-review.md

**Phase 2: EXTERNAL RESEARCH (Web Best Practices)**
- Research industry best practices for this area/technology/pattern
- Fetch authoritative sources:
  - Official documentation and style guides
  - Well-known blog posts and tutorials
  - Framework/library recommendations
  - Security guidelines (if applicable)
- Identify common patterns and anti-patterns
- Note emerging trends and modern recommendations
- Gather concrete examples from well-regarded projects

Output: External research section of best-practices-review.md

**Phase 3: SYNTHESIS (Compare & Recommend)**
- Compare internal practices against industry standards
- Identify areas of alignment (what we're doing well)
- Identify gaps (where we could improve)
- Prioritize recommendations by:
  - Impact (high/medium/low)
  - Effort (quick wins vs. major refactors)
  - Risk (security, reliability, maintainability)
- Provide actionable improvement suggestions with specific steps
- Reference both internal code locations and external resources

Output: `.opencode/sessions/<task>/best-practices-review.md`

### Output Document Structure

```markdown
# Best Practices Review: [Topic]

## Executive Summary
[2-3 sentence overview of findings and top recommendations]

## Current State Analysis
### Patterns Found
- [Pattern 1]: `file:line` - description
- [Pattern 2]: `file:line` - description

### Strengths
- [What we're doing well]

### Areas for Improvement
- [Potential gaps identified]

## Industry Best Practices
### Sources Consulted
- [Source 1] - [URL or reference]
- [Source 2] - [URL or reference]

### Key Recommendations from Industry
1. [Best practice 1]
2. [Best practice 2]
3. [Best practice 3]

### Common Anti-patterns to Avoid
- [Anti-pattern 1]
- [Anti-pattern 2]

## Gap Analysis
| Area | Current State | Best Practice | Gap Level |
|------|---------------|---------------|-----------|
| X    | How we do it  | How to do it  | High/Med/Low |

## Recommendations
### High Priority (Quick Wins)
1. **[Recommendation]**
   - Why: [Rationale]
   - How: [Specific steps]
   - Files: `path/to/file.ts`

### Medium Priority (Planned Improvements)
1. **[Recommendation]**
   - Why: [Rationale]
   - How: [Specific steps]

### Low Priority (Future Considerations)
1. **[Recommendation]**

## Next Steps
- [ ] [Actionable item 1]
- [ ] [Actionable item 2]
- [ ] [Actionable item 3]

## References
- [Link to official docs]
- [Link to style guide]
- [Internal file references]
```

### Use Cases

- "Review our testing practices and research best practices for pytest"
- "Review authentication implementation against security best practices"
- "Review our API design and research REST/GraphQL best practices"
- "Review error handling patterns and research best practices for TypeScript"
- "Review database query patterns and research SQL optimization best practices"
- "Review our CI/CD pipeline and research DevOps best practices"
- "Review logging and monitoring and research observability best practices"
- "Review our component architecture and research React best practices"

### What You'll Get

- Comprehensive analysis of current codebase practices
- Curated industry best practices from authoritative sources
- Side-by-side comparison of current vs. recommended approaches
- Prioritized, actionable recommendations
- Specific file references for both problems and solutions
- A document that can feed directly into `/refactor` or `/feature` commands

### Cost & Timeline

- Internal Review: 3-5 minutes (Sonnet 4.5)
- External Research: 3-5 minutes (Sonnet 4.5 with webfetch)
- Synthesis: 2-3 minutes (Sonnet 4.5)
- **Total**: 8-13 minutes per review

### Notes

- This is a research-only command - no code changes are made
- The output document is designed to inform future refactoring decisions
- For complex topics, consider breaking into multiple focused reviews
- External research focuses on authoritative, well-established sources
- Can be run multiple times on different aspects of the same system
