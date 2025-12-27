# Advanced Context Engineering for OpenCode

This directory contains the orchestration system for Advanced Context Engineering (ACE) based on Dex Horthy's "Frequent Intentional Compaction" workflow principles.

## Quick Start

### For New Features
```bash
/feature "add dark mode toggle to settings"
```

### For Bug Fixes
```bash
/bug "login fails for gmail users with + in address"
```

### For Refactoring
```bash
/refactor "extract authentication module from monolith"
```

### For Understanding Code
```bash
/explore "how does the payment processing system work"
```

## How It Works

### The ACE Philosophy

**Problem**: Traditional AI coding workflows struggle with large, complex codebases.

**Solution**: "Frequent Intentional Compaction" - deliberately structure context to keep AI in the 40-60% utilization range, with humans making high-leverage decisions at research and planning stages.

### The Workflow Cycle

```
┌─────────────────────────────────────────┐
│    Your Semantic Command                │
│    (/feature, /bug, /refactor, /explore)│
└──────────────────┬──────────────────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ ORCHESTRATE     │ (Opus 4.5)
          │ (Project Mgr)   │ Coordinates workflow
          └────────┬────────┘
                   │
         ┌─────────┴──────────┬──────────────┐
         │                    │              │
         ▼                    ▼              ▼
    ┌─────────┐          ┌────────┐     ┌──────┐
    │RESEARCH │          │ PLAN   │     │BUILD │
    │Sonnet   │(Checkpoint)│Opus   │(Phases)│Sonnet│
    │4.5      │          │4.5     │     │4.5   │
    └────┬────┘          └────┬───┘     └──┬───┘
         │ ✅ Approved       │ ✅ Approved │
         └──────────────────┴─────────────┴─────────┐
                                                    │
                                                    ▼
                                              ┌──────────┐
                                              │ REVIEW   │
                                              │(Sonnet)  │
                                              └────┬─────┘
                                                   │
                                     ┌─────────────┼─────────────┐
                                     │             │             │
                                   [test]      [commit]       [pr]
```

## Artifacts

Each workflow creates a session directory: `.opencode/sessions/<YYYY-MM-DD_HH-MM-SS_task-name>/`

### Files Created

- **metadata.json**: Workflow state, phase tracking, checkpoint history
- **research.md**: Codebase exploration findings
- **plan.md**: Implementation strategy and phases
- **build-log.md**: Build progress, errors, and context compactions
- **review.md**: Quality review findings

These are **structured documents** that become the source of truth for your project, not throwaway chat logs.

## Modes & Models

### Modes

| Mode | Model | Purpose | Cost |
|------|-------|---------|------|
| orchestrate | Opus 4.5 | Coordinate workflows | High |
| research | Sonnet 4.5 | Explore codebase | Medium |
| plan | Opus 4.5 | Design implementation | High |
| build | Sonnet 4.5 | Execute phases | Medium |
| review | Sonnet 4.5 | Verify quality | Medium |

### Subagents

| Agent | Model | Purpose |
|-------|-------|---------|
| explore | Haiku 4.5 | Fast file/pattern discovery |
| git-ops | Sonnet 4.5 | Git operations, commits, GitButler support |
| security-auditor | Sonnet 4.5 | Security analysis |
| dbt-expert | Sonnet 4.5 | dbt project reviews |
| test-analyzer | Sonnet 4.5 | Test failure diagnosis |

## Command Reference

### Feature Implementation
```bash
/feature "add OAuth2 support to login"
```
**Timeline**: 20-50 minutes
- Deep research (3-7 min)
- Detailed planning (5-10 min)
- Phase-by-phase implementation (10-30 min)
- Comprehensive review (3-5 min)

### Bug Fixes
```bash
/bug "email validation rejects valid addresses"
```
**Timeline**: 12-25 minutes
- Focused root-cause research (3-5 min)
- Light planning (2-3 min)
- Focused implementation (5-15 min)
- Targeted review (2-3 min)

