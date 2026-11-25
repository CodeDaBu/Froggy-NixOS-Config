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
    hostname = "@HOSTNAME@";
    username = "@USERNAME@";
    configDirectory = "/home/" + config.var.username + "/.config/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "us";

    # PCI bus IDs for nixos/nvidia.nix (filled in by scripts/new-host.sh if an Nvidia GPU is found)
    gpu = {@GPU@};

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
