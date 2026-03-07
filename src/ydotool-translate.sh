#!/bin/bash

# Generic keyboard layout translation engine for ydotool
# Translates text from a source keyboard layout to QWERTY
# so that ydotool types the correct characters on non-QWERTY systems.

# Detect which keyboard layout to use
# Cascade: YDOTOOL_LAYOUT env → config file → setxkbmap → localectl → fallback fr
detect_layout() {
    # 1. Environment variable
    if [[ -n "$YDOTOOL_LAYOUT" ]]; then
        echo "$YDOTOOL_LAYOUT"
        return
    fi

    # 2. Config file
    local config="/etc/ydotool-rebind/config"
    if [[ -f "$config" ]]; then
        local layout
        layout=$(grep -m1 '^LAYOUT=' "$config" 2>/dev/null | cut -d= -f2)
        if [[ -n "$layout" ]]; then
            echo "$layout"
            return
        fi
    fi

    # 3. setxkbmap (X11)
    if command -v setxkbmap &>/dev/null; then
        local layout
        layout=$(setxkbmap -query 2>/dev/null | grep -m1 '^layout:' | awk '{print $2}' | cut -d, -f1)
        if [[ -n "$layout" ]]; then
            echo "$layout"
            return
        fi
    fi

    # 4. localectl (systemd)
    if command -v localectl &>/dev/null; then
        local layout
        layout=$(localectl status 2>/dev/null | grep -m1 'X11 Layout' | awk '{print $3}' | cut -d, -f1)
        if [[ -n "$layout" ]]; then
            echo "$layout"
            return
        fi
    fi

    # 5. Fallback
    echo "fr"
}

# Load a layout file (declares KEYMAP associative array)
load_layout() {
    local layout="$1"

    # Resolve script directory (follows symlinks)
    local script_real_path
    script_real_path="$(readlink -f "${BASH_SOURCE[0]}")"
    local script_dir
    script_dir="$(dirname "$script_real_path")"

    # Search paths: installed location, then dev location
    local layout_file=""
    if [[ -f "/etc/ydotool-rebind/layouts/${layout}.sh" ]]; then
        layout_file="/etc/ydotool-rebind/layouts/${layout}.sh"
    elif [[ -f "${script_dir}/../layouts/${layout}.sh" ]]; then
        layout_file="${script_dir}/../layouts/${layout}.sh"
    fi

    if [[ -z "$layout_file" ]]; then
        echo "Error: layout '${layout}' not found" >&2
        echo "Searched: /etc/ydotool-rebind/layouts/${layout}.sh" >&2
        echo "          ${script_dir}/../layouts/${layout}.sh" >&2
        exit 1
    fi

    # shellcheck source=/dev/null
    source "$layout_file"
}

# Translate text using the loaded KEYMAP
translate_text() {
    local text="$1"
    local result=""

    for (( i=0; i<${#text}; i++ )); do
        char="${text:$i:1}"

        if [[ -n "${KEYMAP[$char]+x}" ]]; then
            result+="${KEYMAP[$char]}"
        else
            result+="$char"
        fi
    done

    echo "$result"
}

# --- Main ---

# Detect and load layout
LAYOUT=$(detect_layout)

# Short-circuit: no translation needed for US QWERTY
if [[ "$LAYOUT" == "us" ]]; then
    # Parse options, then pass everything through to ydotool-real
    options=()
    text="$*"
    file_mode=0
    file_path=""

    while [ $# -gt 0 ]; do
        case "$1" in
            -d|--key-delay|-H|--key-hold|-D|--next-delay|-e|--escape)
                options+=("$1" "$2"); shift 2 ;;
            -f|--file)
                file_mode=1; file_path="$2"; shift 2 ;;
            -h|--help)
                /usr/bin/ydotool-real type --help; exit 0 ;;
            -d=*|--key-delay=*|-H=*|--key-hold=*|-D=*|--next-delay=*|-e=*|--escape=*)
                options+=("$1"); shift ;;
            -f=*|--file=*)
                file_mode=1; file_path="${1#*=}"; shift ;;
            --) shift; text="$*"; break ;;
            -*) echo "Unknown option: $1" >&2; exit 1 ;;
            *) text="$*"; break ;;
        esac
    done

    if [ "$file_mode" -eq 1 ]; then
        /usr/bin/ydotool-real type "${options[@]}" --file "$file_path"
    else
        /usr/bin/ydotool-real type "${options[@]}" "$text"
    fi
    exit $?
fi

# Load layout mapping
load_layout "$LAYOUT"

# Parse command line arguments
options=()
text="$*"
file_mode=0
file_path=""

while [ $# -gt 0 ]; do
    case "$1" in
        -d|--key-delay)
            options+=("$1" "$2"); shift 2 ;;
        -H|--key-hold)
            options+=("$1" "$2"); shift 2 ;;
        -D|--next-delay)
            options+=("$1" "$2"); shift 2 ;;
        -f|--file)
            file_mode=1; file_path="$2"; shift 2 ;;
        -e|--escape)
            options+=("$1" "$2"); shift 2 ;;
        -h|--help)
            /usr/bin/ydotool-real type --help; exit 0 ;;
        -d=*|--key-delay=*)
            options+=("$1"); shift ;;
        -H=*|--key-hold=*)
            options+=("$1"); shift ;;
        -D=*|--next-delay=*)
            options+=("$1"); shift ;;
        -f=*|--file=*)
            file_mode=1; file_path="${1#*=}"; shift ;;
        -e=*|--escape=*)
            options+=("$1"); shift ;;
        --)
            shift; text="$*"; break ;;
        -*)
            echo "Unknown option: $1" >&2; exit 1 ;;
        *)
            text="$*"; break ;;
    esac
done

# File mode: read, translate, pass via stdin
if [ "$file_mode" -eq 1 ]; then
    if [ "$file_path" = "-" ]; then
        file_content=$(cat)
    else
        file_content=$(cat "$file_path")
    fi

    translated=$(translate_text "$file_content")

    if [ -n "$DEBUG" ]; then
        {
            echo "=== File Mode Debug Log ==="
            echo "Timestamp: $(date)"
            echo "Layout: $LAYOUT"
            echo "Full command: $0 $@"
            echo "Options: ${options[*]}"
            echo "File path: $file_path"
            echo "Original content: $file_content"
            echo "Translated content: $translated"
            echo ""
        } >> /tmp/ydotool-translate-debug.log
    fi

    printf '%s' "$translated" | /usr/bin/ydotool-real type "${options[@]}" --file -
    exit $?
fi

# Direct text mode: translate and type
translated=$(translate_text "$text")

if [ -n "$DEBUG" ]; then
    {
        echo "=== Command Debug Log ==="
        echo "Timestamp: $(date)"
        echo "Layout: $LAYOUT"
        echo "Full command: $0 $@"
        echo "Options: ${options[*]}"
        echo "Text: $text"
        echo "Translated: $translated"
        echo "Command executed: /usr/bin/ydotool-real type ${options[*]} \"$translated\""
        echo ""
    } >> /tmp/ydotool-translate-debug.log
fi

/usr/bin/ydotool-real type "${options[@]}" "$translated"
