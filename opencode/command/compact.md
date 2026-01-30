---
description: Compact current context into structured artifact during workflow
agent: builder
---

## Context Compaction Command

Compact and save current workflow state during a running task.

### When to Use

Use this command when:
- You're mid-workflow and approaching context limits
- You want to preserve progress before taking a break
- A phase completes and you want to consolidate findings
- You want a clean context for the next phase

### What Gets Compacted

1. **Progress Summary**: What's been done so far
2. **Current Status**: Where we are in the workflow
3. **Remaining Work**: What's left to do
4. **Key Findings**: Important context for next phase
5. **Artifacts Updated**: research.md, plan.md, build-log.md, etc.

### How It Works

```
/compact
```

The orchestrator will:

1. **Detect current phase** from `.opencode/sessions/<task>/metadata.json`
2. **Summarize progress**:
   - What phases completed successfully
   - What's in progress
   - What remains
3. **Update relevant artifact**:
   - If in research: update research.md with findings so far
   - If in plan: update plan.md with designed phases
   - If in build: update build-log.md with implementation progress
4. **Update metadata.json**:
   - Current phase
   - Phases completed
   - Checkpoint status
5. **Clear local context**:
   - Reset for fresh start on next phase
   - Save comprehensive artifact for reference
6. **Present summary**:
   - Show what was saved
   - Suggest next steps

### Example Flow

```
/feature "add dark mode"
→ Research phase running...
→ [15 minutes later, context getting full]
→ /compact
→ "Research phase compacted to research.md"
→ "Findings: 12 files identified, 3 patterns discovered"
→ "Next: Review research/2025-01-11_dark-mode.md, then continue with /plan"
→ [Context reset, ready for next phase]
```

### Output

Compaction produces:

1. **Artifact updates**: .opencode/sessions/<task>/*.md files
2. **Metadata updates**: .opencode/sessions/<task>/metadata.json
3. **Summary message**: What was compacted and status
4. **Ready state**: Context cleared for continuation

### After Compaction

You can:
- **Continue in same phase**: `/feature "add dark mode"` again from where you left off
- **Review artifacts**: Check the .md files saved
- **Proceed to next phase**: Orchestrator knows where you left off
- **Take a break**: Everything is saved for later

### When Context Is Full (60%+)

The system will automatically:
1. Suggest: "Context approaching limit, consider running `/compact`"
2. Offer: Options to compact or continue
3. If continuing: Monitor and warn again at 65%
4. Max: Never exceeds 70% without explicit compaction

### Notes

- Compaction preserves all artifacts and metadata
- Non-destructive: saves everything, clears nothing from disk
- Context only: empties current context, doesn't delete files
- Resumable: next call to same workflow resumes from checkpoint
- Checkpoints: human approvals are remembered in metadata.json
