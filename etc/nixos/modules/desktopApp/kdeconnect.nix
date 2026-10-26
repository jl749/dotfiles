{ pkgs, lib, config, ... }: {

  options = {
    kdeconnect.enable = lib.mkEnableOption "enables KDE Connect (via GSConnect on GNOME)";
  };

  config = lib.mkIf config.kdeconnect.enable {
    # GSConnect: KDE Connect protocol as a GNOME Shell extension (no KDE libraries pulled in).
    # Compatible with the KDE Connect phone app. Turn it on in the Extensions app after login.
    # The module also opens TCP/UDP 1714-1764 in the firewall for device discovery.
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
