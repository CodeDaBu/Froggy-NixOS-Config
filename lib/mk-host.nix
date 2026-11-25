# Builds a NixOS system for hosts/<name>. Every host gets the same modules;
# only hosts/<name>/{configuration,home,variables}.nix and hardware differ.
{
  inputs,
  nixpkgs,
  ...
}: {
  hostDir,
  extraModules ? [],
}:
  nixpkgs.lib.nixosSystem {
    modules =
      [
        {
          nixpkgs.overlays = [
            # signal-desktop from a newer nixpkgs, old versions expire
            (_final: prev: {
              signal-desktop =
                (import inputs.nixpkgs-signal {
                  system = prev.stdenv.hostPlatform.system;
                  config.allowUnfree = true;
                }).signal-desktop;
            })
          ];
          _module.args = {inherit inputs;};
        }
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.nix-index-database.nixosModules.default
        inputs.helium-browser.nixosModules.default
        (hostDir + "/configuration.nix")
      ]
      ++ extraModules;
  }
