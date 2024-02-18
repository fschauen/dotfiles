local M = { 'neovim/nvim-lspconfig' }

M.dependencies = {
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'Hoffs/omnisharp-extended-lsp.nvim',
}

M.event = { 'BufReadPre', 'BufNewFile' }

M.config = function( --[[plugin]] _, --[[opts]] _)
  local border = { border = 'rounded' }

  local defaults = {
    capabilities = vim.tbl_deep_extend('force',
      vim.lsp.protocol.make_client_capabilities(),
      vim.F.npcall(function() require('cmp_nvim_lsp').default_capabilities() end) or {}),

    handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, border),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, border),
    },

    on_attach = function( --[[client]] _, buffer)
      local map = vim.keymap.set
      local buf = vim.lsp.buf
      local map_opts = { buffer = buffer }
      map('n', '<localleader>c', buf.code_action, map_opts)
      map('n', '<localleader>f', buf.format, map_opts)
      map('n', 'gd', buf.definition, map_opts)
      map('n', 'gD', buf.declaration, map_opts)
      map('n', 'gi', buf.implementation, map_opts)
      map('n', 'grr', buf.rename, map_opts)
      map('n', 'gt', buf.type_definition, map_opts)
      map('n', 'K', buf.hover, map_opts)
      map('i', '<c-l>', buf.signature_help, map_opts)
    end,

    on_init = function(client, --[[init_result]] _)
      -- Opt out of semantic highlighting because it has been causing the issues
      -- https://github.com/neovim/nvim-lspconfig/issues/2542#issuecomment-1547019213
      if client.server_capabilities then
        client.server_capabilities.semanticTokensProvider = false
      end
    end,
  }

  local server_opts = setmetatable({
    lua_ls = function(opts)
      return vim.tbl_deep_extend('force', opts, {
        settings = {
          Lua = {
            -- I'm using lua only inside neovim, so the runtime is LuaJIT.
            runtime = { version = 'LuaJIT' },

            -- Get the language server to recognize the `vim` global.
            diagnostics = { globals = { 'vim' } },

            -- Make the server aware of Neovim runtime files.
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },

            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      })
    end,
    omnisharp = function(opts)
      return vim.tbl_deep_extend('force', opts, {
        -- Use .editoconfig for code style, naming convention and analyzer settings.
        enable_editorconfig_support = true,

        -- Show unimported types and add`using` directives.
        enable_import_completion = true,

        -- Enable roslyn analyzers, code fixes, and rulesets.
        enable_roslyn_analyzers = true,

        -- Don't include preview versions of the .NET SDK.
        sdk_include_prereleases = false,

        handlers = { ['textDocument/definition'] = require('omnisharp_extended').handler },
      })
    end,
  }, {
    __index = function( --[[tbl]] _, --[[key]] _)
      return function(opts) return opts end
    end
  })

  require('lspconfig.ui.windows').default_options = border
  require('mason').setup { ui = border }
  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local opts = server_opts[server_name](defaults)
        require('lspconfig')[server_name].setup(opts)
      end,
    },
  }
end

return M
