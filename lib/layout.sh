#!/bin/bash

if [[ -n "${YDTR_LAYOUT_LOADED:-}" && "${BASH_SOURCE[0]}" != "$0" ]]; then
    return 0
fi

YDTR_LAYOUT_LOADED=1

LAYOUT_LIB_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# shellcheck source=/dev/null
source "$LAYOUT_LIB_DIR/utils.sh"

ydtr_detect_layout() {
    if [[ -n "${YDOTOOL_LAYOUT:-}" ]]; then
        printf '%s\n' "$YDOTOOL_LAYOUT"
        return 0
    fi

    local config_path
    config_path="$(ydtr_config_path)"
    if [[ -f "$config_path" ]]; then
        local layout
        layout="$(grep -m1 '^LAYOUT=' "$config_path" 2>/dev/null | cut -d= -f2)"
        if [[ -n "$layout" ]]; then
            printf '%s\n' "$layout"
            return 0
        fi
    fi

    if command -v setxkbmap >/dev/null 2>&1; then
        local x11_layout x11_variant
        x11_layout="$(setxkbmap -query 2>/dev/null | grep -m1 '^layout:' | awk '{print $2}' | cut -d, -f1)"
        x11_variant="$(setxkbmap -query 2>/dev/null | grep -m1 '^variant:' | awk '{print $2}' | cut -d, -f1)"
        if [[ -n "$x11_layout" ]]; then
            ydtr_resolve_layout_variant "$x11_layout" "$x11_variant"
            return 0
        fi
    fi

    if command -v localectl >/dev/null 2>&1; then
        local localectl_layout localectl_variant
        localectl_layout="$(localectl status 2>/dev/null | grep -m1 'X11 Layout' | awk '{print $3}' | cut -d, -f1)"
        localectl_variant="$(localectl status 2>/dev/null | grep -m1 'X11 Variant' | awk '{print $3}' | cut -d, -f1)"
        if [[ -n "$localectl_layout" ]]; then
            ydtr_resolve_layout_variant "$localectl_layout" "$localectl_variant"
            return 0
        fi
    fi

    printf '%s\n' 'fr'
}

# Prefer a variant-specific layout file (e.g. ch + fr → ch_fr)
# when one exists, otherwise fall back to the base layout name.
ydtr_resolve_layout_variant() {
    local layout="$1"
    local variant="${2:-}"

    if [[ -n "$variant" ]] && ydtr_layout_path "${layout}_${variant}" >/dev/null 2>&1; then
        printf '%s\n' "${layout}_${variant}"
        return 0
    fi

    printf '%s\n' "$layout"
}

ydtr_layout_path() {
    local layout="$1"
    local share_dir
    share_dir="$(ydtr_share_dir)"

    local -a candidates=(
        "${share_dir}/layouts/${layout}.sh"
        "/etc/${YDTR_PROJECT_NAME}/layouts/${layout}.sh"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -f "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    echo "Error: layout '${layout}' not found" >&2
    return 1
}

ydtr_load_layout() {
    local layout="$1"
    local layout_path
    layout_path="$(ydtr_layout_path "$layout")"

    YDTR_KEYMAP=()

    # shellcheck source=/dev/null
    source "$layout_path"
}

ydtr_layout_main() {
    case "${1:-detect-layout}" in
        detect-layout)
            ydtr_detect_layout
            ;;
        *)
            echo "Unknown command: ${1:-}" >&2
            echo "Usage: layout.sh detect-layout" >&2
            return 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    ydtr_layout_main "$@"
fi