local config = function()
  local cmp = require('cmp')

  local map = setmetatable({
    complete_or_select_next = function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end,

    complete_or_select_previous = function()
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end,

    tab_completion = function(fallback)
      if cmp.visible() then
        cmp.complete_common_string()
      elseif vim.fn.mode() == 'c' then
        cmp.complete()
      else
        fallback()
      end
    end,
  }, {
    -- Make `func` available in [i]nsert and [c]mdline modes.
    __call = function(_, func) return { i = func, c = func } end
  })

  local keymap = {
    ['<c-n>']     = map(map.complete_or_select_next),
    ['<c-p>']     = map(map.complete_or_select_previous),

    ['<down>']    = map(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }),
    ['<up>']      = map(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }),

    ['<c-f>']     = map(cmp.mapping.scroll_docs(4)),
    ['<s-down>']  = map(cmp.mapping.scroll_docs(4)),
    ['<c-b>']     = map(cmp.mapping.scroll_docs(-4)),
    ['<s-up>']    = map(cmp.mapping.scroll_docs(-4)),

    ['<c-e>']     = map(cmp.mapping.abort()),
    ['<c-y>']     = map(cmp.mapping.confirm { select = true }),
    ['<tab>']     = map(map.tab_completion),
  }

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

