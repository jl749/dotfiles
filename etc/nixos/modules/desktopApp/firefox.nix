{ pkgs, lib, config, ... }: {

  # TODO: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };

  config = {
    programs.firefox = lib.mkIf config.firefox.enable {
      enable = true;
      languagePacks = ["en-US"];

      # about:policies#documentation
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        # about:config
        Preferences = {};

        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked", "force_installed" and "normal_installed".
        ExtensionSettings = {
          # blocks all addons except the ones specified below
          "*".installation_mode = "blocked";
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };

    };
  };
}
