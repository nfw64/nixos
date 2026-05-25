#!/usr/bin/env bash

# File paths (Assuming these are defined earlier in your script)
PERS_FILE="${PERS_FILE:-$HOME/.config/bookmarks/pers}"
WORK_FILE="${WORK_FILE:-$HOME/.config/bookmarks/work}"

# Browsers
FIREFOX="$(command -v firefox || true)"
BRAVE="$(command -v brave || command -v brave-browser || true)"
FALLBACK="$(command -v xdg-open || echo firefox)"

# Ensure files exist
mkdir -p "$(dirname "$PERS_FILE")"
[ -f "$PERS_FILE" ] || cat >"$PERS_FILE" <<'EOF'
# personal
gitpage :: https://github.com/nfw64
yt :: https://youtube.com
EOF
[ -f "$WORK_FILE" ] || cat >"$WORK_FILE" <<'EOF'
# work
[docs] NixOS Manual :: https://nixos.org/manual/
EOF

emit() {
    tag="$1"
    file="$2"
    [ -f "$file" ] || return 0
    grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
        case "$line" in
        *"::"*)
            lhs="${line%%::*}"
            rhs="${line#*::}"
            lhs="$(printf '%s' "$lhs" | sed 's/[[:space:]]*$//')"
            rhs="$(printf '%s' "$rhs" | sed 's/^[[:space:]]*//')"
            printf '[%s] %s :: %s\n' "$tag" "$lhs" "$rhs"
            ;;
        *)
            printf '[%s] %s :: %s\n' "$tag" "$line" "$line"
            ;;
        esac
    done
}

# 1. Generate the combined list into a variable first
LIST="$({
    emit ps "$PERS_FILE"
    emit wk "$WORK_FILE"
} | sort)"

# 2. Calculate the maximum line width dynamically
MAX_LENGTH=$(echo "$LIST" | awk '{print length}' | sort -nr | head -n1)
WIDTH=$((MAX_LENGTH + 4)) # Add 4 characters of padding for borders/icons

# 3. Pass the list to Rofi with the dynamic width injection
choice="$(echo "$LIST" | rofi -dmenu -p 'Bookmarks:' -theme-str "window { width: ${WIDTH}ch; }" || true)"

[ -n "$choice" ] || exit 0

# Parse tag and raw URL
tag="${choice%%]*}"
tag="${tag#\[}"
raw="${choice##* :: }"

# Strip inline comments and trim
raw="$(printf '%s' "$raw" |
    sed -e 's/[[:space:]]\+#.*$//' -e 's/[[:space:]]\/\/.*$//' \
        -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Ensure scheme
case "$raw" in
http://* | https://* | file://* | about:* | chrome:*) url="$raw" ;;
*) url="https://$raw" ;;
esac

# Pick browser by tag (Fixed to match 'ps' and 'wk' used in emit)
open_with() {
    cmd="$1"
    if [ -n "$cmd" ]; then
        nohup "$cmd" --new-tab "$url" >/dev/null 2>&1 &
        exit 0
    fi
}

case "$tag" in
ps) open_with "$FIREFOX" ;;
wk) open_with "$BRAVE" ;;
esac

# Fallback if specific browser not found
nohup $FALLBACK "$url" >/dev/null 2>&1 &
