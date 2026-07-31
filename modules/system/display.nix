{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      theme = {
        background = "/home/zhi/Imágenes/Fondos de Pantalla/Wallhaven - 1013.png";
      };
    };
  };

  services.desktopManager.plasma6.enable = true;
  programs.niri.enable = false;
}