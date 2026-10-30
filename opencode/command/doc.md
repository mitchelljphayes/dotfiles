---
description: Generate or update documentation
agent: builder
---

Generate or update documentation for: $ARGUMENTS

1. Read the relevant implementation and existing documentation directly.
2. Update existing docs where appropriate; create new files only for the requested
   documentation. Follow the project's layout or the user's specified path.
3. Explain purpose, usage, contracts, and configuration as relevant. Include useful
   examples without duplicating obvious code or inventing unsupported behaviour.
4. Verify examples and references against the implementation and run the project's
   documentation checks when available.
5. Summarize the changes and verification.

Write directly by default. Use `docs-writer` only for a bounded task where it
materially helps. Don't create pipeline session artifacts unless requested.
