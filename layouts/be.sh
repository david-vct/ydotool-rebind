#!/bin/bash
# Belgian AZERTY layout mapping to QWERTY
# Source: /usr/share/X11/xkb/symbols/be (basic)
#
# Very similar to French AZERTY with differences on number row
# and some special characters.
#
# Only non-identity mappings are listed.
# Characters not in this map pass through unchanged.

declare -A KEYMAP=(
    # ===== NUMBER ROW =====
    # Unshifted
    ['&']='1'
    ['é']='2'
    ['"']='3'
    ["'"]='4'
    ['(']='5'
    ['§']='6'     # BE has § here (FR has -)
    ['è']='7'
    ['!']='8'     # BE has ! here (FR has _)
    ['ç']='9'
    ['à']='0'
    [')']='-'
    ['-']='='     # BE has - at AE12 (FR has =)

    # Shifted
    ['1']='!'
    ['2']='@'
    ['3']='#'
    ['4']='$'
    ['5']='%'
    ['6']='^'
    ['7']='&'
    ['8']='*'
    ['9']='('
    ['0']=')'
    ['°']='_'
    ['_']='+'     # BE has _ at Shift+AE12 (FR has +)

    # Accented uppercase on number row
    ['É']='2'
    ['È']='7'
    ['À']='0'
    ['Ç']='9'
    ['Ù']="'"

    # ===== CIRCUMFLEX ACCENTS (dead key ^ at AD11 = [ on QWERTY) =====
    ['â']='[q'
    ['ê']='[e'
    ['î']='[i'
    ['ô']='[o'
    ['û']='[u'
    ['Â']='[Q'
    ['Ê']='[E'
    ['Î']='[I'
    ['Ô']='[O'
    ['Û']='[U'

    # ===== DIAERESIS (dead key ¨ at Shift+AD11 = { on QWERTY) =====
    ['ä']='{q'
    ['ë']='{e'
    ['ï']='{i'
    ['ö']='{o'
    ['ü']='{u'
    ['Ä']='{Q'
    ['Ë']='{E'
    ['Ï']='{I'
    ['Ö']='{O'
    ['Ü']='{U'

    # ===== ACUTE ACCENT (no easy dead key, fallback to base letter) =====
    ['á']='q'
    ['í']='i'
    ['ó']='o'
    ['ú']='u'
    ['Á']='Q'
    ['Í']='I'
    ['Ó']='O'
    ['Ú']='U'

    # ===== GRAVE ACCENT =====
    ['ò']='o'
    ['ì']='i'
    ['ù']="'"

    # ===== LIGATURES =====
    ['œ']='oe'
    ['Œ']='OE'
    ['æ']='ae'
    ['Æ']='AE'
    ['ñ']='n'
    ['Ñ']='N'

    # ===== LETTER ROWS =====
    # Top row (AZERTY → QWERTY position)
    ['a']='q'
    ['z']='w'
    ['A']='Q'
    ['Z']='W'
    # AD12: $ / * → QWERTY ] / }
    ['$']=']'
    ['*']='}'

    # Home row
    ['q']='a'
    ['Q']='A'
    ['m']=';'
    ['M']=':'
    # AC11 shifted: % → "
    ['%']='"'
    # BKSL: µ / £ → QWERTY \ / |
    ['µ']='\\'
    ['£']='|'

    # Bottom row
    ['w']='z'
    ['W']='Z'
    [',']='m'
    [';']=','
    [':']='.'
    # AB10: = / + → QWERTY / / ?
    ['=']='/'
    ['+']='?'

    # Shifted bottom row
    ['?']='M'
    ['.']='<'
    ['/']='>'

    # TLDE: ² / ³ → QWERTY ` / ~
    ['²']='`'
    ['³']='~'
)
