{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ─── Navegadores Web ───
    # (brave.override {
    #  commandLineArgs = "--ozone-platform=x11";
    #})
    brave

    # ─── Comunicación ───
    telegram-desktop
    vesktop

    # ─── Desarrollo y Programación ───
    bazaar
    github-desktop
    jetbrains-toolbox
    vscode-fhs
    nodejs
    openjdk25
    opencode
    pandoc

    # ─── Gaming ───
    gamemode
    goverlay
    heroic
    lutris
    mangohud
    protonplus
    protontricks

    # ─── Ofimática, Documentos y Lectura ───
    libreoffice
    masterpdfeditor
    onlyoffice-desktopeditors
    pdfarranger
    sigil

    # ─── Multimedia y Creatividad ───
    flameshot
    krita
    upscayl
    vlc

    # ─── Herramientas del Sistema y Virtualización ───
    virt-manager
    appimage-run

    # ─── Herramientas de Consola (CLI) ───
    yazi
    nixfmt
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frametime = true;
      cpu_stats = true;
      cpu_temp = true;
      gpu_stats = true;
      gpu_temp = true;
      gpu_mem_used = true;
      vram = true;
      ram = true;
      engine_version = true;
      vulkan_driver = true;
      wine = true;
      position = "top-left";
      font_size = 20;
      background_alpha = "0.4";
      round_corners = 5;
      toggle_hud = "Shift_R+F12";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Cesar Garcia"; # Nombre actualizado para los commits
        email = "cesaremiliogarciagtz254@gmail.com"; # Recuerda cambiar esto por tu email real
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
    };
  };

}
