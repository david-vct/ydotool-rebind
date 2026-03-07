#!/bin/bash
# German QWERTZ layout mapping to QWERTY
# Source: /usr/share/X11/xkb/symbols/de (basic) + latin(type4)
#
# Only non-identity mappings are listed.
# Characters not in this map pass through unchanged.

declare -A KEYMAP=(
    # ===== NUMBER ROW (shifted differences) =====
    ['"']='@'     # Shift+2: DE " → US @
    ['§']='#'     # Shift+3: DE § → US #
    ['&']='^'     # Shift+6: DE & → US ^
    ['/']='&'     # Shift+7: DE / → US &
    ['(']='*'     # Shift+8: DE ( → US *
    [')']='('     # Shift+9: DE ) → US (
    ['=']=')'     # Shift+0: DE = → US )
    ['ß']='-'     # AE11 unshifted
    ['?']='_'     # AE11 shifted
    ['°']='~'     # TLDE shifted: DE ° → US ~

    # ===== LETTER SWAPS =====
    ['z']='y'     # AD06: DE z → US y
    ['Z']='Y'
    ['y']='z'     # AB01: DE y → US z
    ['Y']='Z'

    # ===== SPECIAL KEYS =====
    # AD11: ü/Ü → QWERTY [/{
    ['ü']='['
    ['Ü']='{'
    # AD12: +/* → QWERTY ]/}
    ['+']=']'
    ['*']='}'
    # AC10: ö/Ö → QWERTY ;/:
    ['ö']=';'
    ['Ö']=':'
    # AC11: ä/Ä → QWERTY '/"
    ['ä']="'"
    ['Ä']='"'
    # BKSL: #/' → QWERTY \/|
    ['#']='\\'
    ["'"]='|'
    # AB08 shifted: ; → <
    [';']='<'
    # AB09 shifted: : → >
    [':']='>'
    # AB10: -/_ → QWERTY //?
    ['-']='/'
    ['_']='?'

    # ===== DEAD KEY ACCENTS =====
    # Circumflex (dead_circumflex at TLDE → QWERTY `)
    ['â']='`a'
    ['ê']='`e'
    ['î']='`i'
    ['ô']='`o'
    ['û']='`u'
    ['Â']='`A'
    ['Ê']='`E'
    ['Î']='`I'
    ['Ô']='`O'
    ['Û']='`U'

    # Acute accent (dead_acute at AE12 → QWERTY =)
    ['á']='=a'
    ['é']='=e'
    ['í']='=i'
    ['ó']='=o'
    ['ú']='=u'
    ['Á']='=A'
    ['É']='=E'
    ['Í']='=I'
    ['Ó']='=O'
    ['Ú']='=U'

    # Grave accent (dead_grave at Shift+AE12 → QWERTY +)
    ['à']='+a'
    ['è']='+e'
    ['ì']='+i'
    ['ò']='+o'
    ['ù']='+u'
    ['À']='+A'
    ['È']='+E'
    ['Ì']='+I'
    ['Ò']='+O'
    ['Ù']='+U'

    # Ligatures (expand to multi-char)
    ['œ']='oe'
    ['Œ']='OE'
    ['æ']='ae'
    ['Æ']='AE'
    ['ñ']='n'
    ['Ñ']='N'
)
