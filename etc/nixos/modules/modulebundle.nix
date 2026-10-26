{ pkgs, lib, ... }: {
  imports = [
    ./desktopApp/firefox.nix
    ./desktopApp/brave.nix
    ./desktopApp/discord.nix
    ./desktopApp/gthumb.nix
    ./desktopApp/kdeconnect.nix
    ./desktopApp/spotify.nix
    ./desktopApp/steam.nix
    ./editor/neovim.nix
  ];

  firefox.enable = lib.mkDefault true;
  brave.enable = lib.mkDefault true;
  discord.enable = lib.mkDefault false;
  gthumb.enable = lib.mkDefault true;
  kdeconnect.enable = lib.mkDefault false;
  spotify.enable = lib.mkDefault false;
  steam.enable = lib.mkDefault false;
  neovim.enable = lib.mkDefault true;
}
