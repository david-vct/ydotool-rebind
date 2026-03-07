# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ydotool-rebind** is a wrapper system for `ydotool` that translates keyboard input from non-QWERTY layouts to QWERTY. The `ydotool` tool internally uses QWERTY layout regardless of system keyboard configuration, causing incorrect text output on non-QWERTY systems. This wrapper intercepts `ydotool type` commands and translates the input before passing it to the real binary.

### Core Problem

- `ydotool` always uses QWERTY internally
- Non-QWERTY users get wrong characters (e.g., AZERTY "Bonjour" → "Vonjout")
- This wrapper translates: source layout input → QWERTY equivalent → correct output

### Supported Layouts

| Layout | Type | Key differences |
|--------|------|-----------------|
| `fr` | AZERTY | a/q, z/w, m swaps, accents, number row symbols |
| `de` | QWERTZ | z/y swap, umlauts (ö,ä,ü), ß, dead keys for accents |
| `be` | AZERTY | Similar to FR, different number row (§, !, =) |
| `it` | QWERTY-based | Accented vowels on special keys (è,é,ò,à,ù,ì) |
| `es` | QWERTY-based | ñ, ç, ¡/¿, dead keys for all accents |
| `us` | QWERTY | Passthrough (no translation) |

## Architecture

### Components

1. **ydotool-wrapper.sh** (`src/ydotool-wrapper.sh`)
   - Replaces the system `ydotool` binary via symlink
   - Intercepts all `ydotool` commands
   - Routes `type` commands to the translator
   - Passes all other commands directly to `ydotool-real`

2. **ydotool-translate.sh** (`src/ydotool-translate.sh`)
   - Generic translation engine (layout-agnostic)
   - `detect_layout()`: cascade YDOTOOL_LAYOUT → config → setxkbmap → localectl → fallback `fr`
   - `load_layout()`: sources layout file (declares `KEYMAP` associative array)
   - `translate_text()`: character-by-character translation using `KEYMAP[$char]` with passthrough fallback
   - Short-circuits for `us` layout (no translation needed)
   - Preserves `ydotool type` command options (-d, -H, -D, -f, -e)
   - File mode (-f) translates file content before passing to ydotool (supports stdin with `-f -`)

3. **Layout files** (`layouts/*.sh`)
   - Each layout declares a `declare -A KEYMAP` associative array
   - Only non-identity mappings (characters that differ from QWERTY)
   - Support multi-character values for dead key sequences (e.g., `['â']='[q'`)
   - Installed to `/etc/ydotool-rebind/layouts/`

4. **Installation System**
   - `install.sh`: Renames `/usr/bin/ydotool` → `/usr/bin/ydotool-real`, copies wrapper/translator to `/usr/bin/`, copies layouts to `/etc/ydotool-rebind/layouts/`, creates default config
   - `uninstall.sh`: Removes wrapper/translator, layouts, config, restores original binary

### Execution Flow

```
User: ydotool type "Bonjour"
  ↓
ydotool-wrapper.sh (at /usr/bin/ydotool)
  ↓ (detects "type" command)
ydotool-translate.sh
  ↓ detect_layout() → "fr"
  ↓ load_layout("fr") → source /etc/ydotool-rebind/layouts/fr.sh
  ↓ translate_text() → KEYMAP lookup per character
  ↓
/usr/bin/ydotool-real type "<translated>"
  ↓ (ydotool interprets as QWERTY)
Output: "Bonjour"
```

## Commands

### Installation
```bash
sudo ./install.sh
```
Requires: root access, `ydotool` pre-installed, Bash 4.0+

### Uninstallation
```bash
sudo ./uninstall.sh
```

### Installation via .deb
```bash
sudo dpkg -i ydotool-rebind_X.X.X_all.deb
# Uninstall:
sudo dpkg -r ydotool-rebind
```

### Configuration
```bash
# Set layout in config file
echo "LAYOUT=de" | sudo tee /etc/ydotool-rebind/config

# Or use environment variable (takes priority)
YDOTOOL_LAYOUT=de ydotool type "Hallo Welt"
```

### Testing
```bash
# French AZERTY
ydotool type "Bonjour, ça va ?"
ydotool type "âêîôû äëïöü"

# German QWERTZ
YDOTOOL_LAYOUT=de ydotool type "Hallo Welt"
YDOTOOL_LAYOUT=de ydotool type "Grüße über Straße"

# File mode
echo "Bonjour" > /tmp/test.txt
ydotool type -f /tmp/test.txt
echo "Bonjour" | ydotool type -f -

# Debug mode
DEBUG=1 ydotool type "test"
```

### Building .deb
```bash
# Structure: /tmp/ydotool-rebind_VERSION/DEBIAN/{control,postinst,prerm} + usr/bin/{scripts} + etc/ydotool-rebind/layouts/
dpkg-deb --build /tmp/ydotool-rebind_VERSION /tmp/ydotool-rebind_VERSION_all.deb
```

## File Structure

```
ydotool-rebind/
├── src/
│   ├── ydotool-wrapper.sh      # Main wrapper (copied to /usr/bin/)
│   └── ydotool-translate.sh    # Generic translation engine
├── layouts/
│   ├── fr.sh                   # French AZERTY
│   ├── de.sh                   # German QWERTZ
│   ├── be.sh                   # Belgian AZERTY
│   ├── it.sh                   # Italian
│   └── es.sh                   # Spanish
├── install.sh                   # Installation script
├── uninstall.sh                 # Uninstallation script
└── README.md
```

Installed files:
```
/usr/bin/ydotool-wrapper.sh
/usr/bin/ydotool-translate.sh
/usr/bin/ydotool → symlink to ydotool-wrapper.sh
/etc/ydotool-rebind/config          # LAYOUT=fr
/etc/ydotool-rebind/layouts/*.sh    # Layout files
```

## Implementation Notes

### Adding a New Layout

1. Create `layouts/xx.sh` with `declare -A KEYMAP=(...)`
2. Only map characters that differ from QWERTY (passthrough handles the rest)
3. For dead key accents, use multi-character values (e.g., `['â']='`a'` for circumflex via backtick dead key)
4. Reference `/usr/share/X11/xkb/symbols/xx` for key positions
5. Test with `YDOTOOL_LAYOUT=xx ydotool type "test text"`

### Layout Detection Cascade

1. `YDOTOOL_LAYOUT` environment variable (highest priority)
2. `/etc/ydotool-rebind/config` file
3. `setxkbmap -query` (X11 auto-detection)
4. `localectl status` (systemd auto-detection)
5. Fallback: `fr` (backward compatibility)

### When Modifying Translation Logic

1. The translator is stateless - each character is translated independently
2. Multi-character values in KEYMAP are output as-is (used for dead key sequences)
3. Characters not in KEYMAP pass through unchanged
4. The wrapper passes through all `ydotool` options unchanged
5. File mode (`-f`) reads file content, translates it, then passes translated content to ydotool via stdin
6. Dev mode: layouts are also searched in `$(script_dir)/../layouts/` for development without installation

### System Integration

- The wrapper and translator are copied to `/usr/bin/` and rely on absolute path `/usr/bin/ydotool-real`
- Script resolution uses `readlink -f` to follow symlinks and find the translator in the same directory
- Installation is idempotent (checks for existing `/usr/bin/ydotool-real`)
- Config file is preserved on reinstall (only created if missing)
- Requires root for system binary modification

### Debug Output

Enable with `DEBUG=1` environment variable:
- Logs to `/tmp/ydotool-translate-debug.log`
- Shows detected layout, original text, translated text, and full command executed
- File mode logs include file path, original content, and translated content
