{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    neovim
    tree-sitter

    #nvim lsp stuff and formatter or mmore
    inputs.qml-language-server.packages.${pkgs.stdenv.hostPlatform.system}.default
    lua-language-server
    nil
    bash-language-server

    # linters and formatters
    alejandra
    stylua
    shfmt

    statix
    shellcheck
  ];

  # Symlink the base config. Adjust the path if your dotfiles are elsewhere.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/dots/nvim/neovim";
}
