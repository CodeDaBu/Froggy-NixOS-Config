{...}: {
  imports = [
    ../common/home.nix
    ./variables.nix # Mostly user-specific configuration
  ];

  home.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1"; # CHANGEME: Related to the GPU
  };

  wayland.windowManager.hyprland = {
    settings.config.cursor.default_monitor = "eDP-2";
    extraConfig = ''
      hl.monitor({ output = "eDP-2", mode = "highres", position = "0x0", scale = 1 }) -- internal laptop screen
      hl.monitor({ output = "desc:AOC U34G2G1 0x00000E06", mode = "3440x1440@99.98", position = "auto", scale = 1 }) -- external monitor
    '';
  };
}
