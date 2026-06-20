{
  pkgs,
  inputs,
  lib,
  ...
}: let
  whoosh = pkgs.fetchFromGitHub {
    owner = "WhoSowSee";
    repo = "whoosh.yazi";
    tag = "main";
    hash = "sha256-l5ntFbVPwRKyLFF1q5irGNa8K2mT80j33E5JNV5aAEg=";
  };
  open-with-cmd = pkgs.fetchFromGitHub {
    owner = "Ape";
    repo = "open-with-cmd.yazi";
    rev = "eba191d9915cdca48333740290bb604400392ef6";
    hash = "sha256-5Etw2bKTfhWHBXkIR6VZsbEbCN079QfIGLnQEYiR7Lw=";
  };
  searchjump = pkgs.fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "yazi-config";
    rev = "5270e50f1253c83eec8a4c537a41de25c92d55fa";
    hash = "sha256-OLdax4jRbjcqXjghzKTkmamGxor3lakWmdBbQxBZc1I=";
    sparseCheckout = [
      "plugins/easyjump.yazi"
    ];
  };
in {
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
      chmod = pkgs.yaziPlugins.chmod;
      diff = pkgs.yaziPlugins.diff;
      vcs-files = pkgs.yaziPlugins.vcs-files;
      mount = pkgs.yaziPlugins.mount;
      ouch = pkgs.yaziPlugins.ouch;
      jump-to-char = pkgs.yaziPlugins.jump-to-char;
      kdeconnect-send = pkgs.yaziPlugins.kdeconnect-send;
      open-with-cmd = "${open-with-cmd}";

      gvfs = {
        package = pkgs.yaziPlugins.gvfs;
        setup = true;
        settings = {
          which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?";
          save_path = lib.generators.mkLuaInline "os.getenv('HOME') .. ' /.config/yazi/gvfs.private '";
          save_path_automounts = lib.generators.mkLuaInline "os.getenv('HOME') .. ' /.config/yazi/gvfs_automounts.private '";
          password_vault = "keyring";
          save_password_autoconfirm = true;
        };
      };
      restore = {
        package = pkgs.yaziPlugins.restore;
        setup = true;
      };
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
      };
      recycle-bin = {
        package = pkgs.yaziPlugins.recycle-bin;
        setup = true;
      };
      starship = {
        package = pkgs.yaziPlugins.starship;
        setup = true;
        settings = {
          config_file = "~/.config/starship.toml";
        };
      };
      searchjump = {
        package = "${searchjump}/plugins/searchjump.yazi";
        setup = true;
        settings = {
          unmatch_fg = "#b2a496";
          match_str_fg = "#000000";
          match_str_bg = "#73AC3A";
          first_match_str_fg = "#000000";
          first_match_str_bg = "#73AC3A";
          label_fg = "#EADFC8";
          label_bg = "#BA603D";
          only_current = false;
          show_search_in_statusbar = false;
          auto_exit_when_unmatch = false;
          enable_capital_label = true;
        };
      };

      whoosh = {
        package = "${whoosh}";
        setup = true;
        settings = {
          bookmarks = [
            {
              tag = "Nix flakes";
              path = "~/nixos";
              key = ["n" "n"];
            }
            {
              tag = "Workspace";
              path = "~/wsp";
              key = ["w" "w"];
            }
          ];

          bookmarks_path = lib.generators.mkLuaInline "os.getenv('HOME') .. '/.config/yazi/bookmarks'";
          jump_notify = false;
          keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

          special_keys = {
            create_temp = "<Enter>";
            fuzzy_search = false;
            history = false;
            previous_dir = "j";
            project_root = "r";
          };

          home_alias_enabled = false;
          path_truncate_enabled = false;
          path_max_depth = 3;

          fzf_path_truncate_enabled = false;
          fzf_path_max_depth = 5;

          path_truncate_long_names_enabled = false;
          fzf_path_truncate_long_names_enabled = false;
          path_max_folder_name_length = 20;
          fzf_path_max_folder_name_length = 20;

          history_size = 10;
          history_fzf_path_truncate_enabled = false;
          history_fzf_path_max_depth = 5;
          history_fzf_path_truncate_long_names_enabled = false;
          history_fzf_path_max_folder_name_length = 30;
        };
      };
    };

    initLua = ''

      local old_build = Tab.build
      Tab.build = function(self, ...)
          local bar = function(c, x, y)
              if x <= 0 or x == self._area.w - 1 then
                  return ui.Bar(ui.Edge.TOP)
              end

              return ui.Bar(ui.Edge.TOP)
                  :area(ui.Rect({
                      x = x,
                      y = math.max(0, y),
                      w = ya.clamp(0, self._area.w - x, 1),
                      h = math.min(1, self._area.h),
                  }))
                  :symbol(c)
          end

          local c = self._chunks
          self._chunks = {
              c[1]:pad(ui.Pad.y(1)),
              c[2]:pad(ui.Pad.y(1)),
              c[3]:pad(ui.Pad.y(1)),
          }

          self._base = ya.list_merge(self._base or {}, {
              bar("┬", c[2].x, c[1].y),
              bar("┴", c[2].x, c[1].bottom - 1),
              bar("┬", c[2].right - 1, c[2].y),
              bar("┴", c[2].right - 1, c[2].bottom - 1),
          })

          old_build(self, ...)
      end
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
            group = "preview";
            id = "git";
            url = "*";
            run = "git";
          }
          {
            group = "preview";
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
        prepend_preloaders = [
          {
            url = "/run/user/1000/gvfs/**/*";
            run = "noop";
          }
          {
            url = "/run/media/myriad/**/*";
            run = "noop";
          }
        ];
        prepend_previewers = [
          {
            url = "*/";
            run = "folder";
          }
          {
            mime = "{text/*,application/x-subrip}";
            run = "code";
          }
          {
            url = "/run/user/1000/gvfs/**/*";
            run = "noop";
          }
          {
            url = "/run/media/myriad/**/*";
            run = "noop";
          }
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
        ];
      };
    };

    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = "F";
            run = "search --via=fd";
          }
          {
            on = "S";
            run = "search --via=rg";
          }
          {
            on = ["g" "x"];
            run = "plugin open-with-cmd";
            desc = "Open with command";
          }
          {
            on = ["s"];
            run = "plugin searchjump";
            desc = "searchjump mode";
          }
          {
            on = ["M" "k"];
            run = "plugin kdeconnect-send";
            desc = "Send selected files via KDE Connect";
          }
          {
            on = ["M" "g" "m"];
            run = "plugin gvfs -- select-then-mount --jump";
            desc = "Mount and jump";
          }
          {
            on = ["M" "g" "u"];
            run = "plugin gvfs -- select-then-unmount --eject";
            desc = "Select device then eject";
          }
          {
            on = ["M" "g" "U"];
            run = "plugin gvfs -- select-then-unmount --eject --force";
            desc = "Select device force eject";
          }
          {
            on = ["M" "g" "e" "a"];
            run = "plugin gvfs -- add-mount";
            desc = "Add a GVFS mount URI";
          }
          {
            on = ["M" "g" "e" "e"];
            run = "plugin gvfs -- edit-mount";
            desc = "Edit a GVFS mount URI";
          }
          {
            on = ["M" "g" "e" "r"];
            run = "plugin gvfs -- remove-mount";
            desc = "Remove a GVFS mount URI";
          }
          {
            on = ["g" "m"];
            run = "plugin gvfs -- jump-to-device";
            desc = "Select device then jump to its mount point";
          }
          {
            on = ["`" "`"];
            run = "plugin gvfs -- jump-back-prev-cwd";
            desc = "Jump back to the position before jumped to device";
          }
          {
            on = ["M" "g" "t"];
            run = "plugin gvfs -- automount-when-cd";
            desc = "Enable automount when cd to device under cwd";
          }
          {
            on = ["M" "g" "T"];
            run = "plugin gvfs -- automount-when-cd --disabled";
            desc = "Disable automount when cd to device under cwd";
          }

          {
            on = ["d" "u"];
            run = "plugin restore";
            desc = "Restore last deleted files/folders";
          }
          {
            on = ["d" "U"];
            run = "plugin restore -- --interactive";
            desc = "Restore deleted files/folders (Interactive)";
          }
          {
            on = ["C"];
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
          {
            on = ["R"];
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }
          ## Whoosh mappings start
          {
            on = ["b"];
            run = "plugin whoosh jump_by_key";
            desc = "Jump bookmark by key";
          }
          # Direct fuzzy search access
          {
            on = "}";
            run = "plugin whoosh jump_by_fzf";
            desc = "Direct fuzzy search for bookmarks";
          }
          # Basic bookmark operations
          {
            on = ["]" "a"];
            run = "plugin whoosh save";
            desc = "Add bookmark (hovered file/directory)";
          }

          {
            on = ["]" "A"];
            run = "plugin whoosh save_cwd";
            desc = "Add bookmark (current directory)";
          }

          # Temporary bookmarks
          {
            on = ["]" "t"];
            run = "plugin whoosh save_temp";
            desc = "Add temporary bookmark (hovered file/directory)";
          }

          {
            on = ["]" "T"];
            run = "plugin whoosh save_cwd_temp";
            desc = "Add temporary bookmark (current directory)";
          }

          # Jump to bookmarks
          {
            on = "<A-k>";
            run = "plugin whoosh jump_key_k";
            desc = "Jump directly to bookmark with key k";
          }

          {
            on = ["]" "f"];
            run = "plugin whoosh jump_by_fzf";
            desc = "Jump bookmark by fzf";
          }

          # Delete bookmarks
          {
            on = ["]" "d"];
            run = "plugin whoosh delete_by_key";
            desc = "Delete bookmark by key";
          }
          {
            on = ["]" "D"];
            run = "plugin whoosh delete_by_fzf";
            desc = "Delete bookmarks by fzf (use TAB to select multiple)";
          }
          {
            on = ["]" "C"];
            run = "plugin whoosh delete_all";
            desc = "Delete all user bookmarks";
          }
          # Rename bookmarks
          {
            on = ["]" "r"];
            run = "plugin whoosh rename_by_key";
            desc = "Rename bookmark by key";
          }
          {
            on = ["]" "R"];
            run = "plugin whoosh rename_by_fzf";
            desc = "Rename bookmark by fzf";
          }
          ## whoosh mappings end
          {
            on = ["M" "d"];
            run = "plugin mount";
          }
          {
            on = ["g" "c"];
            run = "plugin vcs-files";
            desc = "Show Git file changes";
          }
          {
            on = "f";
            run = "plugin jump-to-char";
            desc = "Jump to char";
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
          {
            on = [
              "d"
              "d"
            ];
            run = "remove";
            desc = "remove";
          }
          {
            on = ["T"];
            run = "shell kitty"; # Replace with your terminal
            desc = "Open terminal here";
          }
        ];
      };
    };
  };
}
