---
description: Run linters and fix issues
agent: build
---

Identify and run the appropriate linters for this project:

1. Check for linting configuration files (ruff.toml, .eslintrc, .prettierrc, rustfmt.toml, etc.)
2. Run the linter(s) and capture any errors or warnings
3. For each issue found:
   - Auto-fix if the linter supports it (e.g., `ruff check --fix`, `eslint --fix`)
   - For issues that can't be auto-fixed, explain the problem and suggest a fix
4. Re-run the linter to verify all issues are resolved
5. Provide a summary of what was fixed

$ARGUMENTS
