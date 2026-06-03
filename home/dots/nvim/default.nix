{
  config,
  pkgs,
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
    nixpkgs-fmt
    qt6.qtdeclarative
    shfmt
    statix
    stylua
  ];

  # Symlink the base config. Adjust the path if your dotfiles are elsewhere.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/dots/nvim/neovim";
}
