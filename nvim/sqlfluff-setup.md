# SQLFluff Setup for dbt Projects

## Configuration

1. Create a `.sqlfluff` file in your dbt project root:

```ini
[sqlfluff]
templater = dbt
dialect = postgres  # or bigquery, snowflake, redshift, etc.
exclude_rules = L034,L044  # Rules that conflict with dbt

[sqlfluff:templater:dbt]
project_dir = .
profiles_dir = ~/.dbt
profile = default  # Your profile name from profiles.yml
target = dev  # Your target name

[sqlfluff:rules]
tab_space_size = 4
max_line_length = 120
indent_unit = space

[sqlfluff:rules:L010]  # Keywords
capitalisation_policy = lower

[sqlfluff:rules:L014]  # Unquoted identifiers
extended_capitalisation_policy = lower

[sqlfluff:rules:L030]  # Function names
capitalisation_policy = lower
```

2. Test sqlfluff from command line:
```bash
# Lint a file
sqlfluff lint models/staging/stg_orders.sql --dialect postgres --templater dbt

# Format a file
sqlfluff fix models/staging/stg_orders.sql --dialect postgres --templater dbt
```

## Neovim Usage

### Formatting
- `<space>f` - Format current file
- `<leader>f` - Format current file or selection
- `:Format` - Format command

### Linting
- Linting runs automatically on file open and save
- View diagnostics with:
  - `<space>e` - Show diagnostic float
  - `[d` - Previous diagnostic
  - `]d` - Next diagnostic
  - `<space>q` - Diagnostic list

### Toggle Diagnostics
- `:DiagnosticsToggle` - Toggle diagnostics on/off for current buffer

## Troubleshooting

1. If sqlfluff can't parse dbt templates:
   - Ensure dbt is installed: `pip install dbt-core dbt-postgres`
   - Check that your dbt project compiles: `dbt compile`
   - Verify profiles.yml exists at `~/.dbt/profiles.yml`

2. If formatting is slow:
   - Consider disabling format on save for SQL files
   - Use manual formatting with `<space>f`

3. For specific files, you can disable templating:
   ```sql
   -- sqlfluff:templater:raw
   SELECT * FROM table;
   ```