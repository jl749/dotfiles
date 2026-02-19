{ pkgs, lib, ... }: {
  imports = [
    ./desktopApp/firefox.nix
    ./desktopApp/steam.nix
  ];

  firefox.enable = lib.mkDefault true;
  steam.enable = lib.mkDefault false;
}
