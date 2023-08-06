local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local id = augroup("my_autocmds", { clear = true} )

autocmd({'BufNewFile', 'BufRead'}, {
  desc = 'Make it possible to use `gf` to jump to my neovim lua modules.',
  group = id,
  pattern = 'init.lua',
  command = "setlocal path+=~/.config/nvim/lua includeexpr=substitute(v:fname,'\\\\.','/','g')"
})

autocmd('TextYankPost', {
  desc = 'Briefly highlight yanked text.',
  group = id,
  pattern = '*',
  callback = function(_) vim.highlight.on_yank() end
})

autocmd('User', {
  desc = 'Enable line number in Telescope previewers.',
  group = id,
  pattern = 'TelescopePreviewerLoaded',
  command = 'setlocal number'
})

