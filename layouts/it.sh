#!/bin/bash
# Italian layout mapping to QWERTY
# Source: /usr/share/X11/xkb/symbols/it (basic) + latin(type4)
#
# Italian is quasi-QWERTY: same letter positions,
# but different special characters and accented keys.
#
# Only non-identity mappings are listed.
# Characters not in this map pass through unchanged.

declare -A KEYMAP=(
    # ===== TLDE: \ / | → QWERTY ` / ~ =====
    ['\']='`'
    ['|']='~'

    # ===== NUMBER ROW (shifted differences from QWERTY) =====
    ['"']='@'     # Shift+2: IT " → US @
    ['£']='#'     # Shift+3: IT £ → US #
    ['&']='^'     # Shift+6: IT & → US ^
    ['/']='&'     # Shift+7: IT / → US &
    ['(']='*'     # Shift+8: IT ( → US *
    [')']='('     # Shift+9: IT ) → US (
    ['=']=')'     # Shift+0: IT = → US )

    # AE11: ' / ? → QWERTY - / _
    ["'"]='-'
    ['?']='_'

    # AE12: ì / ^ → QWERTY = / +
    ['ì']='='
    ['^']='+'

    # ===== SPECIAL KEYS =====
    # AD11: è / é → QWERTY [ / {
    ['è']='['
    ['é']='{'
    # AD12: + / * → QWERTY ] / }
    ['+']=']'
    ['*']='}'
    # AC10: ò / ç → QWERTY ; / :
    ['ò']=';'
    ['ç']=':'
    # AC11: à / ° → QWERTY ' / "
    ['à']="'"
    ['°']='"'
    # BKSL: ù / § → QWERTY \ / |
    ['ù']='\\'
    ['§']='|'

    # ===== BOTTOM ROW (shifted differences) =====
    [';']='<'     # AB08 shifted: IT ; → US <
    [':']='>'     # AB09 shifted: IT : → US >
    ['-']='/'     # AB10 unshifted: IT - → US /
    ['_']='?'     # AB10 shifted: IT _ → US ?

    # ===== LIGATURES =====
    ['œ']='oe'
    ['Œ']='OE'
    ['æ']='ae'
    ['Æ']='AE'
    ['ñ']='n'
    ['Ñ']='N'
)
