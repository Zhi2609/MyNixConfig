{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/system/boot.nix
    ./modules/system/display.nix
    ./modules/system/gaming.nix
    ./modules/system/hardware.nix
    ./modules/system/locale.nix
    ./modules/system/networking.nix
    ./modules/system/nix.nix
    ./modules/system/packages.nix
    ./modules/system/services.nix
    ./modules/system/session.nix
    ./modules/system/users.nix
  ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}