# Advanced Context Engineering for OpenCode

This directory contains the orchestration system for Advanced Context Engineering (ACE) based on Dex Horthy's "Frequent Intentional Compaction" workflow principles.

> **TL;DR**: The default agent is **Builder** — direct end-to-end implementation (inspect → edit → test → report). For structured ceremony (research → plan → build → review with checkpoints), switch to **Pipeline** via `/agent pipeline` or the pipeline commands (`/feature`, `/bug`, `/refactor`, `/plan`, `/pickup`, `/resume`, `/compact`).

## Primary Agents

| Agent | Model | When to use |
|-------|-------|-------------|
| **Builder** (default) | GPT-5.6 Sol | Direct end-to-end implementation. Understands the request, inspects/reads/searches directly, implements, runs tests/lint/typecheck, fixes introduced failures, reports. Scales planning to uncertainty/risk. Delegates only bounded work that materially improves quality or time. No stage approvals. |
| **Pipeline** | GPT-5.6 Sol | Structured orchestration with research, planning, build, and review phases, session artifacts, and human checkpoints after plan and PR. Use for complex or unfamiliar work that benefits from ceremony. Opt-in. |
| **Planner** | GLM 5.2 | Product thinking: PRDs, specs, Linear tickets, brainstorming, feature discovery. Does not implement. |

Builder is the default (`default_agent: "builder"` in `opencode.json`). Pipeline is opt-in. The two share the same model and tool surface; they differ in workflow ceremony, not capability.

## Quick Start

Builder is the default — just describe what you want built:

```
Add a dark mode toggle to the settings page
```

For structured ceremony (research → plan → build → review with checkpoints), use the opt-in pipeline commands:

### Pipeline commands (opt-in)
```bash
/feature "add dark mode toggle to settings"
/bug "login fails for gmail users with + in address"
/refactor "extract authentication module from monolith"
/pickup WAL-142
```

### Understanding code (Builder)
```
Explain how the payment processing system works
```
or `/explore "how does the payment processing system work"` (also Builder)

## How It Works

### The ACE Philosophy

**Problem**: Traditional AI coding workflows struggle with large, complex codebases.

**Solution**: "Frequent Intentional Compaction" - deliberately structure context to keep AI in the 40-60% utilization range, with humans making high-leverage decisions at research and planning stages.

### The Workflow Cycle

