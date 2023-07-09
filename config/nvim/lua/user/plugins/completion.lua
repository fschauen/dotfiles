local config = function()
  local cmp = require('cmp')

  local mapping = {
    ['<c-n>'] = {
      i = function()
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          cmp.complete()
        end
      end,
    },

    ['<c-p>'] = {
      i = function()
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
          cmp.complete()
        end
      end,
    },

    ['<Down>'] = { i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select } },
    ['<Up>'] = { i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select } },

    ['<c-f>'] = { i = cmp.mapping.scroll_docs(4) },
    ['<c-b>'] = { i = cmp.mapping.scroll_docs(-4) },

    ['<c-e>'] = { i = cmp.mapping.abort() },
    ['<c-y>'] = { i = cmp.mapping.confirm { select = true } },
    ['<Tab>'] = {
      i = function(fallback)
        if cmp.visible() then
          cmp.confirm { select = true }
        else
          fallback()
        end
      end,
    },
  }

  cmp.setup {
    mapping = mapping,

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
    }, {
      { name = 'path' },
      { name = 'buffer', keyword_length = 5 },
    }),

    formatting = (function()
      local ok, lspkind = pcall(require, 'lspkind')
      if not ok then return {} end
      return {
        format = lspkind.cmp_format {
          mode = 'symbol_text',
          menu = {
            buffer   = "[buf]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[lua]",
            path     = "[path]",
          },
        },
      }
    end)(),

    experimental = {
      ghost_text = true,
    },
  }
end

return {
  'hrsh7th/nvim-cmp',

  config = config,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'onsails/lspkind-nvim',
  },
}

