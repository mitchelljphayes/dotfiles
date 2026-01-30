---
description: Run tests and fix failures
agent: builder
---

Run the project's test suite.

1. Identify testing framework (pytest, jest, cargo test, etc.)
2. Run the tests
3. If failures occur, **delegate to test-analyzer agent** for diagnosis
4. For each failure:
   - Identify root cause
   - Implement fix (do it yourself if simple, delegate to build if complex)
   - Re-run affected tests
5. Provide summary of results

$ARGUMENTS
