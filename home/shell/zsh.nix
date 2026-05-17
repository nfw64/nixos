{
  pkgs,
  config,
  ...
}:

{
  programs = {
    starship.enable = true;

    zsh = {
      enable = true;
      enableCompletion = false;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = false;

      localVariables = {
        FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
        FZF_CTRL_T_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
        FZF_ALT_C_COMMAND = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
        FZF_DEFAULT_OPTS = "--height 50% --layout=default --border --color=hl:#2dd4bf";
        FZF_CTRL_T_OPTS = "--preview 'bat --color=always -n --line-range :500 {}'";
        FZF_ALT_C_OPTS = "--preview 'eza --icons=always --tree --color=always {} | head -200'";
      };

      shellAliases = {
        vim = "nvim";
        svim = "sudoedit";

        ls = "eza --no-filesize --long --color=always --icons=always --no-user";
        lst = "ls -aTL 2";
        zrel = "source ~/.config/zsh/.zshrc";
        psx = "ps aux | grep";
        cd = "z";
        fvi = "fzf_listoldfiles.sh";
        fma = "bash -c 'compgen -c' | fzf | xargs man";
        fzo = "zoxide_openfiles_nvim.sh";

        # nix
        nos = "nh os switch";
        nhs = "nh home switch";
        nfu = "nix flake update";

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
        path = "$HOME/.zhistory";
      };

      initContent = ''
        [[ $- != *i* ]] && return

        source ${pkgs.zinit}/share/zinit/zinit.zsh
        fastfetch -l none

        zinit wait lucid for \
            atinit"ZINIT[COMPINIT_OPTS]=-C" \
            zdharma-continuum/fast-syntax-highlighting

        zinit wait lucid blockf for \
            zsh-users/zsh-completions

        zinit wait lucid atload"!_zsh_autosuggest_start" for \
            zsh-users/zsh-autosuggestions

        zinit ice lucid wait"5"
        zinit light hlissner/zsh-autopair

        function y() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
        }

        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey -r "^G"

        eval "$(fzf --zsh)" # fzf
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
        if [[ $- == *i* ]] && [ -t 0 ]; then
            eval "$(pay-respects zsh)"
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
