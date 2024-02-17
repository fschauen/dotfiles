local M = { 'neovim/nvim-lspconfig' }

M.dependencies = {
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'Hoffs/omnisharp-extended-lsp.nvim',
}

M.event = {
  'BufReadPre',
  'BufNewFile',
}

M.config = function(--[[plugin]]_, --[[opts]]_)
  local border = { border = 'rounded' }

  local default_opts = {
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      vim.F.npcall(function() require('cmp_nvim_lsp').default_capabilities() end) or {}
    ),

    handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, border),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, border),
    },

    on_attach = function(--[[client]]_, bufnr)
      vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'  -- do completion with <c-x><c-o>
      local map, opts = vim.keymap.set, { buffer = bufnr }
      map('n', '<localleader>c',  vim.lsp.buf.code_action,        opts)
      map('n', '<localleader>f',  vim.lsp.buf.format,             opts)
      map('n', 'gd',              vim.lsp.buf.definition,         opts)
      map('n', 'gD',              vim.lsp.buf.declaration,        opts)
      map('n', 'gi',              vim.lsp.buf.implementation,     opts)
      map('n', 'grr',             vim.lsp.buf.rename,             opts)
      map('n', 'gt',              vim.lsp.buf.type_definition,    opts)
      map('n', 'K',               vim.lsp.buf.hover,              opts)
      map('i', '<c-l>',           vim.lsp.buf.signature_help,     opts)
    end,

    on_init = function(client, --[[init_result]]_)
      -- Opt out of semantic highlighting because it has been causing the issues
      -- https://github.com/neovim/nvim-lspconfig/issues/2542#issuecomment-1547019213
      if client.server_capabilities then
        client.server_capabilities.semanticTokensProvider = false
      end
    end,
  }

  require('lspconfig.ui.windows').default_options = border
  require('mason').setup { ui = border }
  require('mason-lspconfig').setup {
    handlers = {
      --[[default =]] function(server)
        require('lspconfig')[server].setup(default_opts)
      end,

      lua_ls = function(--[[server]]_)
        local opts = vim.tbl_deep_extend('force', default_opts, {
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
        })
        require('lspconfig').lua_ls.setup(opts)
      end,

      omnisharp = function(--[[server]]_)
        local opts = vim.tbl_deep_extend('force', default_opts, {
          -- Use .editoconfig for code style, naming convention and analyzer settings.
          enable_editorconfig_support = true,

          -- Show unimported types and add`using` directives.
          enable_import_completion = true,

          -- Enable roslyn analyzers, code fixes, and rulesets.
          enable_roslyn_analyzers = true,

          -- Don't include preview versions of the .NET SDK.
          sdk_include_prereleases = false,

          handlers = {
             ['textDocument/definition'] = require('omnisharp_extended').handler,
          },
        })
        require('lspconfig').omnisharp.setup(opts)
      end,
    },
  }
end

return M

