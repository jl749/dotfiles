{ pkgs, lib, config, ... }: {

  options = {
    discord.enable = lib.mkEnableOption "enables discord";
  };

  config = lib.mkIf config.discord.enable {
    # OpenAsar: slimmer startup/updater code, drops crash reporting.
    # Vencord: its NoTrack plugin (on by default) blocks Discord analytics + Sentry.
    environment.systemPackages = [
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
