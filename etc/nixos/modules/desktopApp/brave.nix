{ pkgs, lib, config, ... }: {

  options = {
    brave.enable = lib.mkEnableOption "enables brave";
  };

  config = lib.mkIf config.brave.enable {
    environment.systemPackages = [ pkgs.brave ];

    environment.etc."brave/policies/managed/privacy.json".text = builtins.toJSON {
      # [Brave] telemetry/pings
      BraveP3AEnabled = false;
      BraveStatsPingEnabled = false;
      BraveWebDiscoveryEnabled = false;

      # [Brave] bundled features you don't use (lighter, fewer background requests)
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      BraveAIChatEnabled = false;
      BraveLocalAIEnabled = false;
      BraveNewsDisabled = true;
      BraveTalkDisabled = true;
      BravePlaylistEnabled = false;
      BraveWaybackMachineEnabled = false; # asks archive.org about every 404

      # [Brave] privacy features, on by default; pinned
      BraveGlobalPrivacyControlEnabled = true;
      BraveDeAmpEnabled = true;
      BraveDebouncingEnabled = true;
      BraveTrackingQueryParametersFilteringEnabled = true;
      BraveReduceLanguageEnabled = true;

      # [Chromium] telemetry
      MetricsReportingEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;

      # [Chromium] don't send typed text / page data to remote services
      SearchSuggestEnabled = false;
      AlternateErrorPagesEnabled = false;
      SpellCheckServiceEnabled = false;
      NetworkPredictionOptions = 2; # no preloading/prefetching

      # [Chromium] accounts, sync, passwords, autofill (same choices as firefox.nix)
      SyncDisabled = true;
      BrowserSignin = 0;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      PaymentMethodQueryEnabled = false;

      # [Chromium] hardening
      BlockThirdPartyCookies = true;
      HttpsOnlyMode = "force_enabled";
      WebRtcIPHandling = "default_public_interface_only"; # don't leak local/LAN IPs

      # [Chromium] nags and background work
      BackgroundModeEnabled = false;
      DefaultBrowserSettingEnabled = false;
      PromotionalTabsEnabled = false;
    };
  };
}
