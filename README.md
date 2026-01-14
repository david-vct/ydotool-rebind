# ydotool-rebind

A wrapper for `ydotool` that translates AZERTY keyboard input to QWERTY, allowing proper text input with French AZERTY keyboards.

## What is this?

`ydotool` is a Linux keyboard/mouse automation tool that internally uses QWERTY layout regardless of your system keyboard layout. This wrapper automatically translates AZERTY input to QWERTY before passing it to `ydotool`.

**Example:**

- Input: `ydotool type "Bonjour"`
- Without wrapper: Types `Vonjout` ❌
- With wrapper: Types `Bonjour` ✅

## Installation

```bash
git clone https://github.com/david-vct/ydotool-rebind.git
cd ydotool-rebind
sudo ./install.sh
```

**Requirements:** `ydotool` installed, Bash 4.0+, root access

## Usage

After installation, use `ydotool` normally:

```bash
# Types correctly with AZERTY keyboard
ydotool type "Bonjour, ça va ?"

# Other commands work as usual
ydotool key Return
ydotool mousemove 100 100
```

## How it works

1. Wrapper intercepts all `ydotool` commands
2. For `type` commands: translates AZERTY → QWERTY
3. Passes result to real `ydotool`

## Supported characters

- French accents: é, è, ê, à, ù, ç
- Special characters: â, ô, û, ä, ö, ü
- Ligatures: æ, œ
- All AZERTY/QWERTY symbols

## Testing

```bash
./test.sh
```

## Uninstall

```bash
sudo ./uninstall.sh
```

## License

MIT License - see [LICENSE](LICENSE)
