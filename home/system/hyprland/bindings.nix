{
  pkgs,
  lib,
  config,
  ...
}: let
  colors = config.lib.stylix.colors;

  mkMenu = menu: let
    configFile = pkgs.writeText "config.yaml" (
      lib.generators.toYAML {} {
        anchor = "bottom-right";
        border = "#${colors.base0D}80";
        background = "#${colors.base01}EE";
        color = "#${colors.base05}";
        margin_right = 15;
        margin_bottom = 15;
        rows_per_column = 5;

        inherit menu;
      }
    );
  in
    pkgs.writeShellScriptBin "menu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';

  dashboardToggle = pkgs.writeShellScript "dashboard-toggle" ''
    export PATH=${lib.makeBinPath [pkgs.eww pkgs.hyprland pkgs.jq pkgs.gnugrep]}:$PATH
    export PATH=${lib.makeBinPath [pkgs.coreutils pkgs.procps]}:$PATH
    screen=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
    current=$(hyprctl layers -j | jq -r 'to_entries[] | select([.value.levels[][]? | select(.namespace == "gtk-layer-shell")] | length > 0) | .key' | head -n1)

    if timeout 2 eww active-windows 2>/dev/null | grep -q '^dashboard'; then
      timeout 2 eww close dashboard-tabs dashboard || pkill -x eww
      [ "$current" = "$screen" ] && exit 0
    fi
    eww open dashboard-tabs --screen "$screen"
    eww open dashboard --screen "$screen"
  '';

  dashboardKill = pkgs.writeShellScript "dashboard-kill" ''
    export PATH=${lib.makeBinPath [pkgs.eww pkgs.hyprland pkgs.procps pkgs.gnugrep pkgs.coreutils]}:$PATH
    if timeout 2 eww active-windows 2>/dev/null | grep -q '^dashboard'; then
      timeout 2 eww close dashboard-tabs dashboard || pkill -x eww
    else
      hyprctl dispatch "hl.dsp.window.close()"
    fi
  '';
  appsMenu = mkMenu [
            {
              key = "a";
              desc = "Proton Authenticator";
              cmd = "env WEBKIT_DISABLE_COMPOSITING_MODE=1 ${pkgs.proton-authenticator}/bin/proton-authenticator";
            }
            {
              key = "p";
              desc = "Proton Pass";
              cmd = "${pkgs.proton-pass}/bin/proton-pass";
            }
            {
              key = "v";
              desc = "Proton VPN";
              cmd = "${pkgs.proton-vpn}/bin/protonvpn-app";
            }
            {
              key = "c";
              desc = "Proton Calendar";
              cmd = "${config.programs.helium.package}/bin/helium 'https://calendar.proton.me/'";
            }
            {
              key = "m";
              desc = "Proton Mail";
              cmd = "${config.programs.helium.package}/bin/helium 'https://mail.proton.me/'";
            }
            {
              key = "o";
              desc = "Obsidian";
              cmd = "${pkgs.obsidian}/bin/obsidian";
            }
            {
              key = "s";
              desc = "Signal";
              cmd = "${pkgs.signal-desktop}/bin/signal-desktop";
            }
            {
              key = "t";
              desc = "TickTick";
              cmd = "${pkgs.ticktick}/bin/ticktick";
            }
            {
              key = "b";
              desc = "Helium";
              cmd = "${config.programs.helium.package}/bin/helium";
            }
            {
              key = "i";
              desc = "Helium (Incognito)";
              cmd = "${config.programs.helium.package}/bin/helium --incognito";
            }
          ];
  powerMenu = mkMenu [
            {
              key = "l";
              desc = "Lock";
              cmd = "hyprlock";
            }
            {
              key = "s";
              desc = "Suspend";
              cmd = "systemctl suspend";
            }
            {
              key = "r";
              desc = "Reboot";
              cmd = "systemctl reboot";
            }
            {
              key = "p";
              desc = "Power Off";
              cmd = "systemctl poweroff";
            }
            {
              key = "e";
              desc = "Logout";
              cmd = "uwsm stop";
            }
          ];
in {
  wayland.windowManager.hyprland.extraConfig = ''
    local mod      = "SUPER"
    local shiftMod = "SUPER + SHIFT"

    -- Applications
    hl.bind(shiftMod .. " + A", hl.dsp.exec_cmd("${lib.getExe appsMenu}"))
    hl.bind(mod .. " + B",      hl.dsp.exec_cmd("uwsm app -- ${config.programs.helium.package}/bin/helium"))

    -- Power menu
    hl.bind(mod .. " + X",      hl.dsp.exec_cmd("${lib.getExe powerMenu}"))

    -- Quick launch
    hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- ${pkgs.ghostty}/bin/ghostty"))
    hl.bind(mod .. " + E",      hl.dsp.exec_cmd("uwsm app -- ${pkgs.thunar}/bin/thunar"))
    hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd("pgrep -x fuzzel && pkill -x fuzzel || uwsm app -- fuzzel"))
    hl.bind(mod .. " + D",      hl.dsp.exec_cmd("${dashboardToggle}"))
    hl.bind(mod .. " + V",      hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

    -- Windows
    hl.bind(mod .. " + Q",      hl.dsp.exec_cmd("${dashboardKill}"))
    hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
    hl.bind(shiftMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

    -- Focus
    hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
    hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(shiftMod .. " + H", hl.dsp.focus({ monitor = "-1" }))
    hl.bind(shiftMod .. " + J", hl.dsp.layout("removemaster"))
    hl.bind(shiftMod .. " + K", hl.dsp.layout("addmaster"))
    hl.bind(shiftMod .. " + L", hl.dsp.focus({ monitor = "+1" }))

    -- Screenshot
    hl.bind(shiftMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"))
    hl.bind("Print",            hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/Screenshots"))

    -- Workspaces 1-9 on the number row (keycodes 10-18)
    for i = 1, 9 do
      hl.bind(mod .. " + code:" .. (9 + i),         hl.dsp.focus({ workspace = i }))
      hl.bind(mod .. " + SHIFT + code:" .. (9 + i), hl.dsp.window.move({ workspace = i }))
    end

    -- Mouse
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mod .. " + R",         hl.dsp.window.resize(), { mouse = true })

    -- Brightness
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })

    -- Media
    hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
    hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
    hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })

    -- Volume
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true })
  '';
}
