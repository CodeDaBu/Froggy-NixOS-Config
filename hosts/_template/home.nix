{...}: {
  imports = [
    ../common/home.nix
    ./variables.nix # Mostly user-specific configuration
  ];

  # Monitors: the default rule (preferred mode, auto position) lives in home/system/hyprland.
  # Add per-host rules here if you need them, e.g.:
  # wayland.windowManager.hyprland.extraConfig = ''
  #   hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "0x0", scale = 1 })
  # '';
}
