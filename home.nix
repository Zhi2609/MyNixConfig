{ config, pkgs, ... }:

{
  # =========================================
  # USER ENVIRONMENT & IDENTITY
  # =========================================
  home.username = "zhi";
  home.homeDirectory = "/home/zhi";

  # =========================================
  # XDG USER DIRECTORIES & DESKTOP ENTRIES
  # =========================================
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Escritorio";
      documents = "${config.home.homeDirectory}/Documentos";
      download = "${config.home.homeDirectory}/Descargas";
      music = "${config.home.homeDirectory}/Música";
      pictures = "${config.home.homeDirectory}/Imágenes";
      videos = "${config.home.homeDirectory}/Videos";
    };

    /*
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "brave-browser.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        "x-scheme-handler/about" = [ "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
        "application/pdf" = [ "onlyoffice-desktopeditors.desktop" ];
        "x-scheme-handler/x-github-client" = [ "github-desktop.desktop" ];
        "x-scheme-handler/x-github-desktop-auth" = [ "github-desktop.desktop" ];
        "x-scheme-handler/x-github-desktop-dev-auth" = [ "github-desktop.desktop" ];
      };
    };

    desktopEntries = {
      ConversorEpub = {
        name = "Conversor EPUB";
        exec = "${pkgs.appimage-run}/bin/appimage-run /home/zhi/Documentos/conversor-epub/dist/ConversorEpub";
        icon = "/home/zhi/Documentos/conversor-epub/assets/ConversorEpub.png";
        terminal = false;
        type = "Application";
        categories = ["Utility" "Office" ];
      };
    }; */
  };

  # =========================================
  # SHELL CONFIGURATION (ZSH)
  # =========================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "kphoen";
      plugins = [ "git" "sudo" "z" "history" "docker" ];
    };
    shellAliases = {
      rebuild = "nh os switch";
      upgrade = "nh os switch --update";
      gcclean = "nh clean all";
      nxsearch = "nh search";
      game = "prime-run";
      ll = "ls -lah --color=auto";
      la = "ls -A --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      gs = "git status";
      gp = "git push";
      gl = "git pull";
      perfgame = "mangohud gamemoderun gamescope -f --";
    };
    initContent = ''
      HISTSIZE=50000
      SAVEHIST=50000
      setopt HIST_IGNORE_ALL_DUPS
      setopt SHARE_HISTORY
      fastfetch
    '';
  };

  # =========================================
  # GAMING OVERLAYS (MANGOHUD)
  # =========================================
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

  # =========================================
  # VERSION CONTROL (GIT)
  # =========================================
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Cesar Garcia";
        email = "cesaremiliogarciagtz254@gmail.com";
      };
      init = { defaultBranch = "main"; };
      pull = { rebase = false; };
    };
  };

  # =========================================
  # USER PACKAGES
  # =========================================
  home.packages = with pkgs; [
    # --- Paquetes Estables (pkgs.stable) ---
    pkgs.stable.affine
    pkgs.stable.bottles
    pkgs.stable.flameshot
    pkgs.stable.krita
    pkgs.stable.libreoffice
    pkgs.stable.onlyoffice-desktopeditors
    pkgs.stable.openjdk25
    pkgs.stable.parabolic
    pkgs.stable.peazip
    pkgs.stable.proton-vpn
    pkgs.stable.protontricks
    pkgs.stable.qbittorrent
    pkgs.stable.rclone
    pkgs.stable.sigil
    pkgs.stable.vesktop
    pkgs.stable.krename

    # --- Paquetes Inestables (pkgs) ---
    antigravity-cli
    appimage-run
    bazaar
    brave-origin
    dbeaver-bin
    gamemode
    goverlay
    heroic
    hydralauncher
    lutris
    mangohud
    masterpdfeditor
    nixfmt
    nodejs
    opencode
    pandoc
    pdfarranger
    pear-desktop
    telegram-desktop
    upscayl
    vlc
    vscode
    yazi

    # --- Entorno de Programación (Python) ---
    (python3.withPackages (ps: [
      ps.tkinter
      ps.pyside6
    ]))
  ];

  # =========================================
  # STATE VERSION
  # =========================================
  home.stateVersion = "26.05";
}