### Refactoring
```bash
/refactor "split auth module into separate microservice"
```
**Timeline**: 40-80 minutes
- Extensive usage analysis (5-10 min)
- Architecture design (included in plan)
- Detailed incremental planning (10-15 min)
- Careful implementation (20-40 min)
- Thorough verification (5-10 min)

### Exploration
```bash
/explore "how does the caching layer work"
```
**Timeline**: 3-10 minutes
- Comprehensive research only
- No planning, no implementation
- Just output research.md for reference

### Context Compaction
```bash
/compact
```
Save current workflow state mid-phase when context is getting full (>60%).

## Human Checkpoints

The system pauses at critical decision points for your approval:

### Research Checkpoint (After `/feature`, `/bug`, `/refactor`)
```
Research findings saved to: .opencode/sessions/<task>/research.md
[Continue] [Provide feedback] [Abort]
```
**Your job**: Verify the research is accurate and complete

### Plan Checkpoint (After `/feature`, `/bug`, `/refactor`)
```
Implementation plan saved to: .opencode/sessions/<task>/plan.md
[Continue] [Revise plan] [Abort]
```
**Your job**: Approve the approach or suggest changes

### Build Phase Checkpoint (On failure)
```
Build failed with:
[test failures]
[Retry automatically] [Debug] [Abort]
```
**Your job**: Decide if auto-fix should retry or if human intervention needed

### Review Checkpoint (After `/feature`, `/bug`, `/refactor`)
```
Review complete: .opencode/sessions/<task>/review.md
[Run tests] [Commit] [Create PR] [All] [Manual]
```
**Your job**: Choose next steps or review manually

## Integration with Git

After any workflow completes:

```bash
# Run tests
/test

# Create a commit
/commit

# Create a pull request
/pr
```

These commands integrate with the session and reference the research/plan docs.

## Key Concepts

### Frequent Intentional Compaction (FIC)

Don't wait for context to fill. Instead:
1. Complete a logical phase
2. Save findings to artifact
3. Run `/compact` to clear context
4. Continue fresh from saved artifact

**Result**: Better quality, better use of tokens, human-in-the-loop where it matters.

### High-Leverage Review

- **Low leverage**: Reviewing 2000 lines of generated code
- **High leverage**: Reviewing 200 lines of implementation plan
- **High leverage**: Reviewing research findings before planning

The system forces human review at high-leverage points (research, plan) not low-leverage points (code).

### Context Budget

- **Target**: 40-60% context utilization per phase
- **Warning**: 60% context triggers compaction suggestion
- **Emergency**: 70% triggers hard pause for compaction
- **Never exceed**: 75% without manual override

### Session Artifacts

Each session creates permanent artifacts that:
- Serve as **specification** for what was built
- Act as **documentation** of design decisions
- Enable **resumption** if interrupted
- Facilitate **knowledge sharing** with team

## Architecture

### Orchestrator Mode
The "project manager" coordinating the workflow. It:
- Routes requests to appropriate modes
- Manages session artifacts
- Implements checkpoint logic
- Handles context compaction

### Research Mode
Deep codebase exploration using subagents for efficient discovery. It:
- Uses Explore subagent for fast file discovery
- Reads key files to understand architecture
- Maps patterns and conventions
- Produces research.md

### Plan Mode
Strategic architecture and implementation planning. It:
- Reads research.md as input
- Designs phase-based approach
- Documents rollback strategy
- Produces plan.md (200-400 lines)

### Build Mode
Phase-by-phase implementation execution. It:
- Follows plan.md exactly
- Tests after each phase
- Compacts progress when needed
- Retries failures (max 2x)

### Review Mode
Quality verification and specialized audits. It:
- Reads research/plan for context
- Delegates to specialized agents
- Verifies plan intent achieved
- Produces review.md

## Best Practices

### ✅ DO

- Use semantic commands (`/feature`, `/bug`, etc.) not generic chat
- Let research/plan checkpoints catch misunderstandings early
- Compact context proactively when approaching 60%
- Keep research/plan artifacts for future reference
- Run tests immediately after workflow
- Use `/explore` to understand unfamiliar code before fixing it

