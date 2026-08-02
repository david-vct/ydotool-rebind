#!/bin/bash

# Swiss French (Suisse romande) QWERTZ layout mapping to QWERTY
# Source: /usr/share/X11/xkb/symbols/ch (fr variant)
#
# Only non-identity mappings are listed.
# Characters not in this map pass through unchanged.
# AltGr-level characters (@, #, \, |, ~, etc.) are not reachable
# through ydotool's QWERTY character set and pass through as-is.

YDTR_KEYMAP=(
    # ===== NUMBER ROW (shifted differences) =====
    ['+']='!'     # Shift+1: CH + → US !
    ['"']='@'     # Shift+2: CH " → US @
    ['*']='#'     # Shift+3: CH * → US #
    ['ç']='$'     # Shift+4: CH ç → US $
    ['&']='^'     # Shift+6: CH & → US ^
    ['/']='&'     # Shift+7: CH / → US &
    ['(']='*'     # Shift+8: CH ( → US *
    [')']='('     # Shift+9: CH ) → US (
    ['=']=')'     # Shift+0: CH = → US )
    ['Ç']='$'     # No direct key, fallback to ç

    # ===== TLDE / AE11 =====
    ['§']='`'     # TLDE unshifted
    ['°']='~'     # TLDE shifted
    ["'"]='-'     # AE11 unshifted
    ['?']='_'     # AE11 shifted

    # ===== LETTER SWAPS (QWERTZ) =====
    ['z']='y'     # AD06: CH z → US y
    ['Z']='Y'
    ['y']='z'     # AB01: CH y → US z
    ['Y']='Z'

    # ===== DIRECT ACCENTED KEYS =====
    # AD11: è/ü → QWERTY [/{
    ['è']='['
    ['ü']='{'
    # AC10: é/ö → QWERTY ;/:
    ['é']=';'
    ['ö']=':'
    # AC11: à/ä → QWERTY '/"
    ['à']="'"
    ['ä']='"'

    # ===== SPECIAL KEYS =====
    ['!']='}'     # AD12 shifted
    ['$']='\\'    # BKSL unshifted
    ['£']='|'     # BKSL shifted
    [';']='<'     # AB08 shifted
    [':']='>'     # AB09 shifted
    ['-']='/'     # AB10 unshifted
    ['_']='?'     # AB10 shifted

    # ===== DEAD KEY ACCENTS =====
    # Circumflex (dead_circumflex at AE12 → QWERTY =)
    ['â']='=a'
    ['ê']='=e'
    ['î']='=i'
    ['ô']='=o'
    ['û']='=u'
    ['Â']='=A'
    ['Ê']='=E'
    ['Î']='=I'
    ['Ô']='=O'
    ['Û']='=U'
    ['^']='= '    # dead_circumflex + space → literal ^

    # Grave accent (dead_grave at Shift+AE12 → QWERTY +)
    ['ì']='+i'
    ['ò']='+o'
    ['ù']='+u'
    ['À']='+A'
    ['È']='+E'
    ['Ì']='+I'
    ['Ò']='+O'
    ['Ù']='+U'
    ['`']='+ '    # dead_grave + space → literal `

    # Diaeresis (dead_diaeresis at AD12 → QWERTY ])
    ['ë']=']e'
    ['ï']=']i'
    ['Ä']=']A'
    ['Ë']=']E'
    ['Ï']=']I'
    ['Ö']=']O'
    ['Ü']=']U'

    # ===== ACUTE ACCENT (dead key on AltGr, fallback to base letter) =====
    ['á']='a'
    ['í']='i'
    ['ó']='o'
    ['ú']='u'
    ['Á']='A'
    ['É']=';'     # No direct key, fallback to é
    ['Í']='I'
    ['Ó']='O'
    ['Ú']='U'

    # ===== LIGATURES =====
    ['œ']='oe'
    ['Œ']='OE'
    ['æ']='ae'
    ['Æ']='AE'
    ['ñ']='n'
    ['Ñ']='N'
    ['ß']='ss'
)
