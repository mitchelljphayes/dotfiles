# Global opencode Agent Instructions

These are global instructions that apply to all opencode sessions and projects.

## Core Principles

- **Be concise**: Keep responses short and to the point unless detail is requested
- **Follow conventions**: Always examine existing code patterns before making changes
- **Security first**: Never expose secrets, use environment variables for sensitive data
- **Test-driven**: Run tests and linting before completing tasks
- **Documentation**: Code should be self-documenting, avoid unnecessary comments

## Development Environment

### Python
- Always use `uv` instead of `python` or `python3`
- Use `uv run` for running Python scripts
- Use `uv pip` for package management
- Add type hints to all Python code

### Shell & Tools
- Use `rg` (ripgrep) instead of `grep` for searching
- Use `eza` for better file listings when available
- Use `bat` for syntax-highlighted file viewing
- Use `z` (zoxide) for smart directory navigation in terminal (not available in opencode)

### Git Workflow
- Use conventional commit format when appropriate
- Keep commit messages concise but descriptive
- Use present tense ("Add feature" not "Added feature")
- Always check git status and diff before committing
- Update CHANGELOG.md if it exists before committing

## Code Quality Standards

### General
- Prefer explicit over implicit code
- Use descriptive variable and function names
- Keep functions small and focused
- Follow existing code style in each project
- Handle errors gracefully with proper error messages

### Security
- Never commit API keys, passwords, or tokens
- Use environment variables for sensitive configuration
- Set restrictive permissions (600) on sensitive files
- Validate all inputs properly
- Follow principle of least privilege

### Performance
- Consider performance implications of code changes
- Use appropriate data structures and algorithms
- Avoid premature optimization
- Profile code when performance issues are suspected

## Task Management

### Todo System
- Use TodoWrite/TodoRead tools for complex multi-step tasks
- Mark todos as completed immediately after finishing
- Only have one task in_progress at a time
- Break down complex tasks into smaller, manageable steps

### Testing Strategy
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
- Look for existing AGENTS.md, CLAUDE.md, or .cursor/rules files

### File Patterns to Check
- `README.md` - Project overview and setup instructions
- `CONTRIBUTING.md` - Contribution guidelines
- `package.json` - Node.js dependencies and scripts
- `pyproject.toml` - Python project configuration
- `Cargo.toml` - Rust project configuration
- `.env.example` - Environment variable examples
- `Makefile` - Build and development commands
- `.github/workflows/` - CI/CD configuration

## Communication Style

### Response Format
- Answer directly without unnecessary preamble
- Use markdown formatting for code and structure
- Include file paths with line numbers when referencing code (e.g., `src/utils.py:42`)
- Explain complex changes or non-obvious decisions
- Ask for clarification when requirements are ambiguous

### Error Handling
- Provide clear error messages with context
- Suggest specific solutions, not just identify problems
- Include relevant file paths and line numbers
- Offer alternatives when the primary approach fails

## Platform-Specific Notes

### macOS
- Be aware of case-insensitive filesystem by default
- Use `brew` for package management suggestions
- Account for macOS-specific paths and commands
- Understand that user's shell is zsh but opencode runs in bash

## Collaboration

### Code Reviews
- Focus on functionality, security, and maintainability
- Suggest improvements with specific examples
- Acknowledge good practices when seen
- Be constructive and respectful in feedback

### Documentation
- Keep documentation up to date with code changes
- Write clear commit messages that explain the "why"
- Document complex algorithms or business logic
- Include examples in documentation when helpful

## Important Reminders

- Think before acting - understand the codebase first
- Check for project-specific instructions that override these global rules
- Be mindful of backwards compatibility
- Consider the impact of changes on the entire system
- Always verify that changes work as expected before completing tasks