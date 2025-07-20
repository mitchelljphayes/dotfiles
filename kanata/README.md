# Kanata Configuration

This directory contains the kanata keyboard remapper configuration, converted from Karabiner Elements.

## Configuration Files

- `kanata.toml` - TOML format configuration (requires full TOML implementation)
- `kanata.kbd` - S-expression format with all features (some features like fork need adjustment)  
- `kanata-simple.kbd` - Simplified working configuration with core Caps Lock mapping

## Key Mappings

The `kanata.toml` file implements the following mappings:

1. **Caps Lock → Control/Escape**
   - When held with other keys: Acts as Left Control
   - When tapped alone: Acts as Escape

2. **Control + HJKL → Arrow Keys**
   - Control + H → Left Arrow
   - Control + J → Down Arrow
   - Control + K → Up Arrow
   - Control + L → Right Arrow

3. **Double Shift → Caps Lock**
   - Pressing both shift keys together triggers Caps Lock

## Installation

1. Install kanata from source (required for TOML support):
   ```bash
   # Navigate to the kanata source directory
   cd ~/Developer/kanata
   
   # Build the release version
   cargo build --release
   
   # Copy the binary to a location in your PATH
   sudo cp target/release/kanata /usr/local/bin/
   
   # Or create a symlink
   sudo ln -sf ~/Developer/kanata/target/release/kanata /usr/local/bin/kanata
   ```

2. The configuration will be symlinked to `~/.config/kanata/` when you run the dotfiles install script.

3. Start kanata:
   ```bash
   # Test the configuration first
   sudo kanata -c ~/.config/kanata/kanata-simple.kbd --check
   
   # Run kanata with the simple config (working)
   sudo kanata -c ~/.config/kanata/kanata-simple.kbd
   
   # The TOML config (kanata.toml) is ready for when TOML support is fully implemented
   ```

4. For automatic startup, create a launch daemon (macOS) or systemd service (Linux).

## macOS Setup

For macOS, kanata requires accessibility permissions:
1. Grant Terminal/iTerm accessibility permissions in System Preferences → Security & Privacy → Privacy → Accessibility
2. You may need to run kanata with `sudo`

## Differences from Karabiner

- Device-specific modifications (function keys, etc.) are not included in this config
- The Control+HJKL implementation uses kanata's `fork` action instead of modifier detection
- All other keys pass through normally due to `process-unmapped-keys = true`