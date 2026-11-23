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
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";

    bind =
      [
        # Applications
        (
          "$shiftMod, A, exec, "
          + lib.getExe (mkMenu [
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
          ])
        )

        "$mod, B, exec, uwsm app -- ${config.programs.helium.package}/bin/helium"

        # Power menu
        (
          "$mod, X, exec, "
          + lib.getExe (mkMenu [
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
          ])
        )

        # Quick launch
        "$mod, RETURN, exec, uwsm app -- ${pkgs.ghostty}/bin/ghostty"
        "$mod, E, exec, uwsm app -- ${pkgs.thunar}/bin/thunar"
        "$mod, SPACE, exec, fuzzel"
        "$mod, D, exec, (eww active-windows | grep -q dashboard && eww close dashboard) || eww open dashboard"
        "$mod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        # Windows
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$shiftMod, F, togglefloating"

        # Focus
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$shiftMod, H, focusmonitor, -1"
        "$shiftMod, J, layoutmsg, removemaster"
        "$shiftMod, K, layoutmsg, addmaster"
        "$shiftMod, L, focusmonitor, 1"

        # Screenshot
        "$shiftMod, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        ", Print, exec, hyprshot -m output -o ~/Pictures/Screenshots"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i: let
            ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9
      ));

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, R, resizewindow"
    ];

    bindl = [
      # Brightness
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

      # Media
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioStop, exec, playerctl stop"

      # Volume
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
  };
}
