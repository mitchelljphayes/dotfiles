---
description: Commit changes to a GitButler virtual branch
agent: build
---

Commit changes to a specific GitButler virtual branch:

1. Run `but status -f` to see current state:
   - List all unassigned changes
   - List all virtual branches with their assigned files
   - Note which branches have uncommitted assigned changes

2. Analyze the changes and determine:
   - Which branch to commit to (use the branch ID or name if specified in args: $ARGUMENTS)
   - Whether to commit all changes or only assigned changes (`-o` flag)
   
3. If no branch is specified and multiple branches exist:
   - Show the user the available branches
   - Ask which branch they want to commit to
   
4. Generate a commit message following conventional commit format:
   - Use present tense ("Add feature" not "Added feature")
   - Keep the subject line under 50 characters
   - Explain the "why" if the change is complex
   
5. Show the proposed commit command and message before executing:
   - `but commit -m "message" <branch-id>` for committing all unassigned + target branch assigned files
   - `but commit -o -m "message" <branch-id>` for committing only assigned files

6. Wait for approval before committing

Note: In GitButler, unassigned changes are automatically included when committing to a branch unless you use the `-o` (only) flag to commit just the assigned files.
