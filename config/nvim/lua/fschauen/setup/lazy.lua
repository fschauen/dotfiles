local lazy = (function()
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
  return vim.F.npcall(require, 'lazy')
end)()

if lazy then
  lazy.setup {
    spec = 'fschauen.plugins',
    dev = {
      path = '~/Projects/nvim-plugins',
      fallback = true,
    },
    ui = {
      border = 'rounded',
      title = '  Lazy  ',
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }
else
  vim.notify('Lazy not installed and failed to bootstrap!', vim.log.levels.WARN)
end

