# ydotool-rebind

A Bash wrapper around `ydotool` that translates keyboard input from non-QWERTY layouts to QWERTY, allowing proper text input with AZERTY, QWERTZ, and other keyboard layouts.

## What is this?

`ydotool` is a Linux keyboard/mouse automation tool that internally uses QWERTY layout regardless of your system keyboard layout. This wrapper automatically translates input to QWERTY before passing it to `ydotool`.

**Example (French AZERTY):**

- Input: `ydotool type "Bonjour"`
- Without wrapper: Types `Vonjout`
- With wrapper: Types `Bonjour`

## Supported layouts

| Layout | Description    | Key differences                                |
| ------ | -------------- | ---------------------------------------------- |
| `fr`   | French AZERTY  | a/q, z/w, m swaps, accents                     |
| `de`   | German QWERTZ  | z/y swap, umlauts, sharp s                     |
| `be`   | Belgian AZERTY | Similar to FR, different number row            |
| `it`   | Italian        | QWERTY-based, accented vowels on special keys  |
| `es`   | Spanish        | QWERTY-based, ñ, ç, ¡/¿, dead keys for accents |
| `us`   | US QWERTY      | Passthrough (no translation)                   |

## Installation

```bash
git clone https://github.com/david-vct/ydotool-rebind.git
cd ydotool-rebind
sudo ./install.sh
```

**Requirements:** `ydotool` installed, Bash 4.0+, root access

The project now follows standard Bash naming conventions in the repository and on disk:

- `bin/ydotool-rebind.sh`: explicit development entrypoint
- `lib/translate.sh`: translation library and CLI helper
- `lib/layout.sh`: layout detection and loading
- `lib/utils.sh`: shared utility functions
- `share/layouts/*.sh`: layout data files

Installed paths under `/usr/local`:

- `/usr/local/bin/ydotool`
- `/usr/local/lib/ydotool-rebind/translate.sh`
- `/usr/local/lib/ydotool-rebind/layout.sh`
- `/usr/local/lib/ydotool-rebind/utils.sh`
- `/usr/local/share/ydotool-rebind/layouts/*.sh`
- `/usr/local/etc/ydotool-rebind.conf`

If an older version was previously installed in `/usr/bin`, the installer automatically migrates it to the new layout.

## Configuration

The layout is detected automatically by cascade:

1. `YDOTOOL_LAYOUT` environment variable
2. `/usr/local/etc/ydotool-rebind.conf` file (`LAYOUT=fr`)
3. `setxkbmap` auto-detection (X11)
4. `localectl` auto-detection (systemd)
5. Fallback: `fr`

To change the default layout:

```bash
# Edit config file
sudo nano /usr/local/etc/ydotool-rebind.conf
# Set: LAYOUT=de

# Or use environment variable
YDOTOOL_LAYOUT=de ydotool type "Hallo Welt"
```

## Usage

After installation, use `ydotool` normally:

```bash
# Types correctly with your keyboard layout
ydotool type "Bonjour, ça va ?"

# File mode
ydotool type -f /path/to/file.txt

# Other commands work as usual
ydotool key Return
ydotool mousemove 100 100
```

## How it works

1. `bin/ydotool-rebind.sh` intercepts all `ydotool` commands.
2. For `type`, it sources `lib/utils.sh`, `lib/layout.sh`, and `lib/translate.sh`, then parses options, loads the keyboard layout mapping, and translates the input.
3. The wrapper then forwards only the translated payload to the real system `ydotool`.

The library can also be executed directly for debugging or scripting:

```bash
./lib/translate.sh detect-layout
./lib/translate.sh translate "Bonjour, ça va ?"
./lib/translate.sh translate -f /tmp/test.txt
```

## Supported characters

- French accents: e, e, e, a, u, c (circumflex, diaeresis)
- German umlauts: a, o, u, ss
- Ligatures: ae, oe
- All layout-specific symbols and key positions

## Debug

```bash
DEBUG=1 ydotool type "test"
# Log: /tmp/ydotool-rebind-debug.log
```

## Uninstall

```bash
sudo ./uninstall.sh
```

The uninstall script removes the `/usr/local` installation and also restores the original `/usr/bin/ydotool` if it detects a legacy installation.

## License

MIT License - see [LICENSE](LICENSE)
