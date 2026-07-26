{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/system/hardware.nix
    ./modules/system/gaming.nix
    ./modules/system/services.nix
  ];

  boot = {
    kernelParams = [ "quiet" "splash" ];
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

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

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings = {
    theme = {
      background = "/home/zhi/Imágenes/Fondos de Pantalla/Wallhaven - 1013.png";
    };
  };

  services.desktopManager.plasma6.enable = true;
  programs.niri.enable = true;

  users.users.zhi = {
    isNormalUser = true;
    description  = "Cesar Garcia";
    extraGroups  = [ "wheel" "networkmanager" "audio" "video" "input" "gamemode" ];
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = "Defaults pwfeedback\nDefaults timestamp_timeout=15";
  };
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    git wget curl btop fastfetch unzip p7zip rsync tree
    pciutils usbutils lm_sensors nvtopPackages.full powertop
    xdg-utils xdg-user-dirs glib
    zip gzip bzip2 xz zstd python3
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg nerd-fonts.fira-code nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono nerd-fonts.symbols-only
    google-fonts corefonts noto-fonts
  ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;

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
    XDG_SESSION_TYPE = "wayland";
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
