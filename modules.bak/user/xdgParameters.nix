{ config, pkgs, ... }:

{
  xdg.mimeApps = {
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
      exec = "${pkgs.appimage-run}/bin/appimage-run ${config.home.homeDirectory}/Apps/hydra.appimage";
      icon = "${config.home.homeDirectory}/Apps/icons/hydra.png";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    };

    AffineAppimage = {
      name = "Affine";
      exec = "${pkgs.appimage-run}/bin/appimage-run ${config.home.homeDirectory}/Apps/affine.appimage";
      icon = "${config.home.homeDirectory}/Apps/icons/affine.png";
      terminal = false;
      type = "Application";
      categories = [ "Office" "Utility" ];
    };

    HayaseAppimage = {
      name = "Hayase";
      exec = "${pkgs.appimage-run}/bin/appimage-run ${config.home.homeDirectory}/Apps/hayase.appimage";
      icon = "${config.home.homeDirectory}/Apps/icons/hayase.png";
      terminal = false;
      type = "Application";
      categories = [ "AudioVideo" "Video" ];
    };
  };
}