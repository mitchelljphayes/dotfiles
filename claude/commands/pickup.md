---
description: Pick up a Linear ticket and start working on it
---

## Pick Up Ticket

Start working on Linear ticket: **$ARGUMENTS**

### Process

1. **Fetch the Ticket**
   - Get ticket details from Linear (title, description, acceptance criteria)
   - Check for linked specs or docs
   - Note any dependencies or blockers

2. **Understand the Work**
   - Summarize what needs to be done
   - Identify key requirements and acceptance criteria
   - Flag any unclear parts

3. **Research the Codebase**
   - Find relevant code areas
   - Understand existing patterns
   - Identify integration points

4. **Propose Approach**
   - Present a brief implementation plan
   - Ask for confirmation before starting

### Options After Pickup

- **[build]** — Start implementing immediately (runs `/feature` workflow)
- **[plan]** — Create detailed implementation plan first
- **[clarify]** — Ask questions about the ticket
- **[skip]** — Just show ticket details, don't start work

### After Completing Work

- `/commit` — Commit changes (references ticket ID)
- `/pr` — Create PR (links to ticket)
