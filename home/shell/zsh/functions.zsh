tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  
  # 1. Direct argument check
  if [ -n "$1" ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s "$1" && tmux $change -t "$1")
    return
  fi

  # 2. Get active sessions
  local sessions
  sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

  # 3. Handle zero sessions safely
  if [ -z "$sessions" ]; then
    echo "No active tmux sessions found."
    read "reply?Create a new session? (y/N): "
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      read "name?Enter session name [main]: "
      tmux new-session -s "${name:-main}"
    else
      echo "Canceled."
    fi
  else
    # 4. Launch fzf if sessions exist
    local session
    session=$(echo "$sessions" | fzf --exit-0)
    [ -n "$session" ] && tmux $change -t "$session"
  fi
}

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
    {
        exec </dev/tty
        exec <&1
        local session
        session=$(
            sesh list -t -c | fzf --height 50% --border-label ' sesh ' --border --prompt '🛸  '
        )
        zle reset-prompt > /dev/null 2>&1 || true
        [[ -z "$session" ]] && return
        sesh connect $session
    }
}
