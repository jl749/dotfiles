-- nvim/lua/pluginlist.lua
-- Contians all the plugins

return {
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	'neovim/nvim-lspconfig',
	'lewis6991/gitsigns.nvim',

	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
	},

	{
		'kylechui/nvim-surround',
		version = '*',
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({})
		end
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
	},
}
