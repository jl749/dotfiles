{ pkgs, lib, config, ... }: {

  options = {
    neovim.enable = lib.mkEnableOption "enables neovim with plugins and lua config";
  };

  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = false;
      configure = {
        packages.myAwesomePlugins = with pkgs.vimPlugins; {
          # list of plugins loaded on startup
          start = [
            # nvim-neo-tree/neo-tree.nvim
            neo-tree-nvim

            # lewis6991/gitsigns.nvim
            gitsigns-nvim

            # neovim/nvim-lspconfig
            nvim-lspconfig

            # hrsh7th/nvim-cmp
            nvim-cmp

            # hrsh7th/cmp-nvim-lsp
            cmp-nvim-lsp

            # nvim-telescope/telescope.nvim
            telescope-nvim

            # kylechui/nvim-surround
            nvim-surround

            # nvim-treesitter/nvim-treesitter
            (nvim-treesitter.withPlugins (p: [
              p.c
              p.cpp
              p.rust
              p.python
              p.nix
            ]))
          ];
          # plugins loaded manually via :packadd
          opt = [ ];
        };

        # NVIM LSP servers are not installed here - add them in each project's flake.nix
        # e.g. clang-tools, rust-analyzer, pyright, ...
        customLuaRC = builtins.readFile ./nvim/init.lua;
      };
    };
  };
}
