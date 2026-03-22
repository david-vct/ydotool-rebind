#!/bin/bash

if [[ -n "${YDTR_TRANSLATE_LOADED:-}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
    return 0
fi

YDTR_TRANSLATE_LOADED=1

TRANSLATE_LIB_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# shellcheck source=/dev/null
source "$TRANSLATE_LIB_DIR/utils.sh"
# shellcheck source=/dev/null
source "$TRANSLATE_LIB_DIR/layout.sh"

ydtr_translate_text() {
    local text="$1"
    local translated=""
    local char
    local index

    for (( index=0; index<${#text}; index++ )); do
        char="${text:index:1}"

        if [[ -n "${YDTR_KEYMAP[$char]+x}" ]]; then
            translated+="${YDTR_KEYMAP[$char]}"
        else
            translated+="$char"
        fi
    done

    printf '%s' "$translated"
}

ydtr_reset_type_args() {
    YDTR_TYPE_OPTIONS=()
    YDTR_TYPE_FILE_MODE=0
    YDTR_TYPE_FILE_PATH=""
    YDTR_TYPE_TEXT=""
    YDTR_TYPE_SHOW_HELP=0
}

ydtr_parse_type_args() {
    ydtr_reset_type_args

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--key-delay|-H|--key-hold|-D|--next-delay|-e|--escape)
                if [[ $# -lt 2 ]]; then
                    echo "Missing value for option: $1" >&2
                    return 1
                fi
                YDTR_TYPE_OPTIONS+=("$1" "$2")
                shift 2
                ;;
            -f|--file)
                if [[ $# -lt 2 ]]; then
                    echo "Missing value for option: $1" >&2
                    return 1
                fi
                YDTR_TYPE_FILE_MODE=1
                YDTR_TYPE_FILE_PATH="$2"
                shift 2
                ;;
            -h|--help)
                YDTR_TYPE_SHOW_HELP=1
                shift
                ;;
            -d=*|--key-delay=*|-H=*|--key-hold=*|-D=*|--next-delay=*|-e=*|--escape=*)
                YDTR_TYPE_OPTIONS+=("$1")
                shift
                ;;
            -f=*|--file=*)
                YDTR_TYPE_FILE_MODE=1
                YDTR_TYPE_FILE_PATH="${1#*=}"
                shift
                ;;
            --)
                shift
                YDTR_TYPE_TEXT="$*"
                break
                ;;
            -*)
                echo "Unknown option: $1" >&2
                return 1
                ;;
            *)
                YDTR_TYPE_TEXT="$*"
                break
                ;;
        esac
    done
}

ydtr_type_input() {
    if [[ "$YDTR_TYPE_FILE_MODE" -eq 1 ]]; then
        if [[ "$YDTR_TYPE_FILE_PATH" == "-" ]]; then
            cat
        else
            cat -- "$YDTR_TYPE_FILE_PATH"
        fi
        return 0
    fi

    printf '%s' "$YDTR_TYPE_TEXT"
}

ydtr_translate_type_input() {
    local layout
    layout="$(ydtr_detect_layout)"

    local input_text
    input_text="$(ydtr_type_input)"

    if [[ "$layout" == "us" ]]; then
        printf '%s' "$input_text"
        return 0
    fi

    ydtr_load_layout "$layout"
    ydtr_translate_text "$input_text"
}

ydtr_translate_usage() {
    cat <<'EOF'
Usage:
  translate.sh translate [ydotool type options] [text]
  translate.sh detect-layout
  translate.sh help

Commands:
  translate      Translate input to the QWERTY sequence expected by ydotool.
  detect-layout  Print the detected source layout.
  help           Show this message.
EOF
}

ydtr_translate_main() {
    local command="${1:-help}"

    case "$command" in
        translate)
            shift
            ydtr_parse_type_args "$@" || return 1

            if [[ "$YDTR_TYPE_SHOW_HELP" -eq 1 ]]; then
                ydtr_translate_usage
                return 0
            fi

            ydtr_translate_type_input
            ;;
        detect-layout)
            ydtr_detect_layout
            ;;
        help|-h|--help)
            ydtr_translate_usage
            ;;
        *)
            ydtr_parse_type_args "$@" || return 1
            ydtr_translate_type_input
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    ydtr_translate_main "$@"
fi