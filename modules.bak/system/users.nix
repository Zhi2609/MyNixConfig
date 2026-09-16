{ config, pkgs, lib, ... }:

{
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
}