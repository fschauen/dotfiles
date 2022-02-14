local nmap = require'fs.util'.nmap

local setup = function()
  vim.g.better_whitespace_filetypes_blacklist = {
    'diff', 'git', 'gitcommit', 'help', 'fugitive'
  }
end

local config = function()
  -- fix whitespace
  nmap { '<leader>w', '<cmd>StripWhitespace<cr>' }

  -- show/hide whitespace
  nmap { '<leader>sw', '<cmd>ToggleWhitespace<cr>' }
end

return { config = config, setup = setup }

