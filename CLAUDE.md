# Claude Code Instructions

This file contains instructions for Claude Code when working on this machine. Claude will follow these instructions across all projects.

## Development Environment

### Python
- Always execute Python using `uv` instead of `python` or `python3`
- Use `uv run` for running Python scripts
- Use `uv pip` for package management

### Shell Environment
- User's default shell is zsh (Claude runs in bash)
- Alacritty terminal uses Nushell (`nu`)
- Dotfiles are managed via this repository with Dotbot
- Shell aliases are defined in `~/.dotfiles/shell/aliases.sh`

## Code Style Preferences

### General
- Prefer explicit over implicit
- Use descriptive variable names
- Keep functions small and focused
- Add type hints in Python code
- Follow existing code style in each project

### Git Commits
- Use conventional commit format when appropriate
- Keep commit messages concise but descriptive
- Separate subject from body with a blank line
- Use present tense ("Add feature" not "Added feature")

## File Management
- Always use absolute paths when reading/writing files
- Check if directories exist before creating files in them
- Prefer editing existing files over creating new ones
- Never create documentation files unless explicitly requested

## Security
- Never commit sensitive information (API keys, passwords, tokens)
- Always check for exposed secrets before committing
- Use environment variables for sensitive configuration
- Set restrictive permissions (600) on sensitive files

## Testing
- Run tests before committing changes
- Check for linting/formatting tools (ruff, black, prettier, etc.)
- Run type checking if available (mypy, pyright)
- Verify changes don't break existing functionality

## macOS Specific
- Be aware of macOS-specific paths and commands
- Use `brew` for package management suggestions
- Account for case-insensitive filesystem by default

## Project-Specific Instructions
- Always check for project-specific CLAUDE.md files
- Project instructions override global instructions
- Look for .env.example files for environment setup
- Check README files for project conventions

## Helpful Patterns
- When searching for code, use ripgrep (`rg`) instead of grep
- Use `eza` for better file listings when available
- Leverage `fzf` for fuzzy finding when appropriate
- Use `bat` for syntax-highlighted file viewing
- Use `zoxide` (available as `z`) for smart directory navigation

## Important Reminders
- Think before acting - understand the codebase first
- Ask for clarification when requirements are ambiguous
- Explain complex changes or non-obvious decisions
- Be mindful of performance implications
- Consider backwards compatibility