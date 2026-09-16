{ config, pkgs, lib, ... }:

{
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
  ];
}
