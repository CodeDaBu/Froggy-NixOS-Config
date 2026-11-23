{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 0;
      bar-rounding = 0;
      bar-thickness = 0;
      gaps-in = 8;
      gaps-out = 8 * 2;
      active-opacity = 0.96;
      inactive-opacity = 0.92;
      blur = true;
      border-size = 2;
      animation-speed = "medium"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"
    };
    description = "Theme configuration options";
  };

  config.stylix = {
    enable = true;

    # See https://tinted-theming.github.io/tinted-gallery/ for more schemes
    # Material You Dark — Nature Green (matches wallpaper)
    base16Scheme = {
      base00 = "0D1B10"; # Background (dark forest)
      base01 = "1A2B1E"; # Surface Variant
      base02 = "2A3D2E"; # Surface Container
      base03 = "4A6B50"; # Outline
      base04 = "7DAB84"; # On Surface Variant
      base05 = "C8E6CE"; # On Surface (main text)
      base06 = "E4F3E8"; # Surface Bright
      base07 = "F0FBF2"; # Near white
      base08 = "E05C5C"; # Error
      base09 = "D4A56A"; # Amber/warm
      base0A = "C8D44C"; # Yellow-green
      base0B = "5DC87A"; # Secondary bright green
      base0C = "4CC5B0"; # Teal
      base0D = "7ED88A"; # Primary green (accent)
      base0E = "A8D890"; # Soft green
      base0F = "D87AB0"; # Pink (flowers)
    };

    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 20;
    };

    fonts = {
      monospace = {
        package = pkgs.monocraft;
        name = "Monocraft";
      };
      sansSerif = {
        package = pkgs.monocraft;
        name = "Monocraft";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 13;
      };
    };

    polarity = "dark";
    image = ../wallpapers/nature.jpg;
  };
}
