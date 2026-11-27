-- nvim/after/plugin/lsp.lua

-- install mason :Mason
-- install language server with `i` delete by `X`
-- (on NixOS the servers come from flake.nix instead; mason fills that role here)
local servers = { 'pyright', 'rust_analyzer', 'clangd', 'lua_ls' }
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
  automatic_enable = false, -- enabled explicitly below, same as the nix config
})

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
vim.lsp.enable(servers)

-- check :checkhealth vim.lsp to confirm lsp is attached correctly
