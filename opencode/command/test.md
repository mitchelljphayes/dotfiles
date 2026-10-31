---
description: Run tests and fix failures
agent: builder
---

Run the project's tests and fix failures within the requested scope: $ARGUMENTS

1. Identify the existing test commands and framework. Honour any requested paths,
   test selection, or run-only constraint; otherwise run the project's test suite.
2. Run tests directly and capture failures.
3. Diagnose and fix in-scope failures directly. Distinguish code defects from
   environment/setup blockers and unrelated failures; don't weaken tests to pass.
4. Re-run affected tests, then the relevant suite and lint/type checks for edits.
5. Summarize commands run, results, changes, and any unresolved failures or blockers.

Use `test-analyzer` only when a bounded specialist investigation materially helps,
not as a required step for every failure. No pipeline or session artifacts.
