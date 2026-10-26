{ pkgs, lib, config, ... }: {

  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;

      preferences = {
        # AI / local ML engine (policy GenerativeAI covers the UI; this stops the backend)
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
        # leftover pings not covered by DisableTelemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "browser.discovery.enabled" = false;
        # no connections to pages you didn't open
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # strongest anti-fingerprinting; side effects: UTC timezone, light theme reported to sites, letterboxed window size. Set to false if a site misbehaves.
        "privacy.resistFingerprinting" = true;
      };

      # about:policies#documentation
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisableFeedbackCommands = true;
        DisableFirefoxAccounts = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        HttpsOnlyMode = "enabled";
        # don't send typed text to the search engine / Mozilla before Enter
        SearchSuggestEnabled = false;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        GenerativeAI = {
          Enabled = false;
          Chatbot = false;
          LinkPreviews = false;
          SmartWindow = false;
          TabGroups = false;
          Locked = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        # new tab page: no sponsored tiles/stories
        FirefoxHome = {
          SponsoredTopSites = false;
          SponsoredStories = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          SkipOnboarding = true;
        };

        # about:config
        Preferences = {};

        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked", "force_installed" and "normal_installed".
        ExtensionSettings = {
          # blocks all addons except the ones specified below (also blocks themes and dictionaries)
          "*".installation_mode = "blocked";

          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        # uBlock Origin managed config, re-applied on every Firefox start
        # (dashboard changes to these revert on restart).
        # List IDs: https://github.com/gorhill/uBlock/blob/master/assets/assets.json
        "3rdparty".Extensions."uBlock0@raymondhill.net" = {
          userSettings = [
            [ "webrtcIPAddressHidden" "true" ]     # don't leak local/LAN IPs via WebRTC
            [ "prefetchingDisabled" "true" ]       # default, pinned
            [ "hyperlinkAuditingDisabled" "true" ] # default, pinned (<a ping>)
            [ "cnameUncloakEnabled" "true" ]       # default, pinned (catches CNAME-disguised trackers)
            [ "cloudStorageEnabled" "false" ]
          ];
          toOverwrite.filterLists = [
            # uBO defaults
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "plowe-0"
            # extra privacy/security (off by default)
            "adguard-spyware-url"   # strips tracking params (utm_*, fbclid, ...) from URLs
            "block-lan"             # stops sites probing your LAN/localhost
            "curben-phishing"       # phishing URL blocklist
          ];
        };
      };
    };
  };
}
