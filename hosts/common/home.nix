# Home-manager configuration shared by every host.
# Each host's home.nix imports this and its own variables.nix.
{config, ...}: {
  imports = [
    # Programs
    ../../home/programs/helium
    ../../home/programs/proton
    ../../home/programs/proton/auto-start-vpn.nix
    ../../home/programs/ghostty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/git
    ../../home/programs/git/lazygit.nix
    ../../home/programs/fastfetch
    #../../home/programs/git/signing.nix # CHANGEME: Change the key or remove this file
    ../../home/programs/thunar
    ../../home/programs/nixy
    ../../home/programs/nightshift
    ../../home/programs/nix-utils
    ../../home/programs/spotatui
    ../../home/programs/yazi

    ../../home/programs/group/basic-apps.nix
    ../../home/programs/group/my-apps.nix
    ../../home/programs/group/cybersecurity.nix
    ../../home/programs/group/dev.nix
    ../../home/programs/group/misc.nix

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hyprlock
    ../../home/system/waybar
    ../../home/system/swaync
    ../../home/system/fuzzel
    ../../home/system/eww
    ../../home/system/hyprpaper
    ../../home/system/mime
    ../../home/system/udiskie

    #../../hosts/bmo/secrets # CHANGEME: You should probably remove this line, this is where I store my secrets
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    file.".face" = {
      source = ../../assets/profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;
    nixy = {
      enable = true;
      configDirectory = config.var.configDirectory;
    };
  };
}
