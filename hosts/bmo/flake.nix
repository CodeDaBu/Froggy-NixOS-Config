{inputs, ...} @ args:
import ../../lib/mk-host.nix args {
  hostDir = ./.;
  extraModules = [
    inputs.nixos-hardware.nixosModules.omen-16-n0005ne
  ];
}
