-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = { fg = "teal", italic = true },
  Function = { fg = "red", bold = true, underline = true },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },

  -- https://neovim.io/doc/user/api.html#nvim_set_hl()
  -- vim.api.nvim_set_hl(0, "method", { bold = true, underline = true })
  -- to view options -> Telescope highlights
  -- to confirm -> hi method
  -- to get the highlight group -> :Inspect
}

return M
