{ config, pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # ── Navegador Web (Brave) ──
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
      "x-scheme-handler/about" = [ "brave-browser.desktop" ];
      "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];

      # ── Visor de PDF ──
      # Nota: Si prefieres otro, cambia masterpdfeditor5 por okular.desktop o pdfarranger.desktop
      "application/pdf" = [ "onlyoffice-desktopeditors.desktop" ];

      # ── Github Desktop ──
      "x-scheme-handler/x-github-client" = [ "github-desktop.desktop" ];
      "x-scheme-handler/x-github-desktop-auth" = [ "github-desktop.desktop" ];
      "x-scheme-handler/x-github-desktop-dev-auth" = [ "github-desktop.desktop" ];
    };
  };

  xdg.desktopEntries = {
    vscode-folder = {
      name = "Abrir con VS Code";
      exec = "code %F";
      icon = "vscode";
      terminal = false;
      type = "Application";
      mimeType = [ "inode/directory" ];
    };

    HydraAppimage = {
      name = "Hydra Launcher";
      exec = "${pkgs.appimage-run}/bin/appimage-run /home/zhi/Apps/hydra.appimage";
      icon = "/home/zhi/Apps/icons/hydra.png";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    };

    AffineAppimage = {
      name = "Affine";
      exec = "${pkgs.appimage-run}/bin/appimage-run /home/zhi/Apps/affine.appimage";
      icon = "/home/zhi/Apps/icons/affine.png";
      terminal = false;
      type = "Application";
      categories = [
        "Office"
        "Utility"
      ];
    };

    HayaseAppimage = {
      name = "Hayase";
      exec = "${pkgs.appimage-run}/bin/appimage-run /home/zhi/Apps/hayase.appimage";
      icon = "/home/zhi/Apps/icons/hayase.png";
      terminal = false;
      type = "Application";
      categories = [
        "AudioVideo"
        "Video"
      ];
    };
  };
}
