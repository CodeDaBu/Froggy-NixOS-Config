# Hyprland is a dynamic tiling Wayland compositor that is highly customizable and performant.
{
  pkgs,
  config,
  lib,
  ...
}: let
  border-size = config.theme.border-size;
  gaps-in = config.theme.gaps-in;
  gaps-out = config.theme.gaps-out;
  active-opacity = config.theme.active-opacity;
  inactive-opacity = config.theme.inactive-opacity;
  rounding = config.theme.rounding;
  blur = config.theme.blur;
  keyboardLayout = config.var.keyboardLayout;
  background = "rgba(" + config.lib.stylix.colors.base00 + "EE)";
in {
  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
    #./keyboard-backlight.nix # CHANGEME: This is for omen laptop only
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    xcb-util-cursor
    libxcb
    hyprland-qtutils
    adw-gtk3
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    wlr-randr
    brightnessctl
    gnome-themes-extra
    dconf
    wayland-utils
    wayland-protocols
    gpu-screen-recorder
    wl-clipboard
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;
    systemd = {
      enable = false;
      variables = [
        "--all"
      ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    };
    package = null;
    portalPackage = null;

    # Colors (borders, shadow, groupbar, background) are added by stylix.
    settings.config = {
      cursor.no_hardware_cursors = true;

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        layout = "master";
        "col.inactive_border" = lib.mkForce background;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled = blur;
          size = 18;
        };
      };

      master = {
        new_status = "slave";
        allow_small_split = true;
        mfact = 0.5;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        allow_session_lock_restore = true; # a new hyprlock can take over if one crashes
      };

      input = {
        kb_layout = keyboardLayout;
        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.5;
        repeat_delay = 300;
        repeat_rate = 50;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
        };
      };

      ecosystem.no_update_news = true;
    };

    extraConfig = ''
      -- Any monitor: use the preferred mode. Per-host monitors are added in hosts/<name>/home.nix
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

      hl.on("hyprland.start", function()
        hl.exec_cmd("dbus-update-activation-environment --systemd --all")
        hl.exec_cmd("uwsm app -- waybar")
        hl.exec_cmd("eww daemon")
      end)

      hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
      hl.env("XDG_SESSION_TYPE", "wayland")
      hl.env("XDG_SESSION_DESKTOP", "Hyprland")
      hl.env("ANKI_WAYLAND", "1")
      hl.env("DISABLE_QT5_COMPAT", "0")
      hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
      hl.env("QT_QPA_PLATFORM", "wayland;xcb")
      hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
      hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
      hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
      hl.env("DIRENV_LOG_FORMAT", "")
      hl.env("SDL_VIDEODRIVER", "wayland")
      hl.env("CLUTTER_BACKEND", "wayland")

      hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

      hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })

      hl.window_rule({ name = "helium-fullscreen", match = { class = "helium" }, suppress_event = "fullscreen", sync_fullscreen = false })

      hl.window_rule({ name = "proton-authenticator", match = { class = "proton-authenticator" }, float = true, center = true, size = "500 400" })
      hl.window_rule({ name = "protonvpn-app",        match = { class = "protonvpn-app" },        float = true, center = true, size = "500 400" })
      hl.window_rule({ name = "run-bg",               match = { title = "run-bg" },               float = true, center = true, size = "700 80" })
    '';
  };
}
