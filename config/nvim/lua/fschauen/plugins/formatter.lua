return {
  "mhartington/formatter.nvim",

  cmd = {
    "Format",
    "FormatLock",
    "FormatWrite",
    "FormatWriteLock",
  },

  keys = {
    -- stylua: ignore start
    { "<leader>F", "<cmd>Format<cr>",                  desc = "󰉼 Format file" },
    { "<leader>F", "<cmd>'<,'>Format<cr>", mode = "v", desc = "󰉼 Format file" },
    -- stylua: ignore end
  },

  opts = function(_, opts)
    local ft = require("formatter.filetypes")
    return vim.tbl_deep_extend("force", opts or {}, {
      filetype = {
        -- stylua: ignore start
        c        = {ft.c.clangformat},
        cmake    = {ft.cmake.cmakeformat},
        cpp      = {ft.cpp.clangformat},
        cs       = {ft.cs.clangformat},
        json     = {ft.cs.prettier},
        lua      = {ft.lua.stylua},
        markdown = {ft.markdown.prettier},
        python   = {}, -- TODO: pick one
        sh       = {ft.sh.shfmt},
        zsh      = {ft.zsh.beautysh},
        -- stylua: ignore end
      },
    })
  end,
}
