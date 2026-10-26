{ pkgs, lib, config, ... }: {

  options = {
    gthumb.enable = lib.mkEnableOption "enables gthumb";
  };

  config = lib.mkIf config.gthumb.enable {
    # 3.12.10 segfaults with Clutter (Clutter 1.26 unmaintained since 2020); build without it
    environment.systemPackages = [
      (pkgs.gthumb.overrideAttrs (old: {
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dclutter=false" ];
      }))
    ];
  };
}
