local M = {}

local bootstrap = function(path)
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
end

M.setup = function()
  local lazy = bootstrap(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')
  if not lazy then
    vim.notify('Lazy not installed and failed to bootstrap!', vim.log.levels.WARN)
    return
  end

  vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>')

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
    change_detection = {
      notify = false,
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
end

return M

