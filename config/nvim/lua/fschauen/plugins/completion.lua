local icons = require("fschauen.util.icons")

local make_keymap = function(cmp)
  local select = { behavior = cmp.SelectBehavior.Select }

  local if_visible = function(yes, no)
    return function(fallback)
      if cmp.visible() then
        yes(fallback)
      else
        no(fallback)
      end
    end
  end

  -- Mappings that should work in both command line and Insert mode.
  local common = {
    -- stylua: ignore start
    ["<c-n>"]    = if_visible(cmp.mapping.select_next_item(select), cmp.mapping.complete()),
    ["<c-p>"]    = if_visible(cmp.mapping.select_prev_item(select), cmp.mapping.complete()),

    ["<down>"]   = cmp.mapping.select_next_item(select),
    ["<up>"]     = cmp.mapping.select_prev_item(select),

    ["<c-f>"]    = cmp.mapping.scroll_docs( 3),
    ["<s-down>"] = cmp.mapping.scroll_docs( 3),
    ["<c-b>"]    = cmp.mapping.scroll_docs(-3),
    ["<s-up>"]   = cmp.mapping.scroll_docs(-3),

    ["<c-e>"]    = cmp.mapping.abort(),
    ["<c-y>"]    = cmp.mapping.confirm { select = true },
    -- stylua: ignore end
  }

  -- I want <tab> to start completion on the command line, but not in Insert.
  local keymap = {
    ["<tab>"] = {
      i = if_visible(cmp.mapping.confirm { select = true }, function(fallback)
        fallback()
      end),
      c = if_visible(cmp.mapping.confirm { select = true }, cmp.mapping.complete()),
    },
  }

  -- Turn { lhs = rhs } into { lhs = { i = rhs, c = rhs } }.
  for lhs, rhs in pairs(common) do
    keymap[lhs] = { i = rhs, c = rhs }
  end

  return cmp.mapping.preset.insert(keymap)
end

return {
  "hrsh7th/nvim-cmp",

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind-nvim",

    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },

  event = { "CmdlineEnter", "InsertEnter" },

  config = function()
    local cmp = require("cmp")
    local keymap = make_keymap(cmp)

    cmp.setup {
      mapping = keymap,

      enabled = function()
        local ctx = require("cmp.config.context")
        return not ctx.in_treesitter_capture("comment") and not ctx.in_syntax_group("Comment")
      end,

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      formatting = {
        format = require("lspkind").cmp_format {
          mode = "symbol_text",
          symbol_map = icons.kind,
          menu = {
            buffer = "buf",
            nvim_lsp = "LSP",
            nvim_lua = "lua",
            path = "",
          },
        },
      },

      sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
      }),

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      experimental = { ghost_text = true },
    }

    cmp.setup.cmdline(":", {
      mapping = keymap,
      completion = { autocomplete = false },
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    cmp.setup.filetype("TelescopePrompt", {
      enabled = false,
    })
  end,
}
