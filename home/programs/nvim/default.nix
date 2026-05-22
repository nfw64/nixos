{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    tree-sitter
    neovim

    #nvim lsp stuff and formatter or mmore
    qt6.qtdeclarative
    statix
    nil
    nixpkgs-fmt
    shfmt
  ];

  # Symlink the base config. Adjust the path if your dotfiles are elsewhere.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/programs/nvim/neovim";
}
