{
  pkgs,
  system,
  ...
}: {
  packages.${system}.froggy = import ./package.nix {
    inherit pkgs;
    configDirectory = "$HOME/.config/nixos";
  };

  homeManagerModules.froggy = {
    imports = [./default.nix];
  };
}
