# Global Agent Instructions

Canonical global instructions for coding agents across all projects on this machine. Edit `~/.dotfiles/AGENTS.md`; `CLAUDE.md` and the global Codex and Claude instruction paths link to this file. Follow project-specific instructions within their scope.

## Core Principles

- **Be concise**: Keep responses short and to the point unless detail is requested
- **Follow conventions**: Always examine existing code patterns before making changes
- **Security first**: Never expose secrets, use environment variables for sensitive data
- **Evidence-driven**: Run tests and linting relevant to the change before completing tasks
- **Clear code and documentation**: Express behaviour clearly in code; document contracts, reasoning, and non-obvious constraints

## Development Environment

### Python

- Always execute Python using `uv` instead of `python` or `python3`
- Use `uv run` for running Python scripts
- Use `uv pip` for package management
- Add type hints to all Python code

### Shell & Tools

- User's default shell is zsh (Claude Code runs in bash)
- Dotfiles are managed via `~/.dotfiles/` with `install.sh`
- Shell aliases are defined in `~/.dotfiles/shell/aliases.sh`
- Use `rg` (ripgrep) instead of `grep` for searching
- Use `eza` for better file listings when available
- Use `bat` for syntax-highlighted file viewing
- `zoxide` (`z`) is available in user's terminal but NOT in Claude Code sessions

## Code Quality Standards

### General

- Prefer explicit over implicit
- Use descriptive variable and function names
- Keep functions cohesive; extract when a boundary improves understanding, not merely to reduce length
- Add type hints in Python code
- Follow existing code style in each project
- Handle errors gracefully with proper error messages

### Git Commits

- Before each commit, update the CHANGELOG.md if there is one
- Use conventional commit format when appropriate
- Keep commit messages concise but descriptive
- Separate subject from body with a blank line
- Use present tense ("Add feature" not "Added feature")
- Always check git status and diff before committing

### Security

- Never commit sensitive information (API keys, passwords, tokens)
- Always check for exposed secrets before committing
- Use environment variables for sensitive configuration
- Set restrictive permissions (600) on sensitive files
- Validate all inputs properly
- Follow principle of least privilege

### Performance

- Consider performance implications of code changes
- Use appropriate data structures and algorithms
- Avoid premature optimization
- Profile code when performance issues are suspected

## File Management

- Always use absolute paths when reading/writing files
- Check if directories exist before creating files in them
- Prefer editing existing files over creating new ones
- Never create documentation files unless explicitly requested

## Testing Strategy

- Ensure you are integrating into the existing testing environment
- Don't create new shell scripts as testing harnesses unless necessary
- Run relevant existing tests to establish a baseline when changing behaviour
- Check for linting/formatting tools (ruff, black, prettier, etc.)
- Run type checking if available (mypy, pyright)
- Write tests for new functionality when appropriate
- Verify changes don't break existing functionality

## Project Discovery

### Initial Analysis

- Always examine project structure first
- Look for README files for project conventions
- Check package.json, Cargo.toml, pyproject.toml for dependencies
- Identify testing frameworks and build tools
- Look for existing CLAUDE.md, AGENTS.md, or .cursor/rules files

### File Patterns to Check

- `README.md` — Project overview and setup instructions
- `CONTRIBUTING.md` — Contribution guidelines
- `package.json` — Node.js dependencies and scripts
- `pyproject.toml` — Python project configuration
- `Cargo.toml` — Rust project configuration
- `.env.example` — Environment variable examples
- `Makefile` — Build and development commands
- `.github/workflows/` — CI/CD configuration

## Git Branch Naming

- Use feature branch names based on issue identifiers, not usernames
- Format: `<issue-id>-<short-description>` (e.g., `wal-136-implement-auth-login`)
- Do NOT include usernames or personal identifiers in branch names
- When Linear provides a `gitBranchName`, extract the issue ID and create a cleaner name

## Git Branch Creation (IMPORTANT)

When creating branches from a base branch (like `develop` or `main`):

1. **NEVER** use `git checkout -b <branch> origin/develop` — this sets up tracking to the remote and `git push` will push to develop!
2. **ALWAYS** use this pattern:
   ```bash
   git fetch origin
   git switch --no-track -c <branch-name> origin/develop
   git push -u origin <branch-name>
   ```

### Protected Branches

