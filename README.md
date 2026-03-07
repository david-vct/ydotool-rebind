# ydotool-rebind

A wrapper for `ydotool` that translates keyboard input from non-QWERTY layouts to QWERTY, allowing proper text input with AZERTY, QWERTZ, and other keyboard layouts.

## What is this?

`ydotool` is a Linux keyboard/mouse automation tool that internally uses QWERTY layout regardless of your system keyboard layout. This wrapper automatically translates input to QWERTY before passing it to `ydotool`.

**Example (French AZERTY):**

- Input: `ydotool type "Bonjour"`
- Without wrapper: Types `Vonjout`
- With wrapper: Types `Bonjour`

## Supported layouts

| Layout | Description | Key differences |
|--------|-------------|-----------------|
| `fr`   | French AZERTY | a/q, z/w, m swaps, accents |
| `de`   | German QWERTZ | z/y swap, umlauts, sharp s |
| `be`   | Belgian AZERTY | Similar to FR, different number row |
| `it`   | Italian | QWERTY-based, accented vowels on special keys |
| `es`   | Spanish | QWERTY-based, ñ, ç, ¡/¿, dead keys for accents |
| `us`   | US QWERTY | Passthrough (no translation) |

## Installation

```bash
git clone https://github.com/david-vct/ydotool-rebind.git
cd ydotool-rebind
sudo ./install.sh
```

**Requirements:** `ydotool` installed, Bash 4.0+, root access

## Configuration

The layout is detected automatically by cascade:

1. `YDOTOOL_LAYOUT` environment variable
2. `/etc/ydotool-rebind/config` file (`LAYOUT=fr`)
3. `setxkbmap` auto-detection (X11)
4. `localectl` auto-detection (systemd)
5. Fallback: `fr`

To change the default layout:

```bash
# Edit config file
sudo nano /etc/ydotool-rebind/config
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

1. Wrapper intercepts all `ydotool` commands
2. For `type` commands: loads the keyboard layout mapping and translates text
3. Passes translated result to real `ydotool`

## Supported characters

- French accents: e, e, e, a, u, c (circumflex, diaeresis)
- German umlauts: a, o, u, ss
- Ligatures: ae, oe
- All layout-specific symbols and key positions

## Debug

```bash
DEBUG=1 ydotool type "test"
# Log: /tmp/ydotool-translate-debug.log
```

## Uninstall

```bash
sudo ./uninstall.sh
```

## License

MIT License - see [LICENSE](LICENSE)
