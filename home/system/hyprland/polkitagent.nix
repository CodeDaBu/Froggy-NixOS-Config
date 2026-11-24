# HyprPolkitAgent is a simple polkit agent for wayland compositors
{pkgs, ...}: {
  home.packages = with pkgs; [hyprpolkitagent];

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("systemctl --user start hyprpolkitagent")
    end)
  '';
}