### ❌ DON'T

- Ignore checkpoints - review research and plans carefully
- Let context exceed 70% - compact proactively
- Skip tests before committing
- Delete session artifacts - they're documentation
- Use generic modes when semantic commands are available
- Trust build phase if research was rushed

## Troubleshooting

### Research seems incomplete
→ Provide feedback at checkpoint and restart
→ Or use `/compact` and restart research phase

### Plan disagrees with my expectations
→ Don't approve - provide feedback
→ Orchestrator will create new plan based on your input

### Build keeps failing at same place
→ After 2 auto-retries, research the error
→ The `/compact` command or manual `/build` mode
→ Check if research missed something important

### Need to understand code quickly
→ Use `/explore "what does X do"` instead of full `/feature`
→ It gives you research.md without planning/implementing

## Cost

Monthly cost depends on usage:
- **Light** (1-2 features/week): ~$40/month
- **Medium** (5-10 features/week): ~$120/month  
- **Heavy** (20+ features/week): ~$300-400/month

Costs are for Opus (orchestrate, plan) + Sonnet (research, build, review) models. Haiku subagent exploration is negligible.

## Philosophy

> "The only lever you have to improve AI output is the quality of inputs. So obsess over context management, not model intelligence."
> — Dex Horthy

This system is built on:
1. **Context is sacred** - manage it religiously
2. **Humans decide** - AI recommends, humans approve
3. **Artifacts matter** - specs > code comments
4. **Phases work** - research → plan → implement
5. **Compaction scales** - FIC works for projects of any size

## Resources

- Read Dex's full essay: [Advanced Context Engineering for Coding Agents](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)
- Watch the Y Combinator talk: https://hlyr.dev/ace
- Learn about 12-factor agents: https://hlyr.dev/12fa

## Questions?

For issues with opencode or this ACE implementation, see:
- OpenCode docs: https://opencode.ai/docs
- GitHub issues: https://github.com/sst/opencode/issues
- OpenCode feedback: https://github.com/sst/opencode/issues/new

## GitButler Integration

OpenCode has first-class support for GitButler's virtual branch workflow.

### GitButler Commands

| Command | Description |
|---------|-------------|
| `/gb-status` | Show virtual branches and unassigned changes |
| `/gb-commit` | Commit changes to a specific virtual branch |
| `/gb-branch` | Create parallel or stacked branches |
| `/gb-assign` | Assign file changes to branches |

### Standard vs GitButler

The `/commit` and `/pr` commands auto-detect GitButler repositories and adapt:

**Standard Git:**
```bash
/commit  → git add + git commit
/pr      → gh pr create
```

**GitButler:**
```bash
/commit  → but commit (to virtual branch)
/pr      → but push (creates stacked PRs)
```

### Virtual Branch Workflow

```
┌─────────────────────────────────────────┐
│           Unassigned Changes            │
│  (files not yet assigned to a branch)   │
└──────────────────┬──────────────────────┘
                   │ /gb-assign
        ┌──────────┴──────────┐
        ▼                     ▼
┌───────────────┐     ┌───────────────┐
│ feature-auth  │     │ feature-api   │
│ (parallel)    │     │ (parallel)    │
└───────┬───────┘     └───────────────┘
        │ stacked on
        ▼
┌───────────────┐
│ feature-ui    │
│ (stacked)     │
└───────────────┘
```

### Key Concepts

- **Virtual Branches**: Multiple branches active simultaneously in your workspace
- **Parallel Branches**: Independent work streams, merge in any order
- **Stacked Branches**: Dependent branches that must merge in sequence
- **Rubbing**: Assigning file changes to specific branches before committing
- **Unassigned Changes**: Changes not yet assigned to any branch

### Installation

```bash
# Install via Homebrew
brew install gitbutler

# Or install CLI from GitButler desktop app settings
```
