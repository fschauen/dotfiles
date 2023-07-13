local config = function()
  local cmp = require('cmp')

  local when = function(condition)
    local default = function(fallback) fallback() end
    return function(opts)
      local yes = opts.yes or default
      local no  = opts.no  or default
      return function(fallback)
        if condition() then yes(fallback) else no(fallback) end
      end
    end
  end

  local keymap = setmetatable({}, {
    __newindex = function(t, k, v)
      rawset(t, k, { i = v, c = v})
    end,
  })

  keymap['<c-n>'] = when(cmp.visible) {
    yes = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
    no  = cmp.mapping.complete(),
  }

  keymap['<c-p>'] = when(cmp.visible) {
    yes = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    no = cmp.mapping.complete(),
  }

  keymap['<down>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }
  keymap['<up>']   = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }

  keymap['<c-f>']    = cmp.mapping.scroll_docs(4)
  keymap['<s-down>'] = cmp.mapping.scroll_docs(4)
  keymap['<c-b>']    = cmp.mapping.scroll_docs(-4)
  keymap['<s-up>']   = cmp.mapping.scroll_docs(-4)

  keymap['<c-e>'] = cmp.mapping.abort()
  keymap['<c-y>'] = cmp.mapping.confirm { select = true }
  keymap['<tab>'] = when(cmp.visible) { yes = cmp.mapping.confirm { select = true } }


  cmp.setup {
    mapping = keymap,

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
    mapping = keymap,

    completion = {
      autocomplete = false,
    },

    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
  })
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

