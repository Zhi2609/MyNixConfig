{ config, pkgs, lib, ... }:

{
  # =========================================
  # IMPORTS & MODULOS
  # =========================================
  imports = [
    ./firewall.nix
  ];

  # =========================================
  # BOOT & SYSTEM
  # =========================================
  boot = {
    kernelParams = [ 
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "intel_iommu=on"
      "iommu=pt"
      "preempt=full" 
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    blacklistedKernelModules = [ "nouveau" "nvidiafb" ];
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # =========================================
  # HARDWARE & GRAPHICS (NVIDIA PRIME)
  # =========================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    powerManagement = {
      enable = true;
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

  # (Generación de rendimiento eliminada a petición del usuario)

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # =========================================
  # DISPLAY & DESKTOP (KDE PLASMA 6)
  # =========================================
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # =========================================
  # NETWORKING & LOCALE
  # =========================================
  networking = {
    hostName = "Suisei";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # =========================================
  # AUDIO & SERVICES
  # =========================================
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

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

  services.flatpak.enable = true;
  services.fstrim.enable = true;

  # =========================================
  # USERS
  # =========================================
  users.users.zhi = {
    isNormalUser = true;
    description = "Cesar Garcia";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "gamemode" ];
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = "Defaults pwfeedback\nDefaults timestamp_timeout=15";
  };
  security.polkit.enable = true;

  # =========================================
  # GAMING
  # =========================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
    extraPackages = [
      pkgs.protontricks
      (pkgs.python3.withPackages (ps: [
        ps.tkinter
        ps.pyside6
      ]))
    ];
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # =========================================
  # PROGRAMS & PACKAGES
  # =========================================
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    PROTON_ENABLE_NVAPI = "1";
    FLAKE = "/etc/nixos";
  };

  environment.systemPackages = with pkgs; [
    btop
    curl
    fastfetch
    git
    glib
    lm_sensors
    nvtopPackages.full
    p7zip
    pciutils
    binutils
    powertop
    python3
    ncdu
    rsync
    tree
    unzip
    usbutils
    wget
    xdg-user-dirs
    xdg-utils
    zip
    zstd
    
    # SDDM KCM module para configurar SDDM desde Preferencias de KDE
    kdePackages.sddm-kcm
    
    # Script prime-run para ejecutar aplicaciones con la grafica dedicada NVIDIA
    (writeShellScriptBin "prime-run" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];

  fonts.packages = with pkgs; [
    corefonts
    google-fonts
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  environment.plasma6.excludePackages = with pkgs; [
    xterm
  ];

  # =========================================
  # NIX SETTINGS & NH
  # =========================================
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 5";
    flake = "/etc/nixos";
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
    optimise.automatic = true;
  };

  # =========================================
  # DATABASE SERVICES (MARIADB / MYSQL)
  # =========================================
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # =========================================
  # USER AUTOMATION & BACKUP (RCLONE SYNC)
  # =========================================
  systemd.user.services.rclone-sync = {
    description = "Sincronización periódica con Rclone";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "rclone-sync-script" ''
        ${pkgs.rclone}/bin/rclone sync $HOME/Documentos/Sigil_Epubs gdrive:Mis_Respaldos/Epubs
        ${pkgs.rclone}/bin/rclone sync $HOME/Imágenes/Fondos gdrive:Mis_Respaldos/Fondos
      ''}";
    };
  };

  systemd.user.timers.rclone-sync = {
    description = "Temporizador para sincronizar Rclone";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* *:00:00";
      Persistent = true;
    };
  };

  system.stateVersion = "26.05";
}
