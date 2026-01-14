# ydotool-rebind

A wrapper for `ydotool` that translates AZERTY keyboard input to QWERTY, allowing proper text input with French AZERTY keyboards.

## What is this?

`ydotool` is a Linux keyboard/mouse automation tool that internally uses QWERTY layout regardless of your system keyboard layout. This wrapper automatically translates AZERTY input to QWERTY before passing it to `ydotool`.

**Example:**

- Input: `ydotool type "Bonjour"`
- Without wrapper: Types `Vonjout` ❌
- With wrapper: Types `Bonjour` ✅
