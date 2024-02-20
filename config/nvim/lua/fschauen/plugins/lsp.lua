local border = { border = "rounded" }

local lsp_capabilities = function()
  local basic = vim.lsp.protocol.make_client_capabilities()
  local completion = vim.F.npcall(require, "cmp_nvim_lsp")
  if completion then
    return vim.tbl_deep_extend("force", basic, completion.default_capabilities())
  end
  return basic
end

local lsp_handlers = function()
  return {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border),
  }
end

local lsp_on_attach = function( --[[client]]_, buffer)
  local map = vim.keymap.set
  local opts = { buffer = buffer }
  local buf = vim.lsp.buf
  -- stylua: ignore start
  map("n", "<localleader>c", buf.code_action,     opts)
  map("n", "<localleader>f", buf.format,          opts)
  map("n", "gd",             buf.definition,      opts)
  map("n", "gD",             buf.declaration,     opts)
  map("n", "gi",             buf.implementation,  opts)
  map("n", "grr",            buf.rename,          opts)
  map("n", "gt",             buf.type_definition, opts)
  map("n", "K",              buf.hover,           opts)
  map("i", "<c-l>",          buf.signature_help,  opts)
  -- stylua: ignore end
end

local lsp_on_init = function(client)
  -- Opt out of semantic highlighting because it has been causing the issues
  --   https://github.com/neovim/nvim-lspconfig/issues/2542#issuecomment-1547019213
  if client.server_capabilities then
    client.server_capabilities.semanticTokensProvider = false
  end
end

local server_opts = setmetatable({
  lua_ls = function(opts)
    return vim.tbl_deep_extend("force", opts, {
      settings = {
        Lua = {
          -- I'm using lua only inside neovim, so the runtime is LuaJIT.
          runtime = { version = "LuaJIT" },

          -- Get the language server to recognize the `vim` global.
          diagnostics = { globals = { "vim" } },

          -- Make the server aware of Neovim runtime files.
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },

          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    })
  end,
  omnisharp = function(opts)
    return vim.tbl_deep_extend("force", opts, {
      -- Use .editoconfig for code style, naming convention and analyzer settings.
      enable_editorconfig_support = true,

      -- Show unimported types and add`using` directives.
      enable_import_completion = true,

      -- Enable roslyn analyzers, code fixes, and rulesets.
      enable_roslyn_analyzers = true,

      -- Don't include preview versions of the .NET SDK.
      sdk_include_prereleases = false,

      handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").handler,
      },
    })
  end,
}, {
  -- The default is a just a passthrough of the options.
  __index = function()
    return function(opts)
      return opts
    end
  end,
})

return {
  "neovim/nvim-lspconfig",

  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "Hoffs/omnisharp-extended-lsp.nvim",
  },

  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local defaults = {
      capabilities = lsp_capabilities(),
      handlers = lsp_handlers(),
      on_attach = lsp_on_attach,
      lsp_on_init = lsp_on_init,
    }

    require("lspconfig.ui.windows").default_options = border
    require("mason").setup { ui = border }
    require("mason-lspconfig").setup {
      ensure_installed = {
        "clangd",
        "cmake",
        "lua_ls",
        "pyright",
      },
      handlers = {
        function(server_name)
          local opts = server_opts[server_name](defaults)
          require("lspconfig")[server_name].setup(opts)
        end,
      },
    }
  end,
}
