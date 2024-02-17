local M = { 'norcalli/nvim-colorizer.lua' }

M.cond = function(--[[plugin]]_)
  return vim.o.termguicolors
end

M.event = {
  'BufReadPost',
  'BufNewFile'
}

M.config = function(--[[plugin]]_, --[[opts]]_)
  require('colorizer').setup(--[[ filetypes ]] nil, {
    css  = true,             -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    mode = 'foreground',
  })
end

return M

