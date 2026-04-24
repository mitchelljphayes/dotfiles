---
description: Run tests and fix failures
---

Run the project's test suite. $ARGUMENTS

1. Identify testing framework (pytest, jest, cargo test, etc.)
2. Run the tests
3. If failures occur, diagnose each one:
   - Identify root cause
   - Categorize: test bug vs. code bug vs. environment issue
   - Rate confidence: high/medium/low
4. For each failure:
   - Implement fix if straightforward
   - Ask for guidance if complex or ambiguous
   - Re-run affected tests to verify
5. Provide summary of results
