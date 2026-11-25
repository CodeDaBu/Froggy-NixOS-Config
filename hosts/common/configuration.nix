# System configuration shared by every host.
# Host-specific bits (hardware, GPU, USB rules) live in hosts/<name>/configuration.nix.
{pkgs, ...}: {
  imports = [
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/boot.nix
    ../../nixos/tuigreet.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/steam.nix
    ../../home/programs/helium/system.nix # I hate browser's configuration..
    #../../nixos/usbguard.nix
  ];

  environment.systemPackages = [
    pkgs.claude-code
  ];

  services.flatpak.enable = true;

  # Don't touch this
  system.stateVersion = "24.05";
}
