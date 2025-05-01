# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/modulebundle.nix
    ];

  # === custom configs === #
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  firefox.enable = true;
  steam.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # [UNFREE]
      # "google-chrome"
      "vscode"
      "brave"
      "steam"
      "steam-unwrapped"
      "discord"
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # BASE
    glibcLocales
    tmux
    vim
    gcc
    wget
    htop
    tree
    file
    git
    sshfs
    vlc
    libvlc

    # UTILS
    # *common
    yt-dlp
    gthumb
    # *screenshot
    grim           # grim -t png -o {monitor_name} "myscreenshot.png"
    slurp          # grim -g "$(slurp)"
    wl-clipboard   # grim -g "$(slurp)" - | wl-copy
    swappy         # grim -g "$(slurp)" - | swappy -f -  OR  wl-paste | swappy -f -

    # ETC
    wine64
    vscode
    brave
    mangohud
    protonup
    lutris
    discord
  ];
  # === custom configs === #

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  # https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=locale
  # https://nixos.org/manual/nixos/stable/index.html#module-services-input-methods-ibus
  # ibus-daemon -d
  # ibus-setup
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ko_KR.UTF-8/UTF-8" ];
  i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = [ pkgs.ibus-engines.hangul ];
  };
  i18n.glibcLocales = pkgs.glibcLocales;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverridePackages = with pkgs; [ gnome-settings-daemon ];
    extraGSettingsOverrides = ''
      [org.gnome.settings-daemon.plugins.media-keys]
      custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

      [org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0]
      binding='<Primary><Alt>t'
      command='kgx'
      name='Open terminal'
    '';
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simp = {
    isNormalUser = true;
    description = "simp";
    extraGroups = [ "networkmanager" "wheel" "fuse" ];
    packages = with pkgs; [
    ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?


}
