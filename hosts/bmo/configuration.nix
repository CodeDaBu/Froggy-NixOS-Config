{config, ...}: {
  imports = [
    ../common/configuration.nix
    ../../nixos/nvidia.nix # Hybrid AMD iGPU + Nvidia dGPU (bus IDs in variables.nix)

    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  # Dual boot: Windows keeps its boot files on this machine's EFI partition (/boot, UUID CEBA-E70A).
  # The entry only shows up if the file is really there.
  boot.loader.grub.extraEntries = ''
    search --fs-uuid --no-floppy --set=winroot CEBA-E70A
    if [ -f ($winroot)/EFI/Microsoft/Boot/bootmgfw.efi ]; then
      menuentry "Windows" --class windows --class os {
        insmod part_gpt
        insmod fat
        insmod chain
        search --fs-uuid --no-floppy --set=root CEBA-E70A
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    fi
  '';

  home-manager.users."${config.var.username}" = import ./home.nix;
}
