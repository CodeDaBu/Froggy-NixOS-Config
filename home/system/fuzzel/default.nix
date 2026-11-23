{config, ...}: {
  stylix.targets.fuzzel.enable = false;

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Monocraft:size=13";
        icon-theme = "Papirus-Dark";
        terminal = "ghostty -e";
        width = 40;
        lines = 10;
        horizontal-pad = 16;
        vertical-pad = 10;
        inner-pad = 6;
        image-size-ratio = 0.4;
        anchor = "top";
        y-margin = 56;
      };
      colors = {
        background = "${config.lib.stylix.colors.base00}F0";
        text = "${config.lib.stylix.colors.base05}FF";
        match = "${config.lib.stylix.colors.base0D}FF";
        selection = "${config.lib.stylix.colors.base02}FF";
        selection-text = "${config.lib.stylix.colors.base05}FF";
        selection-match = "${config.lib.stylix.colors.base0D}FF";
        border = "${config.lib.stylix.colors.base0D}80";
      };
      border = {
        radius = 0;
        width = 1;
      };
    };
  };
}
