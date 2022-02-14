local util = require'fs.util'
local nmap = util.nmap
local colors = util.colors()
local highlight = util.highlight

local setup = function()
  vim.g.better_whitespace_filetypes_blacklist = {
    'diff', 'git', 'gitcommit', 'help', 'fugitive'
  }
end

local config = function()
  highlight('ExtraWhitespace') { fg = colors.orange, bg = colors.orange }

  -- fix whitespace
  nmap { '<leader>w', '<cmd>StripWhitespace<cr>' }

  -- show/hide whitespace
  nmap { '<leader>sw', '<cmd>ToggleWhitespace<cr>' }
end

return { config = config, setup = setup }

