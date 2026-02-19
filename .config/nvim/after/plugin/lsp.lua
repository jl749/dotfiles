-- nvim/after/plugin/lsp.lua

local function my_awesome_lsp_on_attach(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format({ async = true })
  end, { desc = "Format current buffer with LSP" })
end

-- install mason :Mason
-- install language server with `i` delete by `X`
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "pyright", "rust_analyzer", "clangd" },
  automatic_installation = true,
})

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
    function (server_name)
        lspconfig[server_name].setup({
            on_attach = my_awesome_lsp_on_attach,
        })
    end,
    -- NOTE: can add specific overrides for certain servers here if needed
    -- ["rust_analyzer"] = function() ... end
})

-- check :LspInfo to confirm lsp is attached correctly
