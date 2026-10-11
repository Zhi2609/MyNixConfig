{ pkgs, ... }:

{
  # Servidor X11 / Display Manager (SDDM Wayland)
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Entorno de Escritorio: KDE Plasma 6 y Cinnamon
  services.desktopManager.plasma6.enable = true;

  # services.xserver.desktopManager.cinnamon.enable = true;

  # Excluir aplicaciones por defecto de KDE Plasma 6
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
    khelpcenter
  ];

  # Excluir terminales por defecto de XServer
  services.xserver.excludePackages = [
    pkgs.xterm
  ];

  # SDDM KCM para configuración visual desde Preferencias de KDE
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${../wallpaper.jpg}
    '')
  ];

  # Portales XDG para compatibilidad Wayland / Flatpak
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Configuración de distribución de teclado
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Servidor de Audio Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Fuentes del sistema
  fonts.packages = with pkgs; [
    corefonts
    google-fonts
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
