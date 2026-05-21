{
  inputs,
  ...
}:
{
  imports = [
    inputs.helium-flake.homeModules.default
  ];

  programs.helium = {
    enable = true;
    flags = [
      "--ozone-platform-hint=auto"

    ];
    policies = {
      "BrowserSignin" = 0;
      "PasswordManagerEnabled" = false;
      "SyncDisabled" = true;
      "HomepageLocation" = "https://vimium.github.io/new-tab/";
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderSearchURL" = "https://search.nixos.org/?q={searchTerms}";
      "ExtensionInstallForcelist" = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium c
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      ];
    };
  };
}
