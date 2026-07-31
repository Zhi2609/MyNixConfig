{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "Suisei";
    networkmanager.enable = true;
    firewall.enable = true;
  };
}