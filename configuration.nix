# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  # ─────────────────────────────────────────────
  # BOOT
  # ─────────────────────────────────────────────
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "intel_iommu=on"
      "iommu=pt"
    ];
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  networking = {
    hostName = "Suisei"; # Cambiado el Hostname
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "es_MX.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # ─────────────────────────────────────────────
  # ENTORNO GRÁFICO Y DISPLAY MANAGER
  # ─────────────────────────────────────────────
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings = {
    Theme = {
      Background = "/home/zhi/Imágenes/Fondos de Pantalla/Wallhaven - 1013.png";
    };
  };

  services.desktopManager.plasma6.enable = true;
  programs.niri.enable = true;

  # ─────────────────────────────────────────────
  # OPTIMIZACIÓN DE MEMORIA: ZRAM
  # ─────────────────────────────────────────────
  zramSwap = {
    enable = true;
    algorithm = "zstd";    # El algoritmo más eficiente y rápido
    memoryPercent = 100;    # Asigna hasta el 50% de tu RAM total para comprimir datos
  };

  # ─────────────────────────────────────────────
  # GRÁFICOS: NVIDIA PRIME
  # ─────────────────────────────────────────────
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
      finegrained = true;
    };
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId  = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

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

  # ─────────────────────────────────────────────
  # AUDIO, BLUETOOTH Y ENERGÍA
  # ─────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # services.blueman.enable = true;

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC  = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC  = 1;
      CPU_BOOST_ON_BAT = 0;
      DISK_DEVICES = "nvme0n1";
      DISK_IDSATA_FORCED_POWERMGMT = "off";
      USB_AUTOSUSPEND = 1;
    };
  };

  # ─────────────────────────────────────────────
  # GAMING
  # ─────────────────────────────────────────────
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  # programs.mangohud.enable = true;

  services.flatpak.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = "Defaults pwfeedback\nDefaults timestamp_timeout=15";
  };
  security.polkit.enable = true;

  # ─────────────────────────────────────────────
  # USUARIO
  # ─────────────────────────────────────────────
  users.users.zhi = { # Cambiado a zhi
    isNormalUser = true;
    description  = "Cesar Garcia"; # Nombre completo
    extraGroups  = [ "wheel" "networkmanager" "audio" "video" "input" "gamemode" ];
    shell = pkgs.zsh;
  };

  # ─────────────────────────────────────────────
  # PAQUETES GLOBALES
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    btop
    fastfetch
    unzip
    p7zip
    rsync
    tree
    pciutils
    usbutils
    lm_sensors
    nvtopPackages.full
    powertop
    nvidia-vaapi-driver

    xdg-utils
    xdg-user-dirs
    glib
    zip
    gzip
    bzip2
    xz
    zstd
    python3
  ];

  # ─────────────────────────────────────────────
  # FUENTES DEL SISTEMA
  # ─────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    google-fonts
    corefonts
    noto-fonts
  ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  services.fstrim.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSin4="
      ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    PROTON_ENABLE_NVAPI = "1";
    DXVK_ASYNC = "1";
    XDG_SESSION_TYPE = "wayland";
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
