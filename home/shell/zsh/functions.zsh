test-flake() {
    if [ -z "$1" ]; then
        echo "Usage: test-flake github:owner/repo"
        return 1
    fi
    
    echo "Checking flake outputs for $1..."
    
    # Check if a default package or app exists for the current system architecture
    local system
    system=$(nix eval --raw --impure --expr 'builtins.currentSystem' 2>/dev/null || echo "x86_64-linux")
    
    if nix flake show "$1" --json 2>/dev/null | jq -e ".packages.\"$system\".default or .apps.\"$system\".default" > /dev/null; then
        echo "✅ Valid default target found for $system."
        
        # Ask for user approval
        echo -n "Do you want to execute 'nix run $1'? [y/N]: "
        read -r response
        
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo "Running..."
            nix run "$1"
        else
            echo "Execution cancelled."
        fi
    else
        echo "❌ Error: No default package or app exported for $system."
        echo "Showing raw flake structure:"
        nix flake show "$1"
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
