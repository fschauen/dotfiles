local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local id = augroup("my_autocmds", { clear = true} )

autocmd({'BufNewFile', 'BufRead'}, {
  desc = 'Make it possible to use `gf` to jump to my neovim lua modules.',
  group = id,
  pattern = 'init.lua',
  command = "setlocal path+=~/.config/nvim/lua includeexpr=substitute(v:fname,'\\\\.','/','g')"
})

autocmd('InsertEnter', {
  desc = 'Disable `cursorline` when entering Insert mode.',
  group = id,
  pattern = '*',
  callback = function(args)
    vim.w.had_cursorline = vim.opt.cursorline:get()
    vim.opt.cursorline = false
  end
})

autocmd('InsertLeave', {
  desc = 'Enable `cursorline` when leaving Insert mode (if it was set before entering).',
  group = id,
  pattern = '*',
  callback = function(args) vim.opt.cursorline = vim.w.had_cursorline end
})

autocmd('TextYankPost', {
  desc = 'Briefly highlight yanked text.',
  group = id,
  pattern = '*',
  callback = function(args) vim.highlight.on_yank() end
})

