#!/bin/bash
# Spanish layout mapping to QWERTY
# Source: /usr/share/X11/xkb/symbols/es (basic) + latin(type4)
#
# Spanish is QWERTY-based for letters (no swaps),
# but has different special characters, ñ, and dead keys for accents.
#
# Only non-identity mappings are listed.
# Characters not in this map pass through unchanged.

KEYMAP=(
    # ===== TLDE: º / ª → QWERTY ` / ~ =====
    ['º']='`'
    ['ª']='~'

    # ===== NUMBER ROW (shifted differences from QWERTY) =====
    ['"']='@'     # Shift+2: ES " → US @
    ['·']='#'     # Shift+3: ES · (periodcentered) → US #
    ['&']='^'     # Shift+6: ES & → US ^
    ['/']='&'     # Shift+7: ES / → US &
    ['(']='*'     # Shift+8: ES ( → US *
    [')']='('     # Shift+9: ES ) → US (
    ['=']=')'     # Shift+0: ES = → US )

    # AE11: ' / ? → QWERTY - / _
    ["'"]='-'
    ['?']='_'

    # AE12: ¡ / ¿ → QWERTY = / +
    ['¡']='='
    ['¿']='+'

    # ===== SPECIAL KEYS =====
    # AD12: + / * → QWERTY ] / }
    ['+']=']'
    ['*']='}'
    # AC10: ñ / Ñ → QWERTY ; / :
    ['ñ']=';'
    ['Ñ']=':'
    # BKSL: ç / Ç → QWERTY \ / |
    ['ç']='\\'
    ['Ç']='|'

    # ===== BOTTOM ROW (shifted differences) =====
    [';']='<'     # AB08 shifted: ES ; → US <
    [':']='>'     # AB09 shifted: ES : → US >
    ['-']='/'     # AB10 unshifted: ES - → US /
    ['_']='?'     # AB10 shifted: ES _ → US ?

    # ===== DEAD KEY ACCENTS =====
    # Grave accent (dead_grave at AD11 unshifted → QWERTY [)
    ['à']='[a'
    ['è']='[e'
    ['ì']='[i'
    ['ò']='[o'
    ['ù']='[u'
    ['À']='[A'
    ['È']='[E'
    ['Ì']='[I'
    ['Ò']='[O'
    ['Ù']='[U'

    # Circumflex (dead_circumflex at AD11 shifted → QWERTY {)
    ['â']='{a'
    ['ê']='{e'
    ['î']='{i'
    ['ô']='{o'
    ['û']='{u'
    ['Â']='{A'
    ['Ê']='{E'
    ['Î']='{I'
    ['Ô']='{O'
    ['Û']='{U'

    # Acute accent (dead_acute at AC11 unshifted → QWERTY ')
    ['á']="'a"
    ['é']="'e"
    ['í']="'i"
    ['ó']="'o"
    ['ú']="'u"
    ['Á']="'A"
    ['É']="'E"
    ['Í']="'I"
    ['Ó']="'O"
    ['Ú']="'U"

    # Diaeresis (dead_diaeresis at AC11 shifted → QWERTY ")
    ['ä']='"a'
    ['ë']='"e'
    ['ï']='"i'
    ['ö']='"o'
    ['ü']='"u'
    ['Ä']='"A'
    ['Ë']='"E'
    ['Ï']='"I'
    ['Ö']='"O'
    ['Ü']='"U'

    # ===== LIGATURES =====
    ['œ']='oe'
    ['Œ']='OE'
    ['æ']='ae'
    ['Æ']='AE'
)
