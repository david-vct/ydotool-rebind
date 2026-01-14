#!/bin/bash

# Script to translate AZERTY layout text to QWERTY layout for ydotool
# Since ydotool uses QWERTY internally, text input in AZERTY needs translation
# 
# This script translates French AZERTY keyboard input to equivalent QWERTY keys
# so that ydotool types the correct characters when run on an AZERTY system.

# Function to translate AZERTY to QWERTY
translate_azerty_to_qwerty() {
    local text="$1"
    local result=""
    
    for (( i=0; i<${#text}; i++ )); do
        char="${text:$i:1}"
        
        case "$char" in
            # ===== NUMBERS ROW (Top row) =====
            # AZERTY number keys (when not shifted)
            '&') result+='1' ;;   # AZERTY & (unshifted 1) → QWERTY 1
            'é') result+='2' ;;   # AZERTY é (unshifted 2) → QWERTY 2
            '"') result+='3' ;;   # AZERTY " (unshifted 3) → QWERTY 3
            "'") result+='4' ;;   # AZERTY ' (unshifted 4) → QWERTY 4
            '(') result+='5' ;;   # AZERTY ( (unshifted 5) → QWERTY 5
            '-') result+='6' ;;   # AZERTY - (unshifted 6) → QWERTY 6
            'è') result+='7' ;;   # AZERTY è (unshifted 7) → QWERTY 7
            '_') result+='8' ;;   # AZERTY _ (unshifted 8) → QWERTY 8
            'ç') result+='9' ;;   # AZERTY ç (unshifted 9) → QWERTY 9
            'à') result+='0' ;;   # AZERTY à (unshifted 0) → QWERTY 0
            ')') result+='-' ;;   # AZERTY ) (shift 0) → QWERTY -
            '=') result+='=' ;;   # AZERTY = → QWERTY =
            
            # AZERTY shifted numbers (shifted = symbols)
            '1') result+='!' ;;   # AZERTY 1 (shifted &) → QWERTY !
            '2') result+='@' ;;   # AZERTY 2 (shifted é) → QWERTY @
            '3') result+='#' ;;   # AZERTY 3 (shifted ") → QWERTY #
            '4') result+='$' ;;   # AZERTY 4 (shifted ') → QWERTY $
            '5') result+='%' ;;   # AZERTY 5 (shifted () → QWERTY %
            '6') result+='^' ;;   # AZERTY 6 (shifted -) → QWERTY ^
            '7') result+='&' ;;   # AZERTY 7 (shifted è) → QWERTY &
            '8') result+='*' ;;   # AZERTY 8 (shifted _) → QWERTY *
            '9') result+='(' ;;   # AZERTY 9 (shifted ç) → QWERTY (
            '0') result+=')' ;;   # AZERTY 0 (shifted à) → QWERTY )
            '°') result+='_' ;;   # AZERTY ° (shift +) → QWERTY _
            '+') result+='+' ;;   # AZERTY + (AZERTY key) → QWERTY +
            
            # Accented uppercase symbols
            'É') result+='2' ;;   # AZERTY É → QWERTY 2
            'È') result+='7' ;;   # AZERTY È → QWERTY 7
            'À') result+='0' ;;   # AZERTY À → QWERTY 0
            'Ç') result+='9' ;;   # AZERTY Ç → QWERTY 9
            'Ù') result+="'" ;;   # AZERTY Ù → QWERTY '
            
            # ===== ACCENTED VOWELS =====
            # Circumflex accent (lowercase)
            'â') result+='a' ;;   # AZERTY â → QWERTY a
            'ê') result+='e' ;;   # AZERTY ê → QWERTY e
            'î') result+='i' ;;   # AZERTY î → QWERTY i
            'ô') result+='o' ;;   # AZERTY ô → QWERTY o
            'û') result+='u' ;;   # AZERTY û → QWERTY u
            
            # Circumflex accent (uppercase)
            'Â') result+='A' ;;
            'Ê') result+='E' ;;
            'Î') result+='I' ;;
            'Ô') result+='O' ;;
            'Û') result+='U' ;;
            
            # Diaeresis/Umlaut (lowercase)
            'ä') result+='a' ;;
            'ë') result+='e' ;;
            'ï') result+='i' ;;
            'ö') result+='o' ;;
            'ü') result+='u' ;;
            
            # Diaeresis/Umlaut (uppercase)
            'Ä') result+='A' ;;
            'Ë') result+='E' ;;
            'Ï') result+='I' ;;
            'Ö') result+='O' ;;
            'Ü') result+='U' ;;
            
            # Acute accent (lowercase)
            'á') result+='a' ;;
            'í') result+='i' ;;
            'ó') result+='o' ;;
            'ú') result+='u' ;;
            
            # Acute accent (uppercase)
            'Á') result+='A' ;;
            'Í') result+='I' ;;
            'Ó') result+='O' ;;
            'Ú') result+='U' ;;
            
            # Grave accent (lowercase)
            'ò') result+='o' ;;
            'ì') result+='i' ;;
            'ù') result+="'" ;;
            
            # Special ligatures
            'œ') result+='oe' ;;
            'Œ') result+='OE' ;;
            'æ') result+='ae' ;;
            'Æ') result+='AE' ;;
            'ñ') result+='n' ;;
            'Ñ') result+='N' ;;
            
            # ===== AZERTY LETTER ROWS =====
            # AZERTY second row (ZERTY on French)
            'a') result+='q' ;;   # AZERTY a → QWERTY q
            'z') result+='w' ;;   # AZERTY z → QWERTY w
            'e') result+='e' ;;   # AZERTY e → QWERTY e (same)
            'r') result+='r' ;;   # AZERTY r → QWERTY r (same)
            't') result+='t' ;;   # AZERTY t → QWERTY t (same)
            'y') result+='y' ;;   # AZERTY y → QWERTY y (same)
            'u') result+='u' ;;   # AZERTY u → QWERTY u (same)
            'i') result+='i' ;;   # AZERTY i → QWERTY i (same)
            'o') result+='o' ;;   # AZERTY o → QWERTY o (same)
            'p') result+='p' ;;   # AZERTY p → QWERTY p (same)
            
            # AZERTY second row uppercase
            'A') result+='Q' ;;
            'Z') result+='W' ;;
            'E') result+='E' ;;
            'R') result+='R' ;;
            'T') result+='T' ;;
            'Y') result+='Y' ;;
            'U') result+='U' ;;
            'I') result+='I' ;;
            'O') result+='O' ;;
            'P') result+='P' ;;
            
            # AZERTY home row (QSDFG)
            'q') result+='a' ;;   # AZERTY q → QWERTY a
            's') result+='s' ;;   # AZERTY s → QWERTY s (same)
            'd') result+='d' ;;   # AZERTY d → QWERTY d (same)
            'f') result+='f' ;;   # AZERTY f → QWERTY f (same)
            'g') result+='g' ;;   # AZERTY g → QWERTY g (same)
            'h') result+='h' ;;   # AZERTY h → QWERTY h (same)
            'j') result+='j' ;;   # AZERTY j → QWERTY j (same)
            'k') result+='k' ;;   # AZERTY k → QWERTY k (same)
            'l') result+='l' ;;   # AZERTY l → QWERTY l (same)
            'm') result+=';' ;;   # AZERTY m → QWERTY ;
            
            # AZERTY home row uppercase
            'Q') result+='A' ;;
            'S') result+='S' ;;
            'D') result+='D' ;;
            'F') result+='F' ;;
            'G') result+='G' ;;
            'H') result+='H' ;;
            'J') result+='J' ;;
            'K') result+='K' ;;
            'L') result+='L' ;;
            'M') result+=':' ;;
            
            # AZERTY bottom row (WXCVBN)
            'w') result+='z' ;;   # AZERTY w → QWERTY z
            'x') result+='x' ;;   # AZERTY x → QWERTY x (same)
            'c') result+='c' ;;   # AZERTY c → QWERTY c (same)
            'v') result+='v' ;;   # AZERTY v → QWERTY v (same)
            'b') result+='b' ;;   # AZERTY b → QWERTY b (same)
            'n') result+='n' ;;   # AZERTY n → QWERTY n (same)
            ',') result+='m' ;;   # AZERTY , → QWERTY m
            ';') result+=',' ;;   # AZERTY ; → QWERTY ,
            ':') result+='.' ;;   # AZERTY : → QWERTY .
            '!') result+='/' ;;   # AZERTY ! (shift /) → QWERTY /
            
            # AZERTY bottom row uppercase
            'W') result+='Z' ;;
            'X') result+='X' ;;
            'C') result+='C' ;;
            'V') result+='V' ;;
            'B') result+='B' ;;
            'N') result+='N' ;;
            '?') result+='M' ;;   # AZERTY ? → QWERTY M
            '.') result+='<' ;;   # AZERTY . (shift ,) → QWERTY <
            '/') result+='>' ;;   # AZERTY / (shift ;) → QWERTY >
            '§') result+='?' ;;   # AZERTY § → QWERTY ?
            
            # ===== SPECIAL CHARACTERS =====
            '[') result+='[' ;;   # Keep square brackets
            ']') result+=']' ;;
            '{') result+='{' ;;   # Keep curly braces
            '}') result+='}' ;;
            '(') result+='(' ;;   # Keep parentheses (already mapped above)
            ')') result+=')' ;;
            '<') result+='<' ;;   # Keep angle brackets
            '>') result+='>' ;;
            '\') result+='\\' ;;  # Keep backslash
            '|') result+='|' ;;   # Keep pipe
            '@') result+='@' ;;   # Keep at sign
            '#') result+='#' ;;   # Keep hash
            '~') result+='~' ;;   # Keep tilde
            '`') result+='`' ;;   # Keep backtick
            '^') result+='^' ;;   # Keep caret
            '&') result+='&' ;;   # Keep ampersand (already mapped above)
            '*') result+='*' ;;   # Keep asterisk
            '%') result+='%' ;;   # Keep percent
            '$') result+='$' ;;   # Keep dollar
            
            # ===== DEFAULT =====
            # Keep all other characters as-is (space, newline, digits in text, etc.)
            *) result+="$char" ;;
        esac
    done
    
    echo "$result"
}
    
