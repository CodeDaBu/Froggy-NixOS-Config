# - ## Froggy
#-
#- Froggy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, test, update, collect garbage, clean boot menu, etc.
#-
#- - `froggy` - UI wizard to manage the system.
#- - `froggy rebuild` - Rebuild the system.
#- - `froggy ...` - ... see the script for more commands.
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.froggy = {
    enable = lib.mkEnableOption "froggy";
    configDirectory = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/.config/nixos";
      description = "Path to the NixOS configuration directory";
    };
  };

  config = lib.mkIf config.programs.froggy.enable {
    home.packages = [
      (import ./package.nix {
        inherit pkgs;
        inherit (config.programs.froggy) configDirectory;
      })
    ];
  };
}
