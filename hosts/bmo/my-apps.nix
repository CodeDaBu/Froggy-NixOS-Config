{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher # Minecraft launcher
    firefox # Browser
    discord # Chat
    sourcegit # Git GUI
    ncdu # Disk usage TUI
    lutris # Game launcher
    gnumake # Build tool
    zenity # GTK dialog boxes
    flatpak # Flatpak package manager
    android-tools # ADB, fastboot
    pulseaudio # Audio utilities (pactl etc.)
  ];
}
