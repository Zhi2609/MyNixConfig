{ config, pkgs, ... }:

{
  home.username = "zhi"; # Cambiado a zhi
  home.homeDirectory = "/home/zhi"; # Directorio actualizado

  home.packages = with pkgs; [
    # ─── Navegadores Web ───
    firefox
    (brave.override {
      commandLineArgs = "--ozone-platform=x11";
    })

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
    gearlever
    virt-manager

    # ─── Herramientas de Consola (CLI) ───
    yazi
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable  = true;
      theme   = "kphoen";
      plugins = [ "git" "sudo" "z" "history" "docker" ];
    };

    shellAliases = {
      # Los alias fueron actualizados con el nombre Suisei
      rebuild  = "sudo nixos-rebuild switch --flake /etc/nixos#Suisei";
      upgrade  = "sudo nixos-rebuild switch --flake /etc/nixos#Suisei --upgrade";
      gcclean  = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake /etc/nixos#Suisei";
      nxsearch = "nix search nixpkgs";
      game     = "nvidia-offload";
      ll  = "ls -lah --color=auto";
      la  = "ls -A --color=auto";
      ".."  = "cd ..";
      "..." = "cd ../..";
      gs  = "git status";
      gp  = "git push";
      gl  = "git pull";
      temps   = "watch -n 2 sensors";
      gpustat = "nvtop";
    };

    initContent = ''
      HISTSIZE=50000
      SAVEHIST=50000
      setopt HIST_IGNORE_ALL_DUPS
      setopt SHARE_HISTORY

      fastfetch
    '';
  };

  programs.git = {
    enable    = true;
    settings = {
        user = {
            name  = "Cesar Garcia"; # Nombre actualizado para los commits
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

  programs.mangohud = {
    enable = true;
    settings = {
      fps = true; frametime = true; cpu_stats = true; cpu_temp = true;
      gpu_stats = true; gpu_temp = true; gpu_mem_used = true; vram = true;
      ram = true; engine_version = true; vulkan_driver = true; wine = true;
      position = "top-left"; font_size = 20; background_alpha = "0.4";
      round_corners = 5; toggle_hud = "Shift_R+F12";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop     = "${config.home.homeDirectory}/Escritorio";
      documents   = "${config.home.homeDirectory}/Documentos";
      download    = "${config.home.homeDirectory}/Descargas";
      music       = "${config.home.homeDirectory}/Música";
      pictures    = "${config.home.homeDirectory}/Imágenes";
      videos      = "${config.home.homeDirectory}/Videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # ── Navegador Web (Brave) ──
        "text/html"                = [ "brave-browser.desktop" ];
        "x-scheme-handler/http"    = [ "brave-browser.desktop" ];
        "x-scheme-handler/https"   = [ "brave-browser.desktop" ];
        "x-scheme-handler/about"   = [ "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];

        # ── Visor de PDF ──
        # Nota: Si prefieres otro, cambia masterpdfeditor5 por okular.desktop o pdfarranger.desktop
        "application/pdf"          = [ "onlyoffice-desktopeditors.desktop" ];

        # ── Github Desktop ──
        "x-scheme-handler/x-github-client"       = [ "github-desktop.desktop" ];
        "x-scheme-handler/x-github-desktop-auth" = [ "github-desktop.desktop" ];
        "x-scheme-handler/x-github-desktop-dev-auth" = [ "github-desktop.desktop" ];
      };
    };

    desktopEntries = {
      vscode-folder = {
        name = "Abrir con VS Code";
        exec = "code %F";
        icon = "vscode";
        terminal = false;
        type = "Application";
        mimeType = [ "inode/directory" ];
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name    = "Layan-Dark";
      package = pkgs.layan-gtk-theme;
    };
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.stateVersion = "26.05";
}
