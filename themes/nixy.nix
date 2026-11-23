{
  lib,
  pkgs,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 20;
      bar-rounding = 20 + 10;
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
    # Material You Dark — based on Material Design 3
    base16Scheme = {
      base00 = "1C1B1F"; # Surface (background)
      base01 = "2B2930"; # Surface Variant
      base02 = "3B383E"; # Surface Container
      base03 = "605D63"; # Outline
      base04 = "938F96"; # On Surface Variant
      base05 = "E6E1E5"; # On Surface (main text)
      base06 = "FFFBFE"; # Surface Bright
      base07 = "FFFFFF"; # White
      base08 = "CF6679"; # Error
      base09 = "FFB786"; # Tertiary
      base0A = "D0C048"; # Yellow
      base0B = "90C978"; # Secondary Green
      base0C = "78C8C4"; # Teal
      base0D = "D0BCFF"; # Primary Purple (accent)
      base0E = "CCC2DC"; # Secondary Purple
      base0F = "EFB8C8"; # Pink
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
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/anotherhadi/awesome-wallpapers/refs/heads/main/app/static/wallpapers/black-moutains-and-a-city.png";
      sha256 = "sha256-RTTA3Lf+hnPpo9hwS075kbnIouz12ul2GKO3EIgP6AU=";
    };
  };
}
