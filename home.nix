{ config, pkgs, ... }:

{
  # =========================================
  # USER ENVIRONMENT & IDENTITY
  # =========================================
  home.username = "zhi";
  home.homeDirectory = "/home/zhi";

  # =========================================
  # XDG USER DIRECTORIES
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

    desktopEntries = {
      "org.kde.kwrite" = {
        name = "KWrite";
        noDisplay = true;
      };
      printcraft = {
        name = "PrintCraft";
        genericName = "PDF Editor";
        comment = "Read, organize, combine, split and secure PDFs";
        exec = "printcraft %F";
        icon = "ai.storyteller.printcraft";
        terminal = false;
        categories = [ "Office" "Viewer" "Graphics" ];
        mimeType = [ "application/pdf" ];
      };
    };
  };

  gtk = {
    enable = true;
    gtk2.enable = false; # Evita que Home Manager intente gestionar ~/.gtkrc-2.0 y choque con KDE Plasma
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };

  # =========================================
  # TERMINAL EMULATOR (KITTY)
  # =========================================
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11.0;
    };

    settings = {
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      background_opacity = "0.92";
      dynamic_background_opacity = true;
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_font_style = "bold";

      scrollback_lines = 10000;
    };
  };
  # =========================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "kphoen";
      plugins = [ "git" "sudo" "z" "history" ];
    };
    shellAliases = {
      rebuild = "nh os switch /etc/nixos -H Suisei";
      upgrade = "nh os switch /etc/nixos -H Suisei --update";
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
    affine
    flameshot
    krita
    libreoffice
    onlyoffice-desktopeditors
    openjdk25
    parabolic
    peazip
    proton-vpn
    qbittorrent
    rclone
    vesktop
    krename
    prismlauncher
    appimage-run
    bazaar
    (brave-origin.override {
      commandLineArgs = "--password-store=kwallet6";
    })
    dbeaver-bin
    flutter
    heroic
    hydralauncher
    lutris
    masterpdfeditor
    nixfmt
    nodejs
    opencode
    pandoc
    pdfarranger
    pear-desktop
    telegram-desktop
    sigil
    upscayl
    vlc
    vscode
    wl-clipboard
    xclip
    yazi

    # --- Entorno de Programación (Python) ---
    (python3.withPackages (ps: [
      ps.tkinter
      ps.pyside6
      ps.pyinstaller
      ps.pdf2docx
    ]))

    # --- Bash ConversorEpubs ---
    (pkgs.writeShellScriptBin "conversor-epub" ''
      cd /home/zhi/Documentos/conversor-epub/app_flutter
      exec ./build/linux/x64/release/bundle/ConversorEpubs
    '')

    # --- PrintCraft AppImage Wrapper ---
    (pkgs.writeShellScriptBin "printcraft" ''
      exec appimage-run /home/zhi/.AppImages/printcraft-0.2.0-linux-x86_64.AppImage "$@"
    '')
  ];

  # =========================================
  # STATE VERSION
  # =========================================
  home.stateVersion = "26.05";
}