```
┌─────────────────────────────────────────┐
│    Your Semantic Command (opt-in)       │
│    (/feature, /bug, /refactor, /pickup) │
└──────────────────┬──────────────────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ PIPELINE         │ (orchestrator)
          │ (GPT-5.6 Sol)    │ Coordinates workflow
          └────────┬────────┘
                   │
          ┌─────────┴──────────┬──────────────┐
          │                    │              │
          ▼                    ▼              ▼
     ┌─────────┐          ┌────────┐     ┌──────┐
     │RESEARCH │          │ PLAN   │     │BUILD │
     │         │Checkpoint│        │Phases│
     └────┬────┘          └────┬───┘     └──┬───┘
          │ ✅ Approved       │ ✅ Approved │
          └──────────────────┴─────────────┴─────────┐
                                                     │
                                                     ▼
                                               ┌──────────┐
                                               │ REVIEW   │
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
- **code-research.md**: Codebase exploration findings
- **best-practices.md**: Standards and patterns research
- **plan.md**: Implementation strategy and phases
- **build-log.md**: Build progress, errors, and context compactions
- **test-results.md**: Test/lint summary
- **review.md**: Quality review findings

These are **structured documents** that become the source of truth for your project, not throwaway chat logs.

## Modes & Models

### Modes (Pipeline phases)
These phases apply to the Pipeline agent's structured workflow. Builder implements directly without these stage boundaries.

| Mode | Model | Purpose | Cost |
|------|-------|---------|------|
| orchestrate | GPT-5.6 Sol | Coordinate workflow (Pipeline) | High |
| research | GLM 5.2 | Explore codebase | Medium |
| plan | Kimi K3 | Design implementation | Medium |
| build | GLM 5.2 | Execute phases | Medium |
| review | Kimi K3 | Verify quality | Medium |

### Subagents

| Agent | Model | Purpose |
|-------|-------|---------|
| explore | GLM 5.2 | Fast file/pattern discovery |
| git-ops | MiniMax M3 | Git operations, commits |
| security-auditor | GPT-5.6 Sol | Security analysis |
| dbt-expert | GLM 5.2 | dbt project reviews |
| test-analyzer | Kimi K3 | Test failure diagnosis |

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
- Builder summarizes findings directly

### Context Compaction
```bash
/compact
```
Save current workflow state mid-phase when context is getting full (>60%).

## Human Checkpoints

The Pipeline pauses at two checkpoints only. Everything between them runs autonomously.

### Plan Checkpoint (After `/feature`, `/bug`, `/refactor`, `/pickup`)
```
Implementation plan saved to: .opencode/sessions/<task>/plan.md
[continue] [revise plan] [abort]
```
**Your job**: Approve the approach or suggest changes before build begins.

### Final Checkpoint (after build, test, review, commit/PR)
```
PR is open (if requested), summarize what shipped
[done] [follow-up]
```
**Your job**: Confirm what shipped or request follow-up.

`/plan` is a plan-only command with a single checkpoint: the plan presentation (`[build] [revise] [done]`). Builder has no checkpoints.

## Integration with Git

After any workflow, or directly with Builder:

```bash
/test    # run tests and fix failures (Builder)
/commit  # create a commit (Builder)
/pr      # create a pull request (Builder)
```

These are Builder commands. `/commit` waits for your approval before committing.

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

The system puts human review at the high-leverage point — the plan, before build begins — and a final summary after the PR, not at low-leverage points (code).

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

### Orchestrator Mode (Pipeline)
The Pipeline agent coordinates the structured workflow. It:
- Routes requests to appropriate modes
- Manages session artifacts
- Implements checkpoint logic
- Handles context compaction

Builder, the default agent, skips this ceremony and implements directly end-to-end.

### Research Mode
Deep codebase exploration using subagents for efficient discovery. It:
- Uses Explore subagent for fast file discovery
- Reads key files to understand architecture
- Maps patterns and conventions
- Produces code-research.md

### Plan Mode
Strategic architecture and implementation planning. It:
- Reads code-research.md and best-practices.md as input
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

- Use semantic commands (`/feature`, `/bug`, etc.) for structured work, or plain prompts for Builder
- Review the plan at the plan checkpoint before build begins
- Compact context proactively when approaching 60%
- Keep session artifacts for future reference
- Run tests immediately after workflow
- Use `/explore` (Builder) to understand unfamiliar code before fixing it

### ❌ DON'T

- Ignore the plan checkpoint — review the plan carefully before build
- Let context exceed 70% - compact proactively
- Skip tests before committing
- Delete session artifacts - they're documentation
- Trust build phase if research was rushed

## Troubleshooting

### Research seems incomplete
→ Provide feedback at the plan checkpoint and revise
→ Or use `/compact` and restart the research phase

### Plan disagrees with my expectations
→ Don't approve — request revisions
→ Pipeline will create a new plan based on your input

### Build keeps failing at same place
→ After 2 auto-retries, research the error
→ The `/compact` command or manual `/build` mode
→ Check if research missed something important

### Need to understand code quickly
→ Use `/explore "what does X do"` instead of full `/feature`
→ It gives you research findings without planning/implementing

## Cost

Monthly cost depends on usage and the configured providers/models in `opencode.json`. Pipeline orchestration and planning use the high-cost model; research, build, and review use mid-cost models; Builder uses the high-cost model directly. See the agents' `model:` frontmatter for the exact assignments.

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
