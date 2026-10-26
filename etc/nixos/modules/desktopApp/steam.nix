{ pkgs, lib, config, ... }: {

  options = {
    steam.enable = lib.mkEnableOption "enables steam";
  };

  config = lib.mkIf config.steam.enable {
    # on steam launch options:
    #   gamemoderun %command%
    #   mangohud %command%
    #   gamescope %command%
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    # GE-Proton, selectable per game under Properties > Compatibility; updates with the flake
    programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];

    environment.systemPackages = [ pkgs.mangohud ];
  };
}
