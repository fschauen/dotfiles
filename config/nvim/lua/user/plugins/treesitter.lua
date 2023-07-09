local config = function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cpp',
      'haskell',
      'html',
      'javascript',
      'latex',
      'lua',
      'make',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'toml',
      'vim',
      'vimdoc',
      'yaml',
    },

    highlight = {
      enable = true,
      disable = {
        'vimdoc',
      },
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',     -- mapped in normal mode
        node_incremental = '<CR>',  -- mapped in visual mode
        node_decremental = '<BS>',  -- mapped in visual mode
        scope_incremental = nil,    -- disabled, normally mapped in visual mode
      },
    },

    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },

      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = 'grr',
        },
      },

      navigation = {
        enable = true,
        keymaps = {
          goto_definition = 'gd',         -- default: 'gnd'
          list_definitions = nil,         -- disabled, default: 'gnD'
          list_definitions_toc = 'gO',
          goto_next_usage = '<a-*>',
          goto_previous_usage = '<a-#>',
        },
      },
    },

    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
          ['ac'] = '@conditional.outer',
          ['ic'] = '@conditional.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
        },
      },
    },

    playground = {
      enable = true,
    },
  }

  vim.keymap.set('n', '<leader>sp', '<cmd>TSPlaygroundToggle<cr>')
  vim.keymap.set('n', '<leader>sh', '<cmd>TSHighlightCapturesUnderCursor<cr>')
  vim.keymap.set('n', '<leader>sn', '<cmd>TSNodeUnderCursor<cr>')
end

return {
  'nvim-treesitter/nvim-treesitter',

  config = config,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-refactor',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
  },
}

