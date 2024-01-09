---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
--local highlights = require "custom.highlights"

M.ui = {
  -- changed_themes = {
  --   monochrome = {
  --     polish_hl = {
  --       -- ["@function"] = { fg = "#FFF3E0" },
  --       -- ["@function.call"] = { fg = "#FFF3E0" },
  --       -- ["@method"] = { fg = "#FFF3E0" },
  --       ["@variable.builtin"] = { fg = "" },
  --       ["@string"] = { fg = "#C5E1A5" },
  --       ["Include"] = { fg = "#A1887F" },
  --     },
  --   },
  -- },
  theme = "chocolate",
  theme_toggle = { "chocolate", "one_light" },

  -- hl_override = highlights.override,
  -- hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
