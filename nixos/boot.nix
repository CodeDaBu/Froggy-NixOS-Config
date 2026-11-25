# Boot configuration for NixOS: themed GRUB (EFI) + Plymouth splash
{pkgs, ...}: {
  boot = {
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 3; # seconds the menu waits; press any key to stop the timer
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev"; # EFI install, nothing written to a disk MBR
        configurationLimit = 3; # boot menu entries; older generations stay until garbage collected
        useOSProber = false;
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

  # GRUB menu: stylix paints it with the palette and the Monocraft font; add the wallpaper behind it
  stylix.targets.grub.useWallpaper = true;

  stylix.targets.plymouth = {
    logo = ../assets/boot-logo.png;
    logoAnimated = false; # the frog isn't rotationally symmetric, so no spinning
  };

  # To avoid systemd services hanging on shutdown
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };
}
