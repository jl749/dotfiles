local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  -- {
  --   "folke/todo-comments.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   event = "VeryLazy",
  --   opts = {
  --     highlight = {
  --       pattern = [[.*<(KEYWORDS)\s*]],
  --     },
  --     search = {
  --       pattern = [[\b(KEYWORDS)\b]],
  --     },
  --     keywords = {
  --       TODO = { color = "info" },
  --       WARN = { color = "warning", alt = { "WARNING", "XXX" } },
  --       NOTE = { color = "hint", alt = { "INFO" } },
  --       TEST = { color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  --     },
  --   },
  -- },

  --   "crusj/bookmarks.nvim",
  --   keys = {
  --     { "\\<tab>", mode = { "n" } },
  --   },
  --   branch = "main",
  --   dependencies = { "nvim-web-devicons" },
  --   config = function()
  --     require("bookmarks").setup()
  --     require("telescope").load_extension "bookmarks"
  --   end,
  --   opts = {
  --     storage_dir = "", -- Default path: vim.fn.stdpath("data").."/bookmarks,  if not the default directory, should be absolute path",
  --     mappings_enabled = true, -- If the value is false, only valid for global keymaps: toggle、add、delete_on_virt、show_desc
  --     keymap = {
  --       toggle = "\\<tab>", -- Toggle bookmarks(global keymap)
  --       add = "\\z", -- Add bookmarks(global keymap)
  --       jump = "<CR>", -- Jump from bookmarks(buf keymap)
  --       delete = "dd", -- Delete bookmarks(buf keymap)
  --       order = "<space><space>", -- Order bookmarks by frequency or updated_time(buf keymap)
  --       delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
  --       show_desc = "\\sd", -- show bookmark desc(global keymap)
  --     },
  --     width = 0.8, -- Bookmarks window width:  (0, 1]
  --     height = 0.7, -- Bookmarks window height: (0, 1]
  --     preview_ratio = 0.45, -- Bookmarks preview window ratio (0, 1]
  --     tags_ratio = 0.1, -- Bookmarks tags window ratio
  --     fix_enable = false, -- If true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.

  --     virt_text = "", -- Show virt text at the end of bookmarked lines, if it is empty, use the description of bookmarks instead.
  --     sign_icon = "󰃃", -- if it is not empty, show icon in signColumn.
  --     virt_pattern = { "*.cpp", "*.h", "*.cc", "*.py" }, -- Show virt text only on matched pattern
  --     border_style = "single", -- border style: "single", "double", "rounded"
  --     hl = {
  --       border = "TelescopeBorder", -- border highlight
  --       cursorline = "guibg=Gray guifg=White", -- cursorline highlight
  --     },
  --   },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require("core.utils").load_mappings "dap"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs (/plugins/configs/...)
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
