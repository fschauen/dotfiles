local config = function()
  local cmp = require('cmp')

  local mapping = function(mode)
    return {
      ['<c-n>'] = {
        [mode] = function()
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          else
            cmp.complete()
          end
        end,
      },

      ['<c-p>'] = {
        [mode] = function()
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
          else
            cmp.complete()
          end
        end,
      },

      ['<Down>'] = { [mode] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select } },
      ['<Up>'] = { [mode] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select } },

      ['<c-f>'] = { [mode] = cmp.mapping.scroll_docs(4) },
      ['<c-b>'] = { [mode] = cmp.mapping.scroll_docs(-4) },

      ['<c-e>'] = { [mode] = cmp.mapping.abort() },
      ['<c-y>'] = { [mode] = cmp.mapping.confirm { select = true } },
      ['<Tab>'] = {
        [mode] = function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true }
          else
            fallback()
          end
        end,
      },
    }
  end

  cmp.setup {
    mapping = mapping('i'),

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

  cmp.setup.cmdline(':', {
    mapping = mapping('c'),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return {
  { 'hrsh7th/nvim-cmp', config = config },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'onsails/lspkind-nvim',
}

