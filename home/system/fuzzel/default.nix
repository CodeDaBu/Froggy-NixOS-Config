{config, ...}: {
  stylix.targets.fuzzel.enable = false;

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${config.stylix.fonts.sansSerif.name}:size=13";
        icon-theme = "Papirus-Dark";
        terminal = "ghostty -e";
        width = 35;
        lines = 8;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 8;
        image-size-ratio = 0.5;
      };
      colors = {
        background = "${config.lib.stylix.colors.base00}EE";
        text = "${config.lib.stylix.colors.base05}FF";
        match = "${config.lib.stylix.colors.base0D}FF";
        selection = "${config.lib.stylix.colors.base02}FF";
        selection-text = "${config.lib.stylix.colors.base05}FF";
        selection-match = "${config.lib.stylix.colors.base0D}FF";
        border = "${config.lib.stylix.colors.base0D}60";
      };
      border = {
        radius = 16;
        width = 1;
      };
    };
  };
}
