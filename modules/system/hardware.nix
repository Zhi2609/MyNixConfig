{ config, pkgs, lib, ... }:

{
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "intel_iommu=on"
    "iommu=pt"
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    powerManagement = {
      enable = true;
      finegrained = false;
    };

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  environment.systemPackages = with pkgs; [ nvidia-vaapi-driver ];

  specialisation.performance.configuration = {
    system.nixos.tags = [ "rendimiento-maximo" ];
    hardware.nvidia = {
      powerManagement.finegrained = lib.mkForce false;
      prime = {
        offload.enable    = lib.mkForce false;
        offload.enableOffloadCmd = lib.mkForce false;
        sync.enable       = lib.mkForce true;
      };
    };
  };
}
