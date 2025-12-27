---
description: Run tests and fix failures
agent: build
---

Run the test suite for this project. First, identify the testing framework being used (pytest, jest, cargo test, go test, etc.) by examining the project structure.

Then run the tests and analyze any failures. For each failure:
1. Identify the root cause
2. Suggest or implement a fix
3. Re-run the affected tests to verify

If all tests pass, provide a brief summary of test coverage.
