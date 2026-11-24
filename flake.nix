{
  description = "BMO NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-signal.url = "github:nixos/nixpkgs/nixos-unstable"; # only used for signal-desktop
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    notashelf-tuigreet.url = "github:NotAShelf/tuigreet";
    helium-browser.url = "github:oxcl/nix-flake-helium-browser";
    nur-anotherhadi.url = "github:anotherhadi/nur-packages";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    args = {
      inherit
        inputs
        nixpkgs
        system
        pkgs
        ;
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      pkgs-nur-hadi = inputs.nur-anotherhadi.packages.${system};
    };
    merge = nixpkgs.lib.foldl nixpkgs.lib.recursiveUpdate {};
  in
    merge [
      (import ./home/programs/nvf/flake.nix args)
      (import ./home/programs/group/flake.nix args)
      (import ./home/programs/nixy/flake.nix args)
      {
        formatter.${system} = pkgs.alejandra;
        # Every folder in hosts/ with a flake.nix is a host (folders starting with _ are templates)
        nixosConfigurations = let
          hostNames = builtins.filter (n: !(nixpkgs.lib.hasPrefix "_" n) && builtins.pathExists (./hosts + "/${n}/flake.nix")) (
            builtins.attrNames (nixpkgs.lib.filterAttrs (_: t: t == "directory") (builtins.readDir ./hosts))
          );
        in
          nixpkgs.lib.genAttrs hostNames (n: import (./hosts + "/${n}/flake.nix") args);
      }
    ];
}
