# Nushell Vendor Autoload Directory

This directory contains scripts that are automatically loaded by Nushell at startup.

## Current Files

- `starship.nu` - Starship prompt initialization (auto-generated by `starship init nu`)

## How it Works

Nushell automatically sources all `.nu` files in the `$nu.data-dir/vendor/autoload` directory during startup. This is the official recommended way to configure tools like Starship.

## Regenerating Starship Configuration

If you need to regenerate the starship configuration (e.g., after updating starship):

```bash
starship init nu > ~/.dotfiles/nu/vendor/autoload/starship.nu
```

## Note

This directory is symlinked from `~/Library/Application Support/nushell/vendor` via dotbot.