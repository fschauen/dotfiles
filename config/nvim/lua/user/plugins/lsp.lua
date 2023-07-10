local filetypes = {
  cs = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
}

local on_attach = function(client, bufnr)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'  -- do completion with <c-x><c-o>

  local map = vim.keymap.set
  local opts = { buffer = bufnr }

  map('n', '<space>ca',   vim.lsp.buf.code_action,                opts)
  map('n', '<space>cf',   vim.lsp.buf.format,                     opts)
  map('n', 'gD',          vim.lsp.buf.declaration,                opts)
  map('n', 'gd',          vim.lsp.buf.definition,                 opts)
  map('n', 'K',           vim.lsp.buf.hover,                      opts)
  map('n', 'gi',          vim.lsp.buf.implementation,             opts)
  map('n', 'grr',         vim.lsp.buf.rename,                     opts)
  map('n', 'gt',          vim.lsp.buf.type_definition,            opts)

  local filetype_attach = filetypes[vim.bo.filetype]
  if filetype_attach then filetype_attach(client, bufnr) end
end

local config = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp then
    vim.tbl_deep_extend('force', capabilities, cmp.default_capabilities())
  end

  local lsp = require 'lspconfig'
  require('mason').setup()
  require('mason-lspconfig').setup {
    handlers = {
      -- default handler
      function(server)
        require('lspconfig')[server].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,

      omnisharp = function()
        lsp.omnisharp.setup {
          on_attach = on_attach,
          capabilities = capabilities,

          -- Support for showing unimported types and adding `using` directives.
          enable_import_completion = true,

          -- Don't include preview versions of the .NET SDK.
          sdk_include_prereleases = false,
        }
      end,

      lua_ls = function()
        lsp.lua_ls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
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
        }
      end,
    }
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

