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

local dev_path = function()
  local paths = {
    '~/Projects/nvim-plugins',
    '~/.local/src',
  }
  paths = vim.tbl_map(vim.fn.expand, paths)
  paths = vim.tbl_filter(vim.loop.fs_stat, paths)
  return paths[1]
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
      path = dev_path(),
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
end

return M