- **NEVER push directly to `main` or `develop`** — always create a PR
- Verify with `git branch -vv` that your branch is NOT tracking `origin/main` or `origin/develop` before pushing
- When creating a new branch, use `git switch --no-track -c <branch-name> origin/develop`

## Linear Defaults

### Issue Creation

- When creating Linear issues, set the initial status to **Backlog** (not Triage or To Do)
- Use the status ID `7c3b083e-5264-4ede-938c-263593a2bb2e` for the Data Team Backlog status (the name "Backlog" is ambiguous with "Blocked" since both are backlog-type statuses)
- Only use "To Do" or other statuses when explicitly requested

## Communication Style

- Answer directly without unnecessary preamble
- Use markdown formatting for code and structure
- Include file paths with line numbers when referencing code (e.g., `src/utils.py:42`)
- Explain complex changes or non-obvious decisions
- Ask for clarification when requirements are ambiguous

## macOS Specific

- Be aware of macOS-specific paths and commands
- Use `brew` for package management suggestions
- Account for case-insensitive filesystem by default

## Important Reminders

- Think before acting — understand the codebase first
- Check for project-specific AGENTS.md and CLAUDE.md files (they override global guidance within their scope)
- Look for .env.example files for environment setup
- Be mindful of backwards compatibility
- Consider the impact of changes on the entire system
- Always verify that changes work as expected before completing tasks

## Canonical Coding Principles — v1

Synthesised from *A Philosophy of Software Design*, *Clean Code*, and *The Pragmatic Programmer*. These are decision criteria, not mechanical rules.

Write correct code that minimises the knowledge required to understand, use, and safely change it.

### P1. Optimise for understanding

Use consistent domain language, precise names, and straightforward control flow. Make important behaviour visible where readers need it. Prefer clarity over cleverness or brevity.

### P2. Make interfaces simpler than implementations

Expose cohesive operations that hide meaningful implementation decisions. Callers should be able to use an interface correctly without inspecting its internals. Keep public surfaces deliberate and small.

### P3. Keep related knowledge together

Place code that shares invariants or changes for the same reason together. Separate independently changing concerns. Extract functions and modules when the resulting boundary improves understanding; avoid fragmentation into helpers that must be read together.

### P4. Make contracts explicit

Specify valid inputs, outputs, invariants, failure modes, and relevant side effects. Use types and construction rules to exclude invalid states where practical. Validate external data at system boundaries.

### P5. Give each rule an authoritative home

Centralise shared business rules and facts. Introduce an abstraction when it captures a stable concept. Allow similar code to remain separate when its meaning or likely evolution differs.

### P6. Make state and effects easy to follow

Keep mutation local, dependencies visible, and resource ownership clear. Separate calculations from external interactions when that improves reasoning or testing. Avoid hidden ordering requirements.

### P7. Design failure behaviour deliberately

Distinguish expected failures from broken assumptions. Recover only where a meaningful recovery is possible; otherwise propagate useful context. Preserve invariants and release resources on every path. Never disguise failure as success.

### P8. Explain what the code cannot express

Document intent, contracts, units, constraints, and consequential tradeoffs. Explain surprising algorithms or decisions. Keep documentation near the relevant code and update it with behavioural changes.

### P9. Build the simplest sufficient design

Meet established requirements without speculative layers, options, or dependencies. Consider alternative designs for consequential decisions. Prefer choices that remain inexpensive to revise.

### P10. Verify observable behaviour

Test contracts, important boundaries, failure paths, and invariants. Reproduce bugs with regression tests when practical. Keep tests resilient to internal refactoring, and run the checks relevant to the change.

### P11. Improve through evidence

Work in reviewable increments. Address design friction encountered within scope. Automate repeatable checks. Measure suspected performance problems before adding complexity, then verify the improvement.

### Applying the principles

Honour explicit requirements and established project constraints. When principles conflict, choose the design that preserves correctness and reduces the total burden on callers and maintainers.

When proposing a design or reviewing code, explain the concrete reasoning and consequences in plain language. Reference principle IDs only when explicitly requested or when they materially clarify a tradeoff. Avoid changes justified only by stylistic preference.

### Python specialisation

Apply the canonical principles using idiomatic Python.

