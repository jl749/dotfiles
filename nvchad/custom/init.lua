-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4

-- https://neovim.io/doc/user/fold.html
vim.opt.foldnestmax = 2
vim.opt.foldmethod = "indent"
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldminlines = 15
