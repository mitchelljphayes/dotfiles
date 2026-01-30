---
description: Create a PRD (Product Requirements Document)
agent: planner
---

## PRD Creation

Create a PRD for: **$ARGUMENTS**

### Process

1. **Understand the Feature**
   - What problem does this solve?
   - Who is the user?
   - What's the desired outcome?

2. **Research (if needed)**
   - Look at existing patterns in the codebase
   - Check for similar features
   - Identify technical constraints

3. **Draft the PRD**
   Structure:
   - Overview (2-3 sentences)
   - Problem Statement
   - Proposed Solution
   - User Stories
   - Functional Requirements
   - Non-functional Requirements
   - Out of Scope
   - Open Questions
   - Success Metrics

4. **Review with User**
   - Present draft
   - Gather feedback
   - Iterate

### Output Options

After PRD is drafted:
- Save locally to `.opencode/sessions/<task>/prd.md`
- Create as Confluence page
- Both

### Next Steps

Once PRD is approved:
- Create Linear project with `/project`
- Create individual tickets with `/ticket`
- Hand off to Builder for implementation
