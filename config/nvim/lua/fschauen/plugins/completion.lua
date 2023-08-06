local config = function()
  local cmp = require('cmp')
  local map = cmp.mapping

  local flip    = require('fschauen.util').flip
  local partial = require('fschauen.util').partial

  -- assign('i',        { key = func, ... }) == { key = { i = func }, ... }
  -- assign({'i', 'c'}, { key = func, ... }) == { key = { i = func, c = func }, ...}
  local assign_keymap = function(modes, keymap)
    modes = type(modes) == 'table' and modes or { modes }
    return vim.tbl_map(partial(flip(map), modes), keymap)
  end

  local cond = function(condition, yes, no)
    return function(fallback)
      if condition() then yes(fallback) else no(fallback) end
    end
  end

  local keymap = {
    ['<c-n>']    = cond(cmp.visible,
                        map.select_next_item { behavior = cmp.SelectBehavior.Select },
                        map.complete()),
    ['<c-p>']    = cond(cmp.visible,
                        map.select_prev_item { behavior = cmp.SelectBehavior.Select },
                        map.complete()),

    ['<down>']   = map.select_next_item { behavior = cmp.SelectBehavior.Select },
    ['<up>']     = map.select_prev_item { behavior = cmp.SelectBehavior.Select },

    ['<c-f>']    = map.scroll_docs( 3),
    ['<s-down>'] = map.scroll_docs( 3),
    ['<c-b>']    = map.scroll_docs(-3),
    ['<s-up>']   = map.scroll_docs(-3),

    ['<c-e>']    = map.abort(),
    ['<c-y>']    = map.confirm { select = true },
    ['<tab>']    = cond(cmp.visible,
                        map.confirm { select = true },
                        function(fallback) fallback() end),
  }

  cmp.setup {
    mapping = assign_keymap('i', keymap),

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
          Array = '',
          Boolean = '',
          Class = '',
          Color = '',
          Constant = '󰏿',
          Constructor = '',
          Copilot = '',
          Enum = '',
          EnumMember = '',
          Event = '',
          Field = '',
          File = '',
          Folder = '',
          Function = '󰊕',
          Interface = '',
          Key = '',
          Keyword = '',
          Method = '',
          Module = '',
          Namespace = '',
          Null = '',
          Number = '',
          Object = '',
          Operator = '',
          Package = '',
          Property = '',
          Reference = '',
          Snippet = '',
          String = '',
          Struct = '',
          Text = '',
          TypeParameter = '',
          Unit = '',
          Value = '󰎠',
          Variable = '󰀫',
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
    mapping = assign_keymap('c', vim.tbl_extend('force', keymap, {
      ['<tab>'] = cond(cmp.visible, map.confirm {select = true }, map.complete()),
    })),

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

