{ config, pkgs, lib, ... }:

{
  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "es_MX.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
}