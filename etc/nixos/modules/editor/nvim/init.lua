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
-- Built-in LSP maps (Neovim 0.11+, no setup needed):
--   grn        rename
--   grr        references
--   gri        implementation
--   grt        type definition
--   gra        code action (normal + visual)
--   grx        run codelens
--   gO         document symbols
--   K          hover
--   <C-S>      signature help (insert mode)
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- no built-in for this one
    vim.api.nvim_buf_create_user_command(ev.buf, 'Format', function(_)
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format current buffer with LSP" })
  end
})
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = "clippy", -- force rust-analyzer to run clippy instead of cargo check
      },
    },
  },
})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { library = { vim.env.VIMRUNTIME } }, -- vim.* API autocompletes
    },
  },
})
vim.lsp.config('*', { capabilities = lsp_capabilities })
vim.lsp.enable({ 'pyright', 'rust_analyzer', 'clangd', 'lua_ls' })

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
-- The main-branch rewrite has no highlight module; each buffer must start treesitter itself
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'rust', 'python', 'nix' },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- [kylechui/nvim-surround]
require('nvim-surround').setup()

-- [lewis6991/gitsigns.nvim]
require('gitsigns').setup()
