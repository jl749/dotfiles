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
      "brave"

      "steam"
      "steam-unwrapped"

      "discord"

      "code"
      "vscode"
      "vscode-fhs"
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    htop
    tree
    file
    git
    sshfs
    vlc
    libvlc

    # NVIM LSP - please install them under flake.nix
    # clang-tools
    # cargo
    # rust-analyzer
    # pyright

    # UTILS
    # *common
    jq
    yt-dlp
    gthumb
    # *screenshot
    grim           # grim -t png -o {monitor_name} "myscreenshot.png"
    slurp          # grim -g "$(slurp)"
    wl-clipboard   # grim -g "$(slurp)" - | wl-copy
    swappy         # grim -g "$(slurp)" - | swappy -f -  OR  wl-paste | swappy -f -

    # ETC
    wine64
    vscode-fhs
    brave
    discord
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
          vim.o.clipboard = 'unnamed'
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
          local function my_awesome_lsp_on_attach(client, bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format({ async = true })
            end, { desc = "Format current buffer with LSP" })
          end
          for _, server in ipairs({ "pyright", "rust_analyzer", "clangd" }) do
            vim.lsp.config(server, { on_attach = my_awesome_lsp_on_attach })
            vim.lsp.enable(server) -- start the server for the current buffer
          end

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
                  hide_by_name = { "__pycache__", ".git", ".github" },
                  never_show = { ".git" }
                }
              }
            }
            vim.keymap.set('n', '<C-M-e>', ':Neotree toggle<CR>', { desc = "Toggle NeoTree" })
          end

          -- [nvim-treesitter/nvim-treesitter]
          require('nvim-treesitter').setup {
            ensure_installed = {},
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
          }

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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.desktopManager.gnome = {
    extraGSettingsOverridePackages = with pkgs; [ gnome-settings-daemon ];
    extraGSettingsOverrides = ''
      [org.gnome.settings-daemon.plugins.media-keys]
      custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

      [org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0]
      binding='<Control><Alt>t'
      command='kgx'
      name='Open console'
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
