-- nvim/lua/pluginlist.lua
-- Contians all the plugins

return {
	-- {
	-- 	"sainnhe/gurvbox-material.nvim",
	-- 	-- loads before other plugins
	-- 	priority = 1000,
	-- 	-- function to run after the plugin is loaded
	-- 	config = function()
	-- 		vim.cmd("colorscheme gruvbox")
	-- 	end
	-- },
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	'neovim/nvim-lspconfig',
	'folke/neodev.nvim',
	'lewis6991/gitsigns.nvim',

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
			'hrsh7th/cmp-nvim-lsp',
		},
	},

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
		version = '*', -- Use for stability; omit to use `main` branch for the latest features
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},
}
