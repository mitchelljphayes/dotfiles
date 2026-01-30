---
description: Run security audit on code
agent: builder
---

Run security audit on: $ARGUMENTS

**Delegate to security-auditor agent** to review:

1. If path specified, audit those files
2. If no path, audit recent changes (`git diff main`)
3. Check for:
   - Input validation issues
   - Authentication/authorization flaws
   - Data exposure risks
   - Injection vulnerabilities
   - Insecure configurations
   - Dependency vulnerabilities

Present findings with severity levels and recommendations.
