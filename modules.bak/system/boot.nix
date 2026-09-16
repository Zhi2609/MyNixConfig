{ config, pkgs, lib, ... }:

{
  boot = {
    kernelParams = [ "quiet" "splash" "vm.swappiness=10" ];
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };
}