{ config, pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_cachyos;  # opciones: linuxPackages_zen y linuxPackages_cachyos
  boot.kernelParams = [ "preempt=full" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.sessionVariables = {
    PROTON_ENABLE_NVAPI = "1";
    DXVK_ASYNC = "1";
  };
}
