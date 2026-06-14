{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    zsh
    pay-respects
    nix-search
    starship
    zinit
  ];

  programs = {
    starship.enable = true;
    zoxide.enable = true;

    zsh = {
      enable = true;
      enableCompletion = false;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = false;

      localVariables = {
        FZF_DEFAULT_COMMAND = "fd --type f --hidden --strip-cwd-prefix";
        FZF_CTRL_T_COMMAND = "fd --type f --hidden --strip-cwd-prefix";
        FZF_ALT_C_COMMAND = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
        FZF_CTRL_T_OPTS = "--preview 'bat --color=always -n --line-range :500 {}'";
        FZF_ALT_C_OPTS = "--preview 'eza --icons=always --tree --color=always {} | head -200'";
        FZF_TMUX_OPTS = "--p90%,70%";
        FZF_DEFAULT_OPTS = "--height=60% --layout=reverse --border=rounded --prompt=' ' --pointer=' ' --preview-window=right:65%:wrap:border-left";

        TMUX_CONF = "$HOME/.config/tmux/tmux.conf"; # tmux
        ZVM_ESCAPE_KEYTIMEOUT = "0";
      };

      shellAliases = {
        vim = "nvim";
        svim = "sudoedit";

        ls = "eza --icons";
        ll = "eza -lh --icons --git";
        la = "eza -lah --icons --git";
        tree = "eza --tree --icons";

        zrel = "source ~/.config/zsh/.zshrc";
        psx = "ps aux | grep";
        cd = "z";
        cat = "bat";
        grep = "rg --color=auto";
        diff = "diff --color=auto";
        df = "df -h";
        # Tmux
        tmux = "tmux -f $TMUX_CONF";
        a = "attach";

        #fzf
        fvi = "fzf_listoldfiles.sh";
        fma = "bash -c 'compgen -c' | fzf | xargs man";
        fzo = "zoxide_openfiles_nvim.sh";

        # nix
        nos = "nh os switch";
        nhs = "nh home switch";
        nfu = "nix flake update";
        nsp = "nix-shell -p";

        # git aliases
        gco = "git checkout";
        gsw = "git switch";
        gbr = "git branch";
        gc = "git commit -m";
        gca = "git commit --amend";
        gdc = "git diff --cached";
        gps = "git push";
        gpl = "git pull";
        ga = "git add .";
        gs = "git status -sb";
        gpo = "git push origin";
        glog = "git log --oneline --graph --all";
      };

      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        size = 290000;
        save = 290000;
      };

      initContent = ''
        [[ $- != *i* ]] && return

        source ${pkgs.zinit}/share/zinit/zinit.zsh
        fastfetch

        zinit wait lucid for \
            atinit"ZINIT[COMPINIT_OPTS]=-C" \
            zdharma-continuum/fast-syntax-highlighting

        zinit wait lucid blockf for \
            zsh-users/zsh-completions

        zinit wait lucid atload"!_zsh_autosuggest_start" for \
            zsh-users/zsh-autosuggestions

        zinit ice lucid wait"5"
        zinit light hlissner/zsh-autopair

        zinit ice depth=1
        zinit light jeffreytse/zsh-vi-mode

        ## source functions
        source ${./functions.zsh}

        ## widgets
        zle     -N             list_oldfiles
        bindkey -M emacs '\ev' list_oldfiles
        bindkey -M vicmd '\ev' list_oldfiles
        bindkey -M viins '\ev' list_oldfiles
        bindkey -s       '\es' 'sesh-sessions\n'
        zle     -N             fzf-file-widget
        bindkey -M emacs '\en' fzf-file-widget
        bindkey -M vicmd '\en' fzf-file-widget
        bindkey -M viins '\en' fzf-file-widget

        ## some hacky fixes
        setopt ignoreeof
        # Fix backspace for Zsh vi mode
        bindkey "^H" backward-delete-char
        bindkey "^?" backward-delete-char
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey -r "^G"
        ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
        ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
        ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

        # Disable command mode line highlight
        ZVM_VI_HIGHLIGHT_BACKGROUND=none
        ZVM_VI_HIGHLIGHT_FOREGROUND=none
        ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

        zvm_after_init=('eval "$(fzf --zsh)"')
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
        if [[ $- == *i* ]] && [ -t 0 ]; then
            eval "$(pay-respects zsh --nocnf)"
        fi
      '';
      completionInit = ''
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
        zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
      '';
    };
  };
}
