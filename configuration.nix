{ config, pkgs, ... }:

{
  # =========================================
  # IMPORTS & MÓDULOS
  # =========================================
  imports = [
    ./firewall.nix
    ./modules/nvidia.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
  ];

  # =========================================
  # BOOT & KERNEL
  # =========================================
  boot = {
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "preempt=full"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
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

  programs.nix-ld.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  networking = {
    hostName = "Suisei";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";

  # =========================================
  # GESTIÓN DE ENERGÍA & SERVICIOS
  # =========================================
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true; # Integración nativa con KDE Plasma 6 y arquitectura híbrida Intel
  services.flatpak.enable = true;
  services.fstrim.enable = true;

  # =========================================
  # USUARIOS Y SEGURIDAD
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
  # PROGRAMAS DEL SISTEMA & VARIABLES
  # =========================================
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    PROTON_ENABLE_NVAPI = "1";
    FLAKE = "/etc/nixos";
  };

  environment.systemPackages = with pkgs; [
    btop
    curl
    distrobox
    fastfetch
    google-antigravity
    google-antigravity-cli
    git
    glib
    lm_sensors
    nvtopPackages.full
    p7zip
    pciutils
    binutils
    powertop
    ncdu
    rsync
    tree
    unzip
    unrar
    usbutils
    wget
    xdg-user-dirs
    xdg-utils
    zip
    zstd
    zenity
  ];

  # =========================================
  # GESTOR DE PAQUETES (NIX & NH)
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
  # BASE DE DATOS Y CONTENEDORES
  # =========================================
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mysql";
    settings.mysqld.port = 3306;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # =========================================
  # AUTOMATIZACIÓN & RESPALDOS (RCLONE)
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
      OnCalendar = "*-*-* *:00/2:00";
      Persistent = true;
    };
  };

  system.stateVersion = "26.05";
}
