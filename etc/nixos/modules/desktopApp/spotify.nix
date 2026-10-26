{ pkgs, lib, config, ... }: {

  options = {
    spotify.enable = lib.mkEnableOption "enables spotify";
  };

  config = lib.mkIf config.spotify.enable {
    environment.systemPackages = [ pkgs.spotify ];
  };
}
