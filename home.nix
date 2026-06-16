{ config, pkgs, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/shell.nix
    ./modules/apps.nix
    ./modules/xdgParameters.nix
  ];

  home.stateVersion = "26.05";
}
