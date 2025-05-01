{ pkgs, lib, ... }:

{
  vim = {
    luaConfigRC.myconfig-dir = ''
    -- ~/.config/nvf/lua/nvim-config
    require("nvim-config");
    '';
    theme = {
      enable = true;
    };
    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
    languages = {
      enableLSP = true;
      enableTreesitter = true;
      nix.enable = true;
      clang.enable = true;
    };
  };
}
