local config = function()
  -- Enable rounded borders for LSP handlers and :LspInfo windows.
  local border = 'rounded'
  for request, handler in pairs {
    ['textDocument/hover'] = vim.lsp.handlers.hover,
    ['textDocument/signatureHelp'] = vim.lsp.handlers.signature_help,
  } do
    vim.lsp.handlers[request] = vim.lsp.with(handler, { border = border })
  end
  require('lspconfig.ui.windows').default_options = { border = border }

  local opts = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),

    on_attach = function(--[[client]]_, bufnr)
      vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'  -- do completion with <c-x><c-o>
      local map, opts = vim.keymap.set, { buffer = bufnr }
      map('n', '<space>ca',   vim.lsp.buf.code_action,        opts)
      map('n', '<space>cf',   vim.lsp.buf.format,             opts)
      map('n', 'gD',          vim.lsp.buf.declaration,        opts)
      map('n', 'gd',          vim.lsp.buf.definition,         opts)
      map('n', 'K',           vim.lsp.buf.hover,              opts)
      map('n', 'gi',          vim.lsp.buf.implementation,     opts)
      map('n', 'grr',         vim.lsp.buf.rename,             opts)
      map('n', 'gt',          vim.lsp.buf.type_definition,    opts)
    end,

    on_init = function(client, --[[init_result]]_)
      -- Opt out of semantic highlighting because it has been casusing the issues
      -- https://github.com/neovim/nvim-lspconfig/issues/2542#issuecomment-1547019213
      if client.server_capabilities then
        client.server_capabilities.semanticTokensProvider = false
      end
    end,
  }

  local has_cmp, cmp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp then
    vim.tbl_deep_extend('force', opts.capabilities, cmp.default_capabilities())
  end

  require('mason').setup {}
  require('mason-lspconfig').setup {}
  require("mason-lspconfig").setup_handlers {
    --[[ default = ]] function(server)
      require('lspconfig')[server].setup(opts)
    end,

    lua_ls = function()
      require('lspconfig').lua_ls.setup(vim.tbl_extend('force', opts, {
        settings = {
          Lua = {
            -- I'm using lua only inside neovim, so the runtime is LuaJIT.
            runtime = { version = 'LuaJIT' },

            -- Get the language server to recognize the `vim` global.
            diagnostics = { globals = {'vim'} },

            -- Make the server aware of Neovim runtime files.
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },

            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      }))
    end,

    omnisharp = function()
      require('lspconfig').omnisharp.setup(vim.tbl_extend('force', opts, {
        -- Show unimported types and add`using` directives.
        enable_import_completion = true,

        -- Enable roslyn analyzers, code fixes, and rulesets.
        enable_roslyn_analyzers = true,

        -- Don't include preview versions of the .NET SDK.
        sdk_include_prereleases = false,
      }))
    end,
  }
end

return {
  'neovim/nvim-lspconfig',

  config = config,
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
}

