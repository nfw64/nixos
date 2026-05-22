list_oldfiles() {
    # Get the oldfiles list from Neovim
    local oldfiles=($(nvim -u NONE --headless +'lua io.write(table.concat(vim.v.oldfiles, "\n") .. "\n")' +qa))
    # Filter invalid paths or files not found
    local valid_files=()
    for file in "${oldfiles[@]}"; do
        if [[ -f "$file" ]]; then
            valid_files+=("$file")
        fi
    done
    # Use fzf to select from valid files
    local files=($(printf "%s\n" "${valid_files[@]}" | \
        grep -v '\[.*' | \
        fzf --multi \
        --preview 'bat -n --color=always --line-range=:500 {} 2>/dev/null || echo "Error previewing file"' \
        --height=70% \
        --layout=default))

    # Open selected files in Neovim
    if [[ ${#files[@]} -gt 0 ]]; then
        # make neovim recognize path of the file opened
        local first_dir=$(dirname "${files[0]}")
        cd "$first_dir" || { echo "Failed to cd to $first_dir"; return 1; }
        nvim "${files[@]}"
    fi
}


function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function sesh-sessions() {
    local choice
    
    # Using become() forces fzf to close and spit out "CREATE_NEW_SESSION" to the variable
    choice=$(sesh list -t -c | fzf --height 50% \
        --border-label ' sesh ' \
        --border \
        --prompt '🛸  ' \
        --bind 'ctrl-n:become(echo CREATE_NEW_SESSION)')

    # Exit if you hit Escape or selected nothing
    [[ -z "$choice" ]] && return

    # Strip out any lingering hidden formatting characters
    choice=$(echo "$choice" | tr -d '\r\n' | xargs)

    # Check what action to take
    if [[ "$choice" == "CREATE_NEW_SESSION" ]]; then
        # Open an input prompt outside of the fzf bubble
        printf "Enter new session name: "
        read name
        
        if [[ -n "$name" ]]; then
            name=$(echo "$name" | xargs)
            tmux new-session -d -s "$name"
            sesh connect "$name"
        fi
    else
        # Regular connection to selected path/session
        sesh connect "$choice"
    fi
}
