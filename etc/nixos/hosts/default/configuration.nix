{ config, pkgs, lib, ... }:

{
  # Hardware scan + this repo's shared module bundle.
  imports = [
    ./hardware-configuration.nix
    ../../modules/modulebundle.nix
  ];

  # ===================== 🌟 ✨  CUSTOM CONFIGS  ✨ 🌟  ===================== #
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  firefox.enable = true;
  steam.enable = true;

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
    glibcLocales
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

    # UTILS
    # *common
    unstable.claude-code   # pulled from nixos-unstable via flake overlay
    smartmontools
    jq
    yt-dlp
    gthumb         # built with -Dclutter=false, see overlay-gthumb in flake.nix
    qimgv
    # *screenshot
    grim           # grim -t png -o {monitor_name} "myscreenshot.png"
    slurp          # grim -g "$(slurp)"
    wl-clipboard   # grim -g "$(slurp)" - | wl-copy
    swappy         # grim -g "$(slurp)" - | swappy -f -  OR  wl-paste | swappy -f -

    # ETC
    wine64
    brave
    discord
    spotify
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    configure = {
      packages.myAwesomePlugins = with pkgs.vimPlugins; {
        # list of plugins loaded on startup
        start = [
          # plenary-nvim
          # nui-nvim
          # nvim-web-devicons

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

      customRC = ''
        lua << EOF
          -- [VIM]
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '
          vim.o.clipboard = 'unnamedplus'
          vim.o.number = true
          vim.o.relativenumber = true
          vim.o.signcolumn = 'yes'
          vim.o.tabstop = 2
          vim.o.shiftwidth = 2
          vim.o.expandtab = true
          vim.o.updatetime = 300
          vim.o.termguicolors = true
          vim.o.mouse = ""
          vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal' }) 
          vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = 'Show diagnostic: error message' })
          vim.keymap.set('n', 'gH', vim.diagnostic.setloclist, { desc = 'Open diagnostic: quickfix' })
          vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left pane' })
          vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right pane' })
          vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower pane' })
          vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper pane' })
          vim.cmd.colorscheme 'desert'

          -- [nvim-telescope/telescope.nvim]
          local builtin = require('telescope.builtin')
          require('telescope').setup{
            pickers = { find_files = { hidden = true } },
            defaults = {
              mappings = {
                i = {
                  ['<A-j>'] = 'move_selection_next',
                  ['<A-k>'] = 'move_selection_previous',
                  ['<esc>'] = 'close'
                }
              }
            }
          }
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

          -- [LSP]
          local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(ev)
              local opts = { buffer = ev.buf }
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.api.nvim_buf_create_user_command(ev.buf, 'Format', function(_)
                vim.lsp.buf.format({ async = true })
              end, { desc = "Format current buffer with LSP" })
            end
          })
          vim.lsp.config('*', { capabilities = lsp_capabilities })
          vim.lsp.enable({ 'pyright', 'rust_analyzer', 'clangd' })

          -- [hrsh7th/nvim-cmp]
          local cmp = require('cmp')
          cmp.setup({
            mapping = cmp.mapping.preset.insert({
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<Tab>'] = cmp.mapping.confirm({ select = true }),
              ['<M-j>'] = cmp.mapping.select_next_item(),
              ['<M-k>'] = cmp.mapping.select_prev_item(),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' }, -- suggestions from active LSPs
            })
          })

          -- [nvim-neo-tree/neo-tree.nvim]
          local ok, neotree = pcall(require, "neo-tree")
          if ok then
            neotree.setup {
              window = { 
                position = "right",
                width = 30
              },
              filesystem = {
                hijack_netrw_behavior = "disabled",
                filtered_items = {
                  visible = true,
                  hide_dotfiles = false,
                  hide_gitignored = true,
                  hide_by_name = { "__pycache__", ".github" },
                  never_show = { ".git" }
                }
              }
            }
            vim.keymap.set('n', '<C-M-e>', ':Neotree toggle<CR>', { desc = "Toggle NeoTree" })
          end

          -- [nvim-treesitter/nvim-treesitter]
          vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'c', 'cpp', 'rust', 'python', 'nix' },
            callback = function()
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
          })

          -- [kylechui/nvim-surround]
          require('nvim-surround').setup()

          -- [lewis6991/gitsigns.nvim]
          require('gitsigns').setup() 
        EOF
      '';
    };
  };
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
  # (run `ibus-setup` once per user to enable the engine).
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ko_KR.UTF-8/UTF-8" ];
  i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = [ pkgs.ibus-engines.hangul ];
  };

  # X11 server (also backs XWayland under the default GNOME Wayland session).
  services.xserver.enable = true;

  # GNOME desktop with the GDM login manager.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Ctrl+Alt+T -> new GNOME Console (kgx) window. The per-binding schema is
  # relocatable, so it must be set as a dconf default; a gsettings vendor
  # override can't reach it.
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

  # Keyboard layout.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing (CUPS).
  services.printing.enable = true;

  # Audio via PipeWire (replacing PulseAudio) + Bluetooth with Blueman.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" "fuse" ];
    packages = with pkgs; [
    ];
  };

  # Remote login over SSH.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default settings for
  # stateful data (file locations, database versions) were taken. Leave it at the
  # release version of this system's first install; read the docs before changing.
  system.stateVersion = "24.05";


}
