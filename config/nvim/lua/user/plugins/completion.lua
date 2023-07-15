local config = function()
  local cmp = require('cmp')

  local partial = require('user.util').partial
  local flip    = require('user.util').flip

  -- assign('i',        { key = func, ... }) == { key = { i = func }, ... }
  -- assign({'i', 'c'}, { key = func, ... }) == { key = { i = func, c = func }, ...}
  local assign = function(modes, tbl)
    modes = type(modes) == 'table' and modes or { modes }
    return vim.tbl_map(partial(flip(cmp.mapping), modes), tbl)
  end

  local invoke_fallback = function(fallback) fallback() end

  local when = function(condition)
    return function(opts)
      local yes = opts.yes or invoke_fallback
      local no  = opts.no  or invoke_fallback
      return function(fallback)
        if condition() then yes(fallback) else no(fallback) end
      end
    end
  end

  local keymap = {
    ['<c-n>'] = when(cmp.visible) {
      yes = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      no  = cmp.mapping.complete(),
    },

    ['<c-p>'] = when(cmp.visible) {
      yes = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
      no = cmp.mapping.complete(),
    },

    ['<down>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
    ['<up>']   = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },

    ['<c-f>']    = cmp.mapping.scroll_docs(4),
    ['<s-down>'] = cmp.mapping.scroll_docs(4),
    ['<c-b>']    = cmp.mapping.scroll_docs(-4),
    ['<s-up>']   = cmp.mapping.scroll_docs(-4),

    ['<c-e>'] = cmp.mapping.abort(),
    ['<c-y>'] = cmp.mapping.confirm { select = true },
    ['<tab>'] = when(cmp.visible) { yes = cmp.mapping.confirm { select = true } },
  }

  cmp.setup {
    mapping = assign('i', keymap),

    enabled = function()
      local c = require 'cmp.config.context'
      return  not c.in_treesitter_capture('comment') and
              not c.in_syntax_group('Comment')
    end,

    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },

    formatting = {
      format = require('lspkind').cmp_format {
        mode = 'symbol_text',

        menu = {
          buffer   = 'buf',
          nvim_lsp = 'LSP',
          nvim_lua = 'lua',
          path     = '',
        },

        -- Custom mix of lspkind defaults and VS Code codicons :)
        symbol_map = {
          Text = '',          -- VS Code
          Method = '󰆧',        -- lspkind
          Function = '󰊕',      -- lspkind
          Constructor = '',   -- lspkind
          Field = '󰜢',         -- lspkind
          Variable = '󰀫',      -- lspkind
          Class = '',         -- VS Code
          Interface = '',     -- VS Code
          Module = '',        -- VS Code
          Property = '',      -- VS Code
          Unit = '',          -- VS Code
          Value = '󰎠',         -- lspkind
          Enum = '',          -- lspkind
          Keyword = '',       -- VS Code
          Snippet = '',       -- VS Code
          Color = '',         -- VS Code
          File = '',          -- VS Code
          Reference = '',     -- VS Code
          Folder = '',        -- VS Code
          EnumMember = '',    -- lspkind
          Constant = '󰏿',      -- lspkind
          Struct = '',        -- VS Code
          Event = '',         -- VS Code
          Operator = '',      -- VS Code
          TypeParameter = '', -- VS Code
        },
      },
    },

    sources = cmp.config.sources({
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'path' },
      { name = 'buffer', keyword_length = 5 },
    }),

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    experimental = {
      ghost_text = true,
    },
  }


  cmp.setup.cmdline(':', {
    mapping = assign(
      'c',
      vim.tbl_extend('force', keymap, {
        ['<tab>'] = when(cmp.visible) {
          yes = cmp.mapping.confirm { select = true },
          no  = cmp.mapping.complete(),
        }
      })
    ),

    completion = {
      autocomplete = false,
    },

    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
  })

  cmp.setup.filetype('TelescopePrompt', { enabled = false })
end

return {
  'hrsh7th/nvim-cmp',

  config = config,

  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'onsails/lspkind-nvim',

    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
}

