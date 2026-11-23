{config, pkgs, ...}: {
  home.packages = with pkgs; [
    blueman
  ];

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      "control-center-margin-top" = 56;
      "control-center-margin-right" = 8;
      "control-center-margin-bottom" = 8;
      "control-center-margin-left" = 0;
      "control-center-width" = 360;
      "notification-window-width" = 360;
      "fit-to-screen" = false;
      timeout = 5;
      "timeout-critical" = 0;
      "timeout-low" = 3;
      widgets = ["title" "mpris" "volume" "dnd" "calendar" "notifications"];
      "widget-config" = {
        title = {
          text = "Control Center";
          "clear-all-button" = true;
          "button-text" = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          "image-size" = 56;
          "image-radius" = 0;
          blur = false;
        };
        volume = {
          label = "󰕾";
        };
        calendar = {
          format = {
            today = "<span color='#${config.lib.stylix.colors.base0D}'><b><u>{}</u></b></span>";
          };
        };
      };
    };

    style = with config.lib.stylix.colors; ''
      * {
        font-family: "Monocraft", monospace;
        font-size: 13px;
        border-radius: 0;
      }

      .control-center {
        background: #${base00};
        border: 1px solid #${base03};
        padding: 8px;
      }

      .control-center-list {
        background: transparent;
      }

      .notification-row {
        outline: none;
        margin: 2px 0;
      }

      .notification {
        background: #${base01};
        border: 1px solid #${base02};
        padding: 10px;
        margin: 0;
      }

      .notification:hover {
        background: #${base02};
      }

      .notification-content {
        background: transparent;
      }

      .close-button {
        background: #${base08};
        color: #${base00};
        border: none;
        padding: 2px 6px;
        font-size: 11px;
      }

      .close-button:hover {
        background: #${base05};
      }

      .notification-default-action,
      .notification-action {
        background: transparent;
        border: none;
        color: #${base05};
      }

      .notification-default-action:hover,
      .notification-action:hover {
        background: #${base02};
      }

      .summary {
        font-weight: bold;
        color: #${base05};
        font-size: 13px;
      }

      .body {
        color: #${base04};
        font-size: 12px;
      }

      .app-icon {
        -gtk-icon-size: 32px;
      }

      /* Widget styles */
      .widget-title {
        color: #${base05};
        font-size: 14px;
        font-weight: bold;
        padding: 8px 12px;
        background: #${base01};
        border-bottom: 1px solid #${base02};
        margin-bottom: 4px;
      }

      .widget-title > button {
        background: #${base02};
        color: #${base05};
        border: 1px solid #${base03};
        padding: 4px 10px;
        font-size: 11px;
      }

      .widget-title > button:hover {
        background: #${base0D};
        color: #${base00};
      }

      .widget-dnd {
        background: #${base01};
        padding: 10px 12px;
        margin: 2px 0;
        border: 1px solid #${base02};
      }

      .widget-dnd > switch {
        border-radius: 0;
        background: #${base02};
        border: 1px solid #${base03};
      }

      .widget-dnd > switch:checked {
        background: #${base0D};
      }

      .widget-dnd > switch slider {
        background: #${base05};
        border-radius: 0;
      }

      .widget-mpris {
        background: #${base01};
        padding: 10px;
        margin: 2px 0;
        border: 1px solid #${base02};
      }

      .widget-mpris-player {
        padding: 8px;
      }

      .widget-mpris-title {
        font-weight: bold;
        color: #${base05};
        font-size: 13px;
      }

      .widget-mpris-subtitle {
        color: #${base04};
        font-size: 12px;
      }

      .widget-mpris > box > button {
        background: transparent;
        border: none;
        color: #${base0D};
        padding: 4px 8px;
        font-size: 16px;
      }

      .widget-mpris > box > button:hover {
        background: #${base02};
      }

      .widget-volume {
        background: #${base01};
        padding: 10px 12px;
        margin: 2px 0;
        border: 1px solid #${base02};
        color: #${base05};
      }

      .widget-volume scale trough {
        background: #${base02};
        border-radius: 0;
        min-height: 4px;
      }

      .widget-volume scale highlight {
        background: #${base0D};
        border-radius: 0;
      }

      .widget-calendar {
        background: #${base01};
        padding: 8px;
        margin: 2px 0;
        border: 1px solid #${base02};
        color: #${base05};
      }

      .widget-calendar calendar {
        background: transparent;
        color: #${base05};
        border-radius: 0;
      }

      .widget-calendar calendar:selected {
        background: #${base0D};
        color: #${base00};
      }

      .widget-calendar calendar.header {
        background: #${base02};
        color: #${base05};
        font-weight: bold;
        border-radius: 0;
      }

      .widget-calendar calendar.button {
        background: transparent;
        color: #${base0D};
        border-radius: 0;
      }

      .widget-calendar calendar.button:hover {
        background: #${base02};
      }
    '';
  };
}
