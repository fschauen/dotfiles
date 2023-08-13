return {
  'hrsh7th/nvim-cmp',
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
  keys = require('fschauen.keymap').completion,
  config = function()
    local cmp = require('cmp')

    cmp.setup {
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
  end,
}

