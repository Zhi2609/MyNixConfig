{ config, pkgs, ... }:

{
  imports = [
    ./modules/user/core.nix
    ./modules/user/shell.nix
    ./modules/user/apps.nix
    ./modules/user/xdgParameters.nix
  ];

  home.stateVersion = "26.05";
}
