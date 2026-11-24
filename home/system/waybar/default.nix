{
  config,
  lib,
  pkgs,
  ...
}: let
  # Click the wifi icon: pick a network in fuzzel and connect (asks for the password if needed).
  wifiMenu = pkgs.writeShellScript "wifi-menu" ''
    export PATH=${lib.makeBinPath [pkgs.networkmanager pkgs.fuzzel pkgs.libnotify pkgs.gawk pkgs.gnused pkgs.gnugrep pkgs.coreutils]}:$PATH

    notify() { notify-send -a wifi "$1" "$2"; }

    if [ "$(nmcli radio wifi)" != "enabled" ]; then
      choice=$(printf '%s\n' "󰖪  Turn Wi-Fi on" | fuzzel --dmenu --prompt "Wi-Fi: " --lines 1)
      [ -n "$choice" ] && nmcli radio wifi on && notify "Wi-Fi" "Turned on"
      exit 0
    fi

    nmcli device wifi rescan >/dev/null 2>&1 || true
    sleep 1

    # signal:security:in-use:ssid, strongest first, one line per SSID
    networks=$(nmcli -t -f SIGNAL,SECURITY,IN-USE,SSID device wifi list \
      | awk -F: 'length($0) && $4 != "" {print}' \
      | sort -t: -k1,1nr \
      | awk -F: '!seen[$4]++')

    icon() {
      if [ "$1" -ge 80 ]; then printf '󰤨'
      elif [ "$1" -ge 60 ]; then printf '󰤥'
      elif [ "$1" -ge 40 ]; then printf '󰤢'
      elif [ "$1" -ge 20 ]; then printf '󰤟'
      else printf '󰤯'; fi
    }

    ssids=()
    secs=()
    lines=()
    while IFS=: read -r signal security inuse ssid; do
      [ -z "$ssid" ] && continue
      name=$(printf '%s' "$ssid" | sed 's/\\:/:/g; s/\\\\/\\/g')
      mark="  "
      [ "$inuse" = "*" ] && mark="● "
      lock=""
      [ -n "$security" ] && [ "$security" != "--" ] && lock="  󰌾"
      ssids+=("$name")
      secs+=("$security")
      lines+=("$mark$(icon "$signal")  $name  ($signal%)$lock")
    done <<<"$networks"

    extra=("󰑐  Rescan" "󰖪  Turn Wi-Fi off")
    menu=$(printf '%s\n' "''${lines[@]}" "''${extra[@]}")

    idx=$(printf '%s\n' "$menu" | fuzzel --dmenu --index --prompt "Wi-Fi: " --width 50 --lines 12)
    [ -z "$idx" ] && exit 0

    count=''${#ssids[@]}
    if [ "$idx" -ge "$count" ]; then
      case $((idx - count)) in
        0) exec "$0" ;;
        1) nmcli radio wifi off && notify "Wi-Fi" "Turned off" ;;
      esac
      exit 0
    fi

    ssid="''${ssids[$idx]}"
    security="''${secs[$idx]}"

    # saved network: just connect
    if nmcli -t -f NAME connection show | grep -Fxq -- "$ssid"; then
      if nmcli connection up id "$ssid" >/dev/null 2>&1; then notify "Wi-Fi" "Connected to $ssid"; else notify "Wi-Fi" "Could not connect to $ssid"; fi
      exit 0
    fi

    if [ -z "$security" ] || [ "$security" = "--" ]; then
      nmcli device wifi connect "$ssid" >/dev/null 2>&1
      rc=$?
    else
      pw=$(fuzzel --dmenu --password --prompt-only "Password for $ssid: " </dev/null)
      [ -z "$pw" ] && exit 0
      # password goes through stdin, not the command line
      printf '%s\n' "$pw" | nmcli --ask device wifi connect "$ssid" >/dev/null 2>&1
      rc=$?
    fi

    if [ "$rc" -eq 0 ]; then notify "Wi-Fi" "Connected to $ssid"; else notify "Wi-Fi" "Could not connect to $ssid"; fi
  '';

  wifiToggle = pkgs.writeShellScript "wifi-toggle" ''
    export PATH=${lib.makeBinPath [pkgs.networkmanager pkgs.gnugrep pkgs.libnotify]}:$PATH
    if [ "$(nmcli radio wifi)" = "enabled" ]; then
      nmcli radio wifi off && notify-send -a wifi "Wi-Fi" "Turned off"
    else
      nmcli radio wifi on && notify-send -a wifi "Wi-Fi" "Turned on"
    fi
  '';
in {
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
        modules-right = ["custom/weather" "bluetooth" "network#wifi" "network#ethernet" "wireplumber" "battery" "custom/swaync" "tray"];

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
          format = "{:%H:%M}";
          format-alt = "{:%a %d %b %Y}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            on-scroll = 1;
            format = {
              months = "<span color='#${config.lib.stylix.colors.base0D}'><b>{}</b></span>";
              weeks = "<span color='#${config.lib.stylix.colors.base0C}'>{}</span>";
              weekdays = "<span color='#${config.lib.stylix.colors.base0D}'><b>{}</b></span>";
              days = "<span color='#${config.lib.stylix.colors.base05}'>{}</span>";
              today = "<span color='#${config.lib.stylix.colors.base00}' bgcolor='#${config.lib.stylix.colors.base0D}'><b>{}</b></span>";
            };
          };
          actions = {
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
            on-click-right = "mode";
          };
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

        "network#wifi" = {
          interface = "wl*";
          format-wifi = "{icon}  {essid}";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-disconnected = "󰤭  not connected";
          format-disabled = "󰖪  wifi off";
          tooltip-format-wifi = "{essid}\nSignal: {signalStrength}%\nIP: {ipaddr}\n\nClick: networks · Right click: wifi on/off";
          tooltip-format-disconnected = "Not connected\n\nClick: networks · Right click: wifi on/off";
          tooltip-format-disabled = "Wi-Fi is off\n\nClick: turn on · Right click: wifi on/off";
          on-click = "${wifiMenu}";
          on-click-right = "${wifiToggle}";
        };

        "network#ethernet" = {
          interface = "en*";
          format-ethernet = "󰈀  wired";
          format-disconnected = "";
          format-disabled = "";
          format-linked = "";
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
          format = "{icon}  {text}";
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

      tooltip {
        background: #${base00};
        border: 1px solid #${base03};
        border-radius: 0;
      }

      tooltip label {
        color: #${base05};
        font-size: 20px;
        padding: 10px 14px;
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
        color: #${base09};
      }

      #network.disabled {
        color: #${base03};
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
