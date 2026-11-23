{
  config,
  pkgs,
  ...
}: {
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs; [
    playerctl
    wlogout
    pavucontrol
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        spacing = 4;

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["wireplumber" "network" "battery" "tray"];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
            empty = "○";
          };
          persistent-workspaces = {
            "*" = 5;
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        clock = {
          format = "  {:%H:%M}";
          format-alt = "  {:%a %d %b}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        wireplumber = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟  muted";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        network = {
          format-wifi = "󰤨  {signalStrength}%";
          format-ethernet = "󰈀  wired";
          format-disconnected = "󰤭  offline";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  {ipaddr}";
          tooltip-format-ethernet = "{ifname}  {ipaddr}";
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-full = "󰁹  full";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip = true;
        };

        tray = {
          spacing = 8;
          icon-size = 16;
        };
      };
    };

    style = with config.lib.stylix.colors; ''
      * {
        border: none;
        border-radius: 0;
        font-family: "${config.stylix.fonts.sansSerif.name}";
        font-size: 13px;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: transparent;
        color: #${base05};
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: alpha(#${base00}, 0.92);
        border-radius: 20px;
        margin: 4px 2px;
        padding: 2px 10px;
        border: 1px solid alpha(#${base03}, 0.3);
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        color: #${base03};
        padding: 0 6px;
        background: transparent;
        font-size: 11px;
        transition: color 0.2s ease;
      }

      #workspaces button.active {
        color: #${base0D};
        font-size: 13px;
      }

      #workspaces button:hover {
        color: #${base05};
        background: transparent;
        box-shadow: none;
      }

      #clock {
        color: #${base05};
        padding: 0 12px;
        font-weight: 500;
      }

      #wireplumber,
      #network,
      #battery,
      #tray {
        color: #${base04};
        padding: 0 10px;
      }

      #wireplumber {
        color: #${base0C};
      }

      #network {
        color: #${base0B};
      }

      #battery {
        color: #${base0B};
      }

      #battery.warning {
        color: #${base09};
      }

      #battery.critical {
        color: #${base08};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to { color: #${base05}; }
      }
    '';
  };
}
