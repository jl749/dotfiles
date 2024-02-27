local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- python
  b.formatting.black.with {
    filetypes = { "python" },
    extra_args = { "--line-length=120" }, --"--skip-string-normalization"
  },
  b.formatting.isort.with {
    extra_args = { "--profile", "black", "--line-length", "120" },
  },
  b.diagnostics.ruff,
}

-- clang autoformatting related
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds {
      group = augroup,
      buffer = bufnr,
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { bufnr = bufnr }
      end,
    })
  end
end

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = on_attach,
}
