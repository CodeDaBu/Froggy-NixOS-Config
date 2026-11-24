{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("protonvpn-app --start-minimized")
    end)
  '';
}
