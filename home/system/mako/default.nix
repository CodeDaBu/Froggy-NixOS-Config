{config, ...}: {
  stylix.targets.mako.enable = false;

  services.mako = {
    enable = true;
    settings = {
      background-color = "#${config.lib.stylix.colors.base01}EE";
      text-color = "#${config.lib.stylix.colors.base05}";
      border-color = "#${config.lib.stylix.colors.base0D}80";
      progress-color = "over #${config.lib.stylix.colors.base0D}40";

      border-radius = 16;
      border-size = 1;
      padding = "12,16";
      margin = "8";

      width = 320;
      height = 120;
      max-visible = 4;

      anchor = "top-right";

      font = "${config.stylix.fonts.sansSerif.name} 13";

      default-timeout = 5000;

      layer = "overlay";
    };
  };
}
