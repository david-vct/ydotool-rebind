#!/bin/bash

set -euo pipefail

resolve_lib_dir() {
    local script_real_path
    script_real_path="$(readlink -f "${BASH_SOURCE[0]}")"

    local script_dir
    script_dir="$(dirname "$script_real_path")"

    local legacy_lib_dir=""
    if [[ -n "${YDTR_TRANSLATOR:-}" ]]; then
        legacy_lib_dir="$(dirname "$YDTR_TRANSLATOR")"
    fi

    local -a candidates=(
        "${YDTR_LIB_DIR:-}"
        "$legacy_lib_dir"
        "${script_dir}/../lib"
        "/usr/local/lib/ydotool-rebind"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -n "$candidate" && -f "$candidate/utils.sh" && -f "$candidate/layout.sh" && -f "$candidate/translate.sh" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    echo "Error: ydotool-rebind libraries not found" >&2
    return 1
}

LIB_DIR="$(resolve_lib_dir)"

# shellcheck source=/dev/null
source "$LIB_DIR/utils.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/layout.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/translate.sh"

SYSTEM_YDOTOOL="$(ydtr_resolve_system_ydotool)"

if [[ $# -gt 0 && "$1" == "type" ]]; then
    shift
    ydtr_parse_type_args "$@"

    if [[ "$YDTR_TYPE_SHOW_HELP" -eq 1 ]]; then
        exec "$SYSTEM_YDOTOOL" type --help
    fi

    translated_input="$(ydtr_translate_type_input)"
    layout="$(ydtr_detect_layout)"

    if [[ -n "${DEBUG:-}" ]]; then
        ydtr_debug_log \
            "mode=type" \
            "layout=${layout}" \
            "file_mode=${YDTR_TYPE_FILE_MODE}" \
            "file_path=${YDTR_TYPE_FILE_PATH}" \
            "options=${YDTR_TYPE_OPTIONS[*]}" \
            "text=${YDTR_TYPE_TEXT}" \
            "translated=${translated_input}"
    fi

    if [[ "$YDTR_TYPE_FILE_MODE" -eq 1 ]]; then
        printf '%s' "$translated_input" | "$SYSTEM_YDOTOOL" type "${YDTR_TYPE_OPTIONS[@]}" --file -
        exit $?
    fi

    exec "$SYSTEM_YDOTOOL" type "${YDTR_TYPE_OPTIONS[@]}" "$translated_input"
fi

exec "$SYSTEM_YDOTOOL" "$@"