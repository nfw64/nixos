{
  pkgs,
  inputs,
  ...
}:

let
  yazi-rs-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = "sha256-cZlnrlgv8+SFeNgIW69q//i/apcpvAv41q5W8bJwVaI="; # Current working hash
  };
in
{
  home.packages = with pkgs; [
    ffmpeg
    _7zz
    jq
    poppler
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;

    plugins = {
      "gvfs" = pkgs.fetchFromGitHub {
        owner = "boydaihungst";
        repo = "gvfs.yazi";
        rev = "master";
        hash = "sha256-UHneVJ+YXyDuPrZS+PZbs9n9h+VN5M2QG36FdprBkJc=";
      };
      jump-to-char = "${yazi-rs-plugins}/jump-to-char.yazi";
      git = "${yazi-rs-plugins}/git.yazi";
      smart-filter = "${yazi-rs-plugins}/smart-filter.yazi";
      chmod = "${yazi-rs-plugins}/chmod.yazi";
      diff = "${yazi-rs-plugins}/diff.yazi";
      full-border = "${yazi-rs-plugins}/full-border.yazi";
    };

    initLua = ''
      require("full-border"):setup()
      require("git"):setup {
          order = 1500,
      }
    '';

    settings = {
      mgr = {
        ratio = [
          2
          4
          8
        ];
        sort_by = "natural";
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
      };
      plugin = {
        prepend_fetchers = [
          {
            group = "preview"; # Yazi needs this field!
            id = "git";
            name = "*";
            run = "git";
          }
          {
            group = "preview"; # Same here
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
    };

    keymap = {
      manager = {
        keymap = [
          {
            on = [ "N" ];
            run = "plugin gvfs";
            desc = "Open GVfs mount manager";
          }
        ];
        prepend_keymap = [
          {
            on = [ "f" ];
            run = "plugin jump-to-char";
            desc = "Jump to file matching character";
          }
          {
            on = [ "F" ];
            run = "plugin smart-filter";
            desc = "Smart interactive folder filter";
          }
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Modify file system permissions";
          }
          {
            on = [
              "d"
              "f"
            ];
            run = "plugin diff";
            desc = "Diff selected item with hovered item";
          }
        ];
      };
    };
  };
}
