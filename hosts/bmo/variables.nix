{
  config,
  lib,
  ...
}: {
  imports = [
    # Choose your theme here:
    ../../themes/froggy.nix
  ];

  config.var = {
    hostname = "bmo";
    username = "dabu";
    configDirectory = "/home/" + config.var.username + "/.config/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "us";

    # PCI bus IDs for nixos/nvidia.nix (hybrid AMD + Nvidia laptops only)
    gpu = {
      amdgpuBusId = "PCI:5:0:0"; # lspci: 05:00.0
      nvidiaBusId = "PCI:1:0:0"; # lspci: 01:00.0
    };

    timeZone = "Europe/Ljubljana";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    git = {
      username = "dabu";
      email = "davor.orehovec2005@gmail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
  };

  # DON'T TOUCH THIS
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
