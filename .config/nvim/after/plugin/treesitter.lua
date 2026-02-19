-- nvim/after/plugin/treesitter.lua

-- :TSinstall {language_name}
require('nvim-treesitter.configs').setup {
	ensure_installed = { 'vim', 'vimdoc', 'lua', 'rust', 'python', 'cpp' },
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
}
