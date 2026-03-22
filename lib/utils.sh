#!/bin/bash

if [[ -n "${YDTR_UTILS_LOADED:-}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
    return 0
fi

YDTR_UTILS_LOADED=1

YDTR_PROJECT_NAME="ydotool-rebind"
YDTR_DEFAULT_PREFIX="/usr/local"
YDTR_DEFAULT_SYSTEM_YDOTOOL="/usr/bin/ydotool"
YDTR_DEBUG_LOG_PATH="${YDTR_DEBUG_LOG:-/tmp/ydotool-rebind-debug.log}"

declare -gA YDTR_KEYMAP=()
declare -ga YDTR_TYPE_OPTIONS=()
declare -g YDTR_TYPE_FILE_MODE=0
declare -g YDTR_TYPE_FILE_PATH=""
declare -g YDTR_TYPE_TEXT=""
declare -g YDTR_TYPE_SHOW_HELP=0

ydtr_lib_dir() {
    local source_path="${BASH_SOURCE[0]}"
    if [[ -n "${YDTR_LIB_DIR:-}" ]]; then
        printf '%s\n' "$YDTR_LIB_DIR"
        return 0
    fi

    printf '%s\n' "$(dirname "$(readlink -f "$source_path")")"
}

ydtr_share_dir() {
    local lib_dir
    lib_dir="$(ydtr_lib_dir)"

    local -a candidates=(
        "${YDTR_SHARE_DIR:-}"
        "${lib_dir}/../share"
        "${lib_dir}/../share/${YDTR_PROJECT_NAME}"
        "${YDTR_DEFAULT_PREFIX}/share/${YDTR_PROJECT_NAME}"
        "/etc/${YDTR_PROJECT_NAME}"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -n "$candidate" && -d "$candidate/layouts" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    echo "Error: unable to locate shared data directory" >&2
    return 1
}

ydtr_config_path() {
    local -a candidates=(
        "${YDTR_CONFIG:-}"
        "${YDTR_DEFAULT_PREFIX}/etc/${YDTR_PROJECT_NAME}.conf"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -n "$candidate" && -f "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    printf '%s\n' "${YDTR_DEFAULT_PREFIX}/etc/${YDTR_PROJECT_NAME}.conf"
}

ydtr_resolve_system_ydotool() {
    local -a candidates=(
        "${YDTR_SYSTEM_YDOTOOL:-}"
        "${YDTR_DEFAULT_SYSTEM_YDOTOOL}"
        "/bin/ydotool"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -n "$candidate" && -x "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    echo "Error: ydotool not found" >&2
    return 1
}

ydtr_debug_log() {
    [[ -n "${DEBUG:-}" ]] || return 0

    {
        printf '=== ydotool-rebind debug ===\n'
        printf 'timestamp=%s\n' "$(date)"
        printf 'script=%s\n' "${BASH_SOURCE[1]:-unknown}"
        printf '%s\n' "$@"
        printf '\n'
    } >> "$YDTR_DEBUG_LOG_PATH"
}