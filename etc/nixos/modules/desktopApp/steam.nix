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

    environment.sessionVariables = {
      # in case you have to run `protonup` to install the latest proton versions
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/simp/.steam/root/compatibilitytools.d";  
    };
  };
}
