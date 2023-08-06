local get_lazy = function()
  local path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(path) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--branch=stable',
      'https://github.com/folke/lazy.nvim.git',
      path,
    }
  end
  vim.opt.rtp:prepend(path)
  local _, lazy = pcall(require, 'lazy')
  return lazy
end

local lazy = get_lazy()
if lazy then
  lazy.setup('fschauen.plugins', {
    dev = {
      path = '~/Projects/nvim-plugins',
      fallback = true,
    },
    ui = {
      border = 'rounded',
    },
  })
else
  vim.notify('Lazy not installed and failed to bootstrap!', vim.log.levels.ERROR)
end