- **P1–P3:** Prefer straightforward functions and modules. Introduce classes when they clarify state, invariants, or behaviour. Use composition before building inheritance hierarchies.
- **P1:** Use comprehensions for simple transformations; use ordinary loops when branching or side effects make the operation harder to read.
- **P4:** Annotate public interfaces and non-obvious data structures. Use dataclasses or other explicit models where they clarify domain meaning. Type hints do not replace runtime validation of external inputs. Retain the existing requirement to add type hints to all Python code.
- **P2, P9:** Introduce protocols or abstract interfaces when they clarify a real substitution boundary. Avoid creating an interface for every concrete implementation.
- **P6:** Pass dependencies explicitly. Avoid mutable defaults, hidden global state, and surprising import-time work. Use context managers for resource lifetimes.
- **P7:** Catch specific exceptions where recovery or translation is meaningful. Preserve causes when translating exceptions. Use None for meaningful absence; do not silently convert errors into empty values.
- **P8:** Document behaviour, constraints, side effects, and exceptions that callers need to understand. Avoid repeating obvious signatures.
- **P10–P11:** Follow the project's formatter, linter, type checker, and test conventions. Test behaviour through stable interfaces; substitute external dependencies where necessary.

### Rust specialisation

Apply the canonical principles using idiomatic Rust.

- **P2–P4:** Use modules, private fields, constructors, enums, and newtypes to express domain boundaries and protect invariants. Keep public APIs intentional.
- **P4, P7:** Use Option for meaningful absence and Result for recoverable failure. Provide errors that callers can interpret or report usefully. Reserve panics for broken assumptions; justify unwrap or expect through an evident invariant.
- **P6:** Choose ownership deliberately. Borrow when ownership remains with the caller; accept owned values when responsibility transfers. Keep mutable borrows and lock scopes narrow.
- **P6, P9:** Start with simple ownership. Introduce reference counting or interior mutability for a concrete sharing requirement. Neither blanket cloning nor elaborate lifetime machinery is a default solution.
- **P2, P9:** Use traits for meaningful shared behaviour or substitution. Prefer concrete types when generics or dynamic dispatch add complexity without a current benefit.
- **P1:** Use pattern matching and iterator chains when they clarify the operation. Prefer a direct loop when it makes state changes or control flow easier to follow.
- **P7–P8:** Use resource lifetimes and Drop for cleanup; expose fallible finalisation explicitly when failure matters. Document panic conditions and any unsafe preconditions. Keep unsafe code narrowly contained with an explicit safety argument.
- **P10–P11:** Use the project's formatting, Clippy, and test checks. Test error paths and domain invariants. Measure allocation, copying, and contention before complicating the implementation.

## Dotfiles Repository Guidance

The following section applies only when working on `~/.dotfiles/` or its managed configuration files. Its build commands, directory structure, and formatting rules are not global project defaults.

### Build/Test/Lint Commands
- **Install dotfiles**: `./install.sh` (bash script that creates symlinks)
- **Python linting**: `ruff check .` (configured in ruff.toml, target Python 3.11)
- **Python formatting**: `ruff format .` (line-length: 88, matches Black)
- **SQL linting**: `sqlfluff lint` (postgres dialect, trailing commas required)
- **Python execution**: Use `uv run` instead of `python` or `python3`

### Code Style Guidelines
- **Python**: Follow ruff/black formatting (line-length 88), always add type hints, descriptive names
- **Imports**: Standard library first, third-party, then local imports (ruff handles sorting)
- **Shell scripts**: Use `#!/usr/bin/env bash`, `set -e` for error handling, check exit codes
- **YAML**: 2-space indentation
- **Config files**: Prefer TOML format, follow existing patterns in repo
- **Naming**: Prefer explicit over implicit, use descriptive variable/function names

### Repository Structure & Conventions

This is the canonical source for ALL dotfiles and tool configs on this machine.
Everything lives in `~/.dotfiles/` and is symlinked to its destination by `install.sh`.

**Always edit files in `~/.dotfiles/`, not the symlinked locations.**

Key directories:
- `shell/` — Shell configs split by function (aliases.sh, functions.sh, env.sh, etc.)
- `nvim/` — Neovim config (Lua)
- `opencode/` — OpenCode config, MCP servers, agents, commands, skills
- `Claude/` — Claude Desktop settings
- `claude/` — Claude Code settings, commands, agents, and output styles
- `codex/` — Codex user configuration (`config.toml`); runtime data remains in `~/.codex/`
- `agents/` — Agent skills shared by Claude Code and OpenCode
- `ghostty/`, `alacritty/`, `wezterm/` — Terminal emulators
- `tmux/` — Tmux config
- `zed/` — Zed editor settings
- `nu/` — Nushell config

