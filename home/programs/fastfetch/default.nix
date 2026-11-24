# Fastfetch with the nature-green palette from the stylix theme (themes/nixy.nix)
{
  config,
  lib,
  ...
}: let
  c = config.lib.stylix.colors;
  hex = color: "#${color}";

  primary = hex c.base0D; # green accent
  teal = hex c.base0C;
  text = hex c.base05;
  muted = hex c.base04;
  outline = hex c.base03;

  section = corner: name: {
    type = "custom";
    format = "${corner}── ${name}";
    outputColor = outline;
  };
  row = icon: name: type: extra:
    {
      inherit type;
      key = "│ ${icon}  ${name}${lib.concatStrings (lib.replicate (9 - lib.stringLength name) " ")}";
      keyColor = primary;
      outputColor = text;
    }
    // extra;
in {
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        type = "builtin";
        source = "nixos";
        color = {
          "1" = primary;
          "2" = teal;
        };
        padding = {
          top = 0;
          left = 2;
          right = 4;
        };
      };

      display = {
        separator = "  ";
        color = {
          keys = primary;
          title = teal;
          output = text;
          separator = outline;
        };
        size.binaryPrefix = "iec";
        bar = {
          char = {
            elapsed = "■";
            total = "▪";
          };
          width = 12;
        };
        percent = {
          type = ["bar" "num"];
          color = {
            green = primary;
            yellow = hex c.base09;
            red = hex c.base08;
          };
        };
      };

      modules = [
        {
          type = "title";
          format = "{user-name-colored}{at-symbol-colored}{host-name-colored}";
          color = {
            user = primary;
            at = outline;
            host = teal;
          };
        }
        "break"

        (section "╭" "system")
        (row "󱄅" "OS" "os" {})
        (row "󰌢" "Host" "host" {})
        (row "󰌽" "Kernel" "kernel" {})
        (row "󰅐" "Uptime" "uptime" {})
        (row "󰏖" "Packages" "packages" {format = "{all}";})
        (row "󰪞" "Shell" "shell" {})

        (section "├" "desktop")
        (row "󰖲" "WM" "wm" {})
        (row "󰆍" "Terminal" "terminal" {})

        (section "├" "hardware")
        (row "󰻠" "CPU" "cpu" {})
        (row "󰢮" "GPU" "gpu" {format = "{name}";})
        (row "󰍛" "RAM" "memory" {})
        (row "󰋊" "SSD" "disk" { folders = "/"; })
        {
          type = "custom";
          format = "╰─";
          outputColor = outline;
        }

        {
          type = "colors";
          symbol = "square";
          paddingLeft = 2;
        }
      ];
    };
  };
}
