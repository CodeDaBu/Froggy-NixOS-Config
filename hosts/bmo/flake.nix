{
  inputs,
  nixpkgs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          signal-desktop =
            (import inputs.nixpkgs-signal {
              system = prev.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            }).signal-desktop;
        })
      ];
      _module.args = {inherit inputs;};
    }
    inputs.nixos-hardware.nixosModules.omen-16-n0005ne
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.nix-index-database.nixosModules.default
    inputs.helium-browser.nixosModules.default
    ./configuration.nix
  ];
}
