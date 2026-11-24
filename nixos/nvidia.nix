# Nvidia configuration for NixOS with Wayland and Hyprland support
# Import this module only if you have an Nvidia GPU
{
  pkgs,
  config,
  lib,
  ...
}: let
  # Using beta driver for recent GPUs like RTX 4070
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.production;

  # Hybrid laptop = an AMD or Intel iGPU next to the Nvidia dGPU. Set config.var.gpu in
  # hosts/<name>/variables.nix: { nvidiaBusId, amdgpuBusId or intelBusId }. Nvidia-only
  # desktops leave gpu = {} and get no PRIME setup.
  gpu = config.var.gpu or {};
  hybrid = (gpu ? nvidiaBusId) && ((gpu ? amdgpuBusId) || (gpu ? intelBusId));
in {
  # Video drivers configuration for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # Simplified - other modules are loaded automatically

  # Kernel parameters for better Wayland and Hyprland integration
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # Enable mode setting for Wayland
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Improves resume after sleep
  ];

  # Blacklist nouveau to avoid conflicts
  boot.blacklistedKernelModules = ["nouveau"];

  # Environment variables for better compatibility
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia"; # Hardware video acceleration
    GBM_BACKEND = "nvidia-drm"; # Graphics backend for Wayland
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Use Nvidia driver for GLX
    NIXOS_OZONE_WL = "1"; # Wayland support for Electron apps
    __GL_GSYNC_ALLOWED = "1"; # Enable G-Sync if available
    __GL_VRR_ALLOWED = "1"; # Enable VRR (Variable Refresh Rate)
    NVD_BACKEND = "direct"; # Configuration for new driver
    MOZ_ENABLE_WAYLAND = "1"; # Wayland support for Firefox
  };

  # Configuration for proprietary packages
  nixpkgs.config = {
    nvidia.acceptLicense = true;
  };

  # Nvidia configuration
  hardware = {
    nvidia = {
      open = false; # Proprietary driver for better performance
      nvidiaSettings = true; # Nvidia settings utility
      powerManagement = {
        enable = true; # Power management
        finegrained = hybrid; # More precise power consumption control (needs PRIME offload)
      };
      modesetting.enable = true; # Required for Wayland
      package = nvidiaDriverChannel;
      forceFullCompositionPipeline = true; # Prevents screen tearing

      # Hybrid iGPU + Nvidia laptop: render on the iGPU, offload to Nvidia on demand
      prime = lib.mkIf hybrid ({
          offload = {
            enable = true; # Mode optimized for power saving
            enableOffloadCmd = true; # Allows running applications with dedicated GPU
          };
          # sync.enable disabled as offload is generally better for laptops
          sync.enable = false;
          # PCI IDs (`lspci | grep -Ei "vga|3d|display"`, hex -> decimal, e.g. 05:00.0 = PCI:5:0:0)
          nvidiaBusId = gpu.nvidiaBusId;
        }
        // lib.optionalAttrs (gpu ? amdgpuBusId) {amdgpuBusId = gpu.amdgpuBusId;}
        // lib.optionalAttrs (gpu ? intelBusId) {intelBusId = gpu.intelBusId;});
    };

    # Enhanced graphics support
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
        egl-wayland
        vulkan-loader
        vulkan-validation-layers
        libva
      ];
    };
  };

  # Nix cache for CUDA
  nix.settings = {
    substituters = ["https://cuda-maintainers.cachix.org"];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Additional useful packages
  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
    libva-utils # VA-API debugging tools
  ];

  # Enable Nvidia container toolkit for GPU acceleration in containers (docker)
  hardware.nvidia-container-toolkit.enable = false;
}
