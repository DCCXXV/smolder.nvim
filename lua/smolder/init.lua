local M = {}

M.config = {
  transparent = false,
  italic_comments = true,
  bold_keywords = true,
  terminal_colors = true,
  overrides = {},
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

local function set_terminal_colors(p)
  local colors = {
    p.bg1, p.red, p.green, p.orange, p.steel, p.mauve, p.teal, p.fg_dim,
    p.bg4, p.red, p.green, p.orange_bright, p.steel, p.mauve, p.teal, p.fg_bright,
  }
  for i, color in ipairs(colors) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "smolder"

  local p = require("smolder.palette")
  local groups = require("smolder.highlights").get(p, M.config)

  local overrides = M.config.overrides
  if type(overrides) == "function" then
    overrides = overrides(p)
  end
  groups = vim.tbl_extend("force", groups, overrides or {})

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if M.config.terminal_colors then
    set_terminal_colors(p)
  end
end

return M
