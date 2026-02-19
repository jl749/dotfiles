-- nvim/after/plugin/neotree.lua

require('neo-tree').setup {
	window = { 
		position = "right",
		width = 30
	},
	filesystem = {
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
