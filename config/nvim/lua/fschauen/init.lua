local M = {}

P = function(v)
  print(vim.inspect(v))
  return v
end

R = function(module)
  require('plenary.reload').reload_module(module)
  return require(module)
end


local bootstrap_lazy = function(path)
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

local setup_plugins = function()
  local lazy = bootstrap_lazy(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')
  if not lazy then
    vim.notify('Lazy not installed and failed to bootstrap!', vim.log.levels.WARN)
    return
  end

  lazy.setup {
    spec = 'fschauen.plugins',
    -- defaults = {
      --   lazy = true,
      -- },
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
end

M.setup = function()
  require('fschauen.options').setup()
  require('fschauen.keymap').setup()
  require('fschauen.diagnostic').setup()
  require('fschauen.autocmd').setup()

  vim.filetype.add {
    pattern = {
      ['${HOME}/.ssh/config.d/.*'] = 'sshconfig',
      ['.*/ssh/config'] = 'sshconfig',
      ['.*/git/config'] = 'gitconfig',
    }
  }

  setup_plugins()

  local colorscheme = 'gruvbox'
  vim.cmd('silent! colorscheme ' .. colorscheme)
  if vim.v.errmsg ~= '' then
    vim.notify(('Colorscheme %s not found!'):format(colorscheme), vim.log.levels.WARN)
  end
end

return M

