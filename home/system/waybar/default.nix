{
  config,
  pkgs,
  ...
}: {
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs; [
    playerctl
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
        exclusive = true;

        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["custom/weather" "bluetooth" "network" "wireplumber" "battery" "custom/swaync" "tray"];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
            empty = "○";
          };
          persistent-workspaces."*" = 5;
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 40;
          separate-outputs = true;
        };

        clock = {
          format = "  {:%H:%M}";
          format-alt = "  {:%a %d %b %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        "custom/weather" = {
          format = "{}";
          exec = "curl -s 'wttr.in/Ljubljana?format=1' 2>/dev/null | tr -d '\\n' || echo '? N/A'";
          interval = 1800;
          tooltip = false;
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-connected = "󰂱  {device_alias}";
          format-connected-battery = "󰂱  {device_alias}  {device_battery_percentage}%";
          on-click = "blueman-manager";
          tooltip-format = "Bluetooth: {status}";
          tooltip-format-connected = "{controller_alias}\n{num_connections} connected\n{device_enumerate}";
          tooltip-format-enumerate-connected = " {device_alias}";
          tooltip-format-enumerate-connected-battery = " {device_alias}  {device_battery_percentage}%";
        };

        network = {
          interface = "wlp5s0";
          format-wifi = "󰤨  {signalStrength}%";
          format-ethernet = "󰈀  wired";
          format-disconnected = "󰤭  offline";
          tooltip-format-wifi = "{essid}  {signalStrength}%\n{ipaddr}";
          tooltip-format-ethernet = "{ifname}  {ipaddr}";
          on-click = "nm-connection-editor";
        };

        wireplumber = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟  muted";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
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
        };

        "custom/swaync" = {
          tooltip = false;
          format = "{icon}  {}";
          format-icons = {
            notification = "󰂚";
            none = "󰂜";
            dnd-notification = "󰂛";
            dnd-none = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
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
        font-family: "Monocraft", monospace;
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
        background: #${base01};
        margin: 4px 2px;
        padding: 2px 10px;
        border: 1px solid #${base02};
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        color: #${base03};
        padding: 0 6px;
        background: transparent;
        font-size: 11px;
        transition: color 0.15s ease;
        box-shadow: none;
      }

      #workspaces button.active {
        color: #${base0D};
        font-size: 13px;
      }

      #workspaces button:hover {
        color: #${base05};
        background: #${base02};
        box-shadow: none;
      }

      #window {
        color: #${base04};
        padding: 0 8px;
        font-size: 12px;
      }

      #clock {
        color: #${base05};
        padding: 0 12px;
        font-weight: bold;
      }

      #custom-weather {
        color: #${base0C};
        padding: 0 10px;
      }

      #bluetooth {
        color: #${base0E};
        padding: 0 10px;
      }

      #bluetooth.off,
      #bluetooth.disabled {
        color: #${base03};
      }

      #network {
        color: #${base0B};
        padding: 0 10px;
      }

      #network.disconnected {
        color: #${base08};
      }

      #wireplumber {
        color: #${base0C};
        padding: 0 10px;
      }

      #wireplumber.muted {
        color: #${base03};
      }

      #battery {
        color: #${base0B};
        padding: 0 10px;
      }

      #battery.warning {
        color: #${base09};
      }

      #battery.critical {
        color: #${base08};
        animation: blink 1s linear infinite;
      }

      #battery.charging {
        color: #${base0D};
      }

      #custom-swaync {
        color: #${base05};
        padding: 0 10px;
      }

      #custom-swaync.notification {
        color: #${base0D};
      }

      #custom-swaync.dnd-notification,
      #custom-swaync.dnd-none {
        color: #${base03};
      }

      #tray {
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      @keyframes blink {
        to { color: #${base05}; }
      }
    '';
  };
}
