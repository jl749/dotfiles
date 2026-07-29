-- nvim/after/plugin/treesitter.lua

-- nvim-treesitter `main` branch: parsers are installed explicitly
-- (:TSInstall {language} still works) and highlight/indent are turned on per buffer.
-- On NixOS the parsers come from nvim-treesitter.withPlugins instead.
local langs = { 'c', 'cpp', 'rust', 'python', 'nix' }

require('nvim-treesitter').install(langs)

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
