-- nvim/after/plugin/lsp.lua

-- install mason :Mason
-- install language server with `i` delete by `X`
-- (on NixOS the servers come from flake.nix instead; mason fills that role here)
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "pyright", "rust_analyzer", "clangd" },
})

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

-- check :checkhealth vim.lsp to confirm lsp is attached correctly
