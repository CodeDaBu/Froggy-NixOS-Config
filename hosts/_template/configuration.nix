{config, ...}: {
  imports = [
    ../common/configuration.nix
    @NVIDIA_IMPORT@

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;
}