### Symlink Mappings

Managed by `install.sh`. Run `./install` to apply.

| Repo Path | Symlinked To |
|-----------|--------------|
| `shell/` | `~/.shell` |
| `zsh/` | `~/.zsh` |
| `zshrc` | `~/.zshrc` |
| `bash/` | `~/.bash` |
| `nvim/` | `~/.config/nvim` |
| `opencode/` | `~/.config/opencode` |
| `Claude/` | `~/.config/Claude` |
| `ghostty/` | `~/.config/ghostty` |
| `alacritty/` | `~/.config/alacritty` |
| `wezterm/` | `~/.config/wezterm` |
| `tmux/` | `~/.config/tmux` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `zed/keymap.json` | `~/.config/zed/keymap.json` |
| `1Password/` | `~/.config/1Password` |
| `starship.toml` | `~/.config/starship.toml` |
| `nu/` | `~/Library/Application Support/nushell` (macOS) |
| `gitconfig.toml` | `~/.gitconfig` |
| `ssh/config` | `~/.ssh/config` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `AGENTS.md` | `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` |
| `CLAUDE.md` | Relative symlink to `AGENTS.md` in this repository |
| `codex/config.toml` | `~/.codex/config.toml` |
| `agents/` | `~/.agents` |
| `agents/skills/` | `~/.claude/skills` (via ~/.agents symlink) |

To add new configs: create the directory/file in this repo, add a `link` entry to `install.sh`, run `./install`.

### MCP Server Configuration

#### Claude Code
The main `~/.claude.json` is NOT tracked — it contains API secrets for MCP servers.
Only `settings.json` (UI preferences) is symlinked. MCP servers with secrets are
configured manually with `claude mcp add`.

#### OpenCode
OpenCode config lives at `~/.dotfiles/opencode/` and is symlinked to `~/.config/opencode/`.
- **`opencode.json`** — Main config including MCP server definitions
- **`agent/`** — Agent definitions (research, build, review, etc.)
- **`command/`** — Slash commands (/feature, /bug, /plan, etc.)
- **`skills/`** — OpenCode-specific skills

MCP servers in OpenCode use `{env:VAR_NAME}` syntax for secrets in headers.
Secrets are managed in `~/.dotfiles/shell/secrets.sh` and cached via launchctl.

#### Secrets Management
All 1Password secrets are defined in `~/.dotfiles/shell/secrets.sh`:
- Sourced from `.zprofile` at login shell startup
- Fetched from 1Password (auth once per macOS session)
- Cached via `launchctl setenv` so all processes inherit them
- To add a new secret, add an entry to the `SECRETS` array in `secrets.sh`

### Agent Skills

Global skills for Claude Code, OpenCode, and other skills-compatible agents are stored in `~/.dotfiles/agents/skills/` and made available via symlinks:

```
~/.dotfiles/agents/           ← In git, version controlled
├── .skill-lock.json          ← Tracks installed skills
└── skills/
    ├── create-skill/         ← Custom skills
    └── installed-skill/      ← Skills from npx skills CLI

~/.agents → ~/.dotfiles/agents/       ← npx skills writes here
~/.claude/skills → ~/.agents/skills/  ← Claude Code reads from here
```

#### Managing Skills

```bash
# Install a skill (lands in dotfiles via symlink)
npx skills add owner/repo@skill-name -g -y

# Update all skills
npx skills update

# Create a custom skill
mkdir -p ~/.dotfiles/agents/skills/my-skill
# Then create SKILL.md following the spec
```

To create a new global skill, use the `create-skill` skill or manually create a directory in `~/.dotfiles/agents/skills/` following the Agent Skills specification (https://agentskills.io).


### Codex Configuration

Manage only `codex/config.toml` and the global instruction link through dotfiles. Keep `~/.codex/` itself as a local directory: authentication, sessions, databases, caches, plugins, automations, and approval rules remain local. Do not put credentials in tracked configuration; use environment references or the tool's credential store. The current configuration preserves this machine's app integration paths and project trust entries; review those when installing on another machine.
