---
description: Generate a commit for staged changes
agent: build
---

Analyze the current git state and create a well-crafted commit:

1. First, detect if this is a GitButler-managed repository:
   - Check for `.git/gitbutler` directory or run `but status` to see if it succeeds
   - If GitButler is active, use `/gb-commit` workflow instead

2. For standard Git repositories:
   - Run `git status` to see staged and unstaged changes
   - Run `git diff --cached` to review what's staged
   - If nothing is staged, suggest which files should be staged based on logical groupings

3. Generate a commit message following conventional commit format:
   - Use present tense ("Add feature" not "Added feature")
   - Keep the subject line under 50 characters
   - Add a body if the change is complex, explaining the "why"

4. Show me the proposed commit message before committing

5. If there's a CHANGELOG.md, update it appropriately

Wait for my approval before actually committing.
