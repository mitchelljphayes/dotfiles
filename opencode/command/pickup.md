---
description: Pick up a Linear ticket and start working on it
agent: pipeline
---

## Pick Up Ticket

Pick up Linear ticket: **$ARGUMENTS**

### Process

1. **Fetch the Ticket**
   - Get ticket details from Linear (title, description, acceptance criteria)
   - Check for linked specs or Confluence docs
   - Note any dependencies or blockers

2. **Create Session**
   - Create a session directory including the ticket ID in the slug

3. **Run the Full Pipeline**, driven by the ticket's acceptance criteria:
   - **Research** questions derived from the acceptance criteria and description
   - **Plan** the implementation; review checks against the acceptance criteria specifically
   - Pass ticket context (ID, title, ACs) to every subagent in the session

Checkpoint A: Human approves plan before build
- Review `.opencode/sessions/<task>/plan.md`
- Options: [continue] [revise] [abort]

4. **Build, test, review** — the pipeline runs autonomously between checkpoints
5. **Commit** with the ticket ID in the message: `feat(auth): add OAuth login [WAL-142]`
6. **PR** linked to the ticket (if requested)

Checkpoint B: Final summary
- Confirm the PR (if opened) is up and linked to the ticket, summarize what shipped
- Options: [done] [follow-up]

### Usage

```bash
/pickup LIN-123
/pickup WAL-142
```

### Notes

- Two checkpoints only: plan approval and final ship summary
- Acceptance criteria drive research questions and review verification
- Ticket ID is included in commit messages and PR links
