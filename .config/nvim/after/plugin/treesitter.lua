-- nvim/after/plugin/treesitter.lua

-- nvim-treesitter `main` branch: parsers are installed explicitly
-- (:TSInstall {language} still works). On NixOS the parsers come from nvim-treesitter.withPlugins instead.
-- The main-branch rewrite has no highlight module; each buffer must start treesitter itself
local langs = { 'c', 'cpp', 'rust', 'python', 'nix' }

require('nvim-treesitter').install(langs)

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
