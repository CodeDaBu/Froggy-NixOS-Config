# Systemd-boot configuration for NixOS
{pkgs, ...}: {
  boot = {
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 3; # seconds the menu waits; hold or tap Space at boot to stop the timer
      systemd-boot = {
        enable = true;
        consoleMode = "max"; # highest text resolution, so the menu is sharp
        editor = false; # no editing kernel parameters from the boot menu
        configurationLimit = 3; # boot menu entries; older generations stay until garbage collected
      };
    };
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.

    # Silent boot
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    # Boot splash: stylix paints it with the theme palette; the logo is the frog
    plymouth.enable = true;
  };

  stylix.targets.plymouth = {
    logo = ../assets/boot-logo.png;
    logoAnimated = false; # the frog isn't rotationally symmetric, so no spinning
  };

  # To avoid systemd services hanging on shutdown
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };
}
