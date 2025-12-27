---
description: Assign file changes to a GitButler virtual branch
agent: build
---

Assign unassigned file changes to a specific GitButler virtual branch using the `but rub` command:

Arguments: $ARGUMENTS (files and target branch)

1. Run `but status -f` to see:
   - Unassigned changes (files not yet assigned to any branch)
   - Existing virtual branches and their assigned files
   - File shortcodes (2-character IDs) for each file

2. Parse the arguments to determine:
   - Which files to assign (by shortcode, path, or pattern)
   - Which branch to assign them to

3. If no arguments provided:
   - Show the current unassigned files with their shortcodes
   - List available branches
   - Ask user which files should go to which branch

4. Execute the assignment:
   - `but rub <file-ids> <branch-id>` 
   - File IDs can be: shortcodes (e.g., `xw`), paths (e.g., `src/`), or comma-separated lists
   - Branch can be: shortcode (e.g., `nd`) or full name

5. Run `but status` to confirm the assignment

Examples:
- `/gb-assign xw,ie feature-auth` - Assign files xw and ie to feature-auth branch
- `/gb-assign src/models/ data-layer` - Assign all files in src/models/ to data-layer branch
- `/gb-assign` - Interactive mode to assign files

Note: Files can be reassigned between branches by rubbing them again. Assigned files are staged for the next commit to that branch.