# Parse command line arguments
options=()
text="$*"
file_mode=0

# Handle ydotool type command options
while [ $# -gt 0 ]; do
    case "$1" in
        -d|--key-delay)
            options+=("$1" "$2")
            shift 2
            ;;
        -H|--key-hold)
            options+=("$1" "$2")
            shift 2
            ;;
        -D|--next-delay)
            options+=("$1" "$2")
            shift 2
            ;;
        -f|--file)
            # File mode - pass through without translation
            file_mode=1
            options+=("$1" "$2")
            shift 2
            ;;
        -e|--escape)
            options+=("$1" "$2")
            shift 2
            ;;
        -h|--help)
            # Pass through help to ydotool-real
            /usr/bin/ydotool-real type --help
            exit 0
            ;;
        -d=*|--key-delay=*)
            options+=("$1")
            shift
            ;;
        -H=*|--key-hold=*)
            options+=("$1")
            shift
            ;;
        -D=*|--next-delay=*)
            options+=("$1")
            shift
            ;;
        -f=*|--file=*)
            # File mode - pass through without translation
            file_mode=1
            options+=("$1")
            shift
            ;;
        -e=*|--escape=*)
            options+=("$1")
            shift
            ;;
        --)
            shift
            text="$*"
            break
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            # Rest is text to type
            text="$*"
            break
            ;;
    esac
done

# If file mode, pass everything through without translation
if [ "$file_mode" -eq 1 ]; then
    /usr/bin/ydotool-real type "${options[@]}"
    exit $?
fi

# Translate AZERTY to QWERTY

translated=$(translate_azerty_to_qwerty "$text")

# Debug output if DEBUG env var is set
if [ -n "$DEBUG" ]; then
    {
        echo "=== Command Debug Log ==="
        echo "Timestamp: $(date)"
        echo "Full command: $0 $@"
        echo "Options: ${options[*]}"
        echo "Text: $text"
        echo "File mode: $file_mode"
        echo "Translated: $translated"
        echo "Command executed: /usr/bin/ydotool-real type ${options[*]} \"$translated\""
        echo ""
    } >> /tmp/ydotool-translate-debug.log
fi

# Type the translated text using ydotool-real
/usr/bin/ydotool-real type "${options[@]}" "$translated"
