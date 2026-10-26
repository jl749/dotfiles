{ config, pkgs, lib, ... }:

{
  # Hardware scan + this repo's shared module bundle.
  imports = [
    ./hardware-configuration.nix
    ../../modules/modulebundle.nix
  ];

  # ===================== 🌟 ✨  CUSTOM CONFIGS  ✨ 🌟  ===================== #
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # NOTE: Store cleanup is done by hand (`sudo nix-collect-garbage --delete-older-than 14d`, `nix store optimise`). Uncomment to automate:
  # nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 14d"; };
  # nix.optimise.automatic = true;                     # dedupe identical files in the store
  # boot.loader.systemd-boot.configurationLimit = 10;  # keep /boot (511M) from filling

  steam.enable = true;
  discord.enable = true;
  kdeconnect.enable = true;
  spotify.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # [UNFREE]
      "brave"

      "spotify"

      "claude-code"

      "steam"
      "steam-unwrapped"

      "discord"
    ];

  environment.systemPackages = with pkgs; [
    # BASE
    ripgrep
    unzip
    tmux
    vim
    lilypond
    gcc
    wget
    curl
    htop
    tree
    file
    git
    sshfs
    vlc
    libvlc
    lm_sensors

    # NVIM LSP - please install them under flake.nix
    # e.g. clang-tools, cargo, rust-analyzer, pyright, ...
    lua-language-server   # exception

    # UTILS
    # *common
    unstable.claude-code  # pulled from nixos-unstable via flake overlay
    unstable.codex        # pulled from nixos-unstable via flake overlay
    smartmontools
    jq
    yt-dlp
    # *screenshot
    grim           # grim -t png -o {monitor_name} "myscreenshot.png"
    slurp          # grim -g "$(slurp)"
    wl-clipboard   # grim -g "$(slurp)" - | wl-copy
    swappy         # grim -g "$(slurp)" - | swappy -f -  OR  wl-paste | swappy -f -

    # ETC
    wine64
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
  # ===================== 🌟 ✨  CUSTOM CONFIGS  ✨ 🌟  ===================== #

  # Bootloader: systemd-boot on EFI, with a memtest86+ entry in the menu.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.memtest86.enable = true;
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │ Blacklist faulty DRAM region found via memtest86+ (bad pages            │
  # │ 0x13280-0x1329f, physical 0x13280000-0x132a0000, ~128 KiB at ~306 MiB). │
  # │ Reserve a 1 MiB aligned block so the kernel never allocates the bad     │
  # │ cells. STOPGAP until the failing stick (likely the 16 GiB SODIMM) is    │
  # │ replaced.                                                               │
  # └─────────────────────────────────────────────────────────────────────────┘
  boot.kernelParams = [ "memmap=1M$0x13200000" ];

  # Networking: NetworkManager handles wired/wireless connections.
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  # Locale: English default, Korean also built. Hangul input via ibus
  # (add "Korean (Hangul)" under GNOME Settings > Keyboard > Input Sources).
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ko_KR.UTF-8/UTF-8" ];
  i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = [ pkgs.ibus-engines.hangul ];
  };

  # GNOME desktop (Wayland) with the GDM login manager.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Ctrl+Alt+T -> new GNOME Console (kgx) window.
  # The per-binding schema is relocatable, so it must be set as a dconf default; a gsettings vendor override can't reach it.
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Open console";
        command = "kgx";
        binding = "<Control><Alt>t";
      };
    };
  }];

  # Keyboard layout (read by GNOME on Wayland).
  services.xserver.xkb.layout = "us";

  # Audio via PipeWire (replacing PulseAudio) + Bluetooth (managed in GNOME Settings).
  hardware.bluetooth.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Primary user 'simp' (set the password with `passwd`).
  users.users.simp = {
    isNormalUser = true;
    description = "simp";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # No sshd: this machine only makes outgoing SSH connections (the ssh client is always installed).
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default settings for
  # stateful data (file locations, database versions) were taken. Leave it at the
  # release version of this system's first install; read the docs before changing.
  system.stateVersion = "24.05";


}
