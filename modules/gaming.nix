{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
    extraPackages = [
      pkgs.protontricks
      (pkgs.python3.withPackages (ps: [
        ps.tkinter
        ps.pyside6
      ]))
    ];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
}
