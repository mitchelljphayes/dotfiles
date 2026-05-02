# Claude Code Instructions

Global instructions for Claude Code across all projects on this machine.

## Core Principles

- **Be concise**: Keep responses short and to the point unless detail is requested
- **Follow conventions**: Always examine existing code patterns before making changes
- **Security first**: Never expose secrets, use environment variables for sensitive data
- **Test-driven**: Run tests and linting before completing tasks
- **Self-documenting code**: Avoid unnecessary comments — code should speak for itself

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
- Keep functions small and focused
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
- Always run existing tests before making changes
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

## GitButler (Virtual Branches)

Projects may use GitButler (`but` CLI) for parallel branch development. When a repo has been set up with `but setup`, use `but` commands instead of `git` for branching, committing, and pushing.

Key commands: `but status`, `but branch new <name>`, `but rub <source> <target>`, `but commit <branch> -m "msg"`, `but push`.

**NEVER** use `git add`/`git commit`/`git checkout` in a GitButler-managed repo — it breaks the virtual branch state. See the `gitbutler-virtual-branches` skill for full details.

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
- Check for project-specific CLAUDE.md files (they override global instructions)
- Look for .env.example files for environment setup
- Be mindful of backwards compatibility
- Consider the impact of changes on the entire system
- Always verify that changes work as expected before completing tasks

