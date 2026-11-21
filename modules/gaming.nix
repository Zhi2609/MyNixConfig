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

  # Priorización automática de procesos y juegos (sin parámetros de lanzamiento)
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Planificador sched_ext optimizado para gaming y baja latencia
  services.scx-loader = {
    enable = true;
    config.default_sched = "scx_lavd";
  };
}
