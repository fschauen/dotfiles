local M = { 'mhartington/formatter.nvim' }

M.cmd = {
  'Format',
  'FormatLock',
  'FormatWrite',
  'FormatWriteLock',
}

M.keys = {
  { '<leader>F', '<cmd>Format<cr>', desc = '󰉼 Format file' },
  { '<leader>F', "<cmd>'<,'>Format<cr>", mode = 'v', desc = '󰉼 Format file' },
}

M.opts = function( --[[plugin]] _, opts)
  local ft = require('formatter.filetypes')
  return vim.tbl_deep_extend('force', opts or {}, {
    filetype = {
      c        = { ft.c.clangformat },
      cmake    = { ft.cmake.cmakeformat },
      cpp      = { ft.cpp.clangformat },
      cs       = { ft.cs.clangformat },
      json     = { ft.cs.prettier },
      lua      = { ft.lua.stylua },
      markdown = { ft.markdown.prettier },
      python   = {}, -- TODO: pick one
      sh       = { ft.sh.shfmt },
      zsh      = { ft.zsh.beautysh },
    }
  })
end

return M
