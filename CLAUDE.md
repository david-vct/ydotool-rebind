# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ydotool-rebind** is a wrapper system for `ydotool` that translates AZERTY keyboard input to QWERTY layout. The `ydotool` tool internally uses QWERTY layout regardless of system keyboard configuration, causing incorrect text output on AZERTY systems. This wrapper intercepts `ydotool type` commands and translates the input before passing it to the real binary.

### Core Problem

- `ydotool` always uses QWERTY internally
- AZERTY users typing "Bonjour" would see "Vonjout" typed
- This wrapper translates: AZERTY input → QWERTY equivalent → correct output

## Architecture

### Components

1. **ydotool-wrapper.sh** (`src/ydotool-wrapper.sh`)
   - Replaces the system `ydotool` binary via symlink
   - Intercepts all `ydotool` commands
   - Routes `type` commands to the translator
   - Passes all other commands directly to `ydotool-real`

2. **ydotool-translate.sh** (`src/ydotool-translate.sh`)
   - Character-by-character AZERTY → QWERTY translation engine
   - Handles all French AZERTY characters including:
     - Number row symbols (& é " ' ( - è _ ç à)
     - Letter position mappings (a↔q, z↔w, w↔z, m↔;, etc.)
     - French accents (é è à ù ç and circumflex/diaeresis variants)
     - Special ligatures (œ æ)
   - Preserves `ydotool type` command options (-d, -H, -D, -f, -e)
   - File mode (-f) translates file content before passing to ydotool (supports stdin with `-f -`)

3. **Installation System**
   - `install.sh`: Renames `/usr/bin/ydotool` → `/usr/bin/ydotool-real`, copies wrapper and translator to `/usr/bin/`, creates symlink
   - `uninstall.sh`: Removes wrapper/translator files and restores original binary

### Execution Flow

**Direct Text Mode:**
```
User: ydotool type "Bonjour"
  ↓
ydotool-wrapper.sh (at /usr/bin/ydotool)
  ↓ (detects "type" command)
ydotool-translate.sh
  ↓ (translates character-by-character)
  "Bonjour" → "Vonjout" (AZERTY→QWERTY mapping)
  ↓
/usr/bin/ydotool-real type "Vonjout"
  ↓ (ydotool interprets as QWERTY)
Output: "Bonjour" ✓
```

**File Mode:**
```
User: ydotool type -f /tmp/test.txt (contains "Bonjour")
  ↓
ydotool-wrapper.sh (at /usr/bin/ydotool)
  ↓ (detects "type" command)
ydotool-translate.sh
  ↓ (reads file content)
  ↓ (translates content)
  "Bonjour" → "Vonjout" (AZERTY→QWERTY mapping)
  ↓
/usr/bin/ydotool-real type --file - (receives translated content via stdin)
  ↓ (ydotool interprets as QWERTY)
Output: "Bonjour" ✓
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

### Testing
```bash
# Manual testing
ydotool type "Bonjour, ça va ?"
ydotool type "éèàù çœæ"

# File mode testing (translates file content)
echo "Bonjour" > /tmp/test.txt
ydotool type -f /tmp/test.txt
# Or from stdin:
echo "Bonjour" | ydotool type -f -

# Debug mode (logs to /tmp/ydotool-translate-debug.log)
DEBUG=1 ydotool type "test"
DEBUG=1 ydotool type -f /tmp/test.txt
```

Note: The README mentions `./test.sh` but no test script exists in the repository.

## Character Translation Logic

The translator uses a large `case` statement in `translate_azerty_to_qwerty()` function:

- **Number row**: Maps AZERTY symbols to QWERTY equivalents (e.g., `&` → `1`, `é` → `2`)
- **Letter swaps**: Key position differences (e.g., AZERTY `a` is where QWERTY `q` is)
- **Accented characters**: Uses dead key sequences for circumflex (`^` = `[` on QWERTY) and diaeresis (`¨` = `{` on QWERTY), falls back to base letter for other accents
- **Ligatures**: Expands to multi-character (e.g., `œ` → `oe`)
- **Passthrough**: Most symbols and all unrecognized characters pass unchanged

### Critical Mappings
- Letter row: `azerty...` → `qwerty...`
- Home row: `qsdfg...m` → `asdfg...;`
- Bottom row: `wxcvbn,;:` → `zxcvbn,;.`

## File Structure

```
ydotool-rebind/
├── src/
│   ├── ydotool-wrapper.sh      # Main wrapper (copied to /usr/bin/, symlinked to /usr/bin/ydotool)
│   └── ydotool-translate.sh    # Translation engine
├── install.sh                   # Installation script
├── uninstall.sh                 # Uninstallation script
└── README.md
```

## Implementation Notes

### When Modifying Translation Logic

1. The translator is mostly stateless - each character is translated independently (circumflex/diaeresis produce 2-character dead key sequences)
2. Order matters in the `case` statement (first match wins)
3. Some characters appear multiple times with different contexts (e.g., `&` as both AZERTY unshifted and shifted)
4. Test with actual AZERTY keyboard input to verify correctness
5. The wrapper passes through all `ydotool` options unchanged
6. File mode (`-f`) reads file content, translates it, then passes translated content to ydotool via stdin

### System Integration

- The wrapper and translator are copied to `/usr/bin/` and rely on absolute path `/usr/bin/ydotool-real`
- Script resolution uses `readlink -f` to follow symlinks and find the translator in the same directory
- Installation is idempotent (checks for existing `/usr/bin/ydotool-real`)
- Requires root for system binary modification

### Debug Output

Enable with `DEBUG=1` environment variable:
- Logs to `/tmp/ydotool-translate-debug.log`
- Shows original text, translated text, and full command executed
- File mode logs include file path, original content, and translated content
- Useful for diagnosing translation issues
