---
description: Run security audit on code
---

Run security audit on: $ARGUMENTS

1. If path specified, audit those files
2. If no path, audit recent changes (`git diff main`)
3. Check for:
   - Input validation issues
   - Authentication/authorization flaws
   - Data exposure risks
   - Injection vulnerabilities (SQL, command, etc.)
   - Insecure configurations
   - Hardcoded secrets or credentials
   - Dependency vulnerabilities
4. Present findings with severity levels (Critical/High/Medium/Low) and specific recommendations
