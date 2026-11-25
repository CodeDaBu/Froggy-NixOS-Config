# Screen lock (hyprlock) + lock on idle / before suspend (hypridle).
# Stylix already themes hyprlock (wallpaper background, input colors).
# PAM for hyprlock is set in nixos/utils.nix.
{
  config,
  ...
}: let
  c = config.lib.stylix.colors;
  primary = "rgb(${c.base0D})";
  text = "rgb(${c.base05})";
  muted = "rgb(${c.base04})";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = {
        blur_passes = 3;
        blur_size = 6;
        brightness = 0.55;
      };

      label = [
        {
          text = "$TIME";
          font_size = 96;
          font_family = "Monocraft";
          color = primary;
          position = "0, 170";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:60000] date +"%A, %d %B %Y"'';
          font_size = 20;
          font_family = "Monocraft";
          color = text;
          position = "0, 90";
          halign = "center";
          valign = "center";
        }
        {
          text = "$USER";
          font_size = 16;
          font_family = "Monocraft";
          color = muted;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        size = "320, 56";
        position = "0, -90";
        halign = "center";
        valign = "center";
        rounding = 0;
        outline_thickness = 2;
        dots_size = 0.25;
        dots_spacing = 0.3;
        fade_on_empty = false;
        font_family = "Monocraft";
        placeholder_text = "password";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${hyprlock}";
        before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 600; # 10 minutes idle
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
