return {
  "folke/trouble.nvim",

  dependencies = "nvim-tree/nvim-web-devicons",

  keys = {
    -- stylua: ignore start
    { "<leader>lt", "<cmd>TroubleToggle<cr>",                       desc = "󱠪 trouble [t]toggle" },
    { "<leader>lw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "󱠪 trouble [w]orkspace"  },
    { "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "󱠪 trouble [d]ocument"  },
    -- stylua: ignore end
  },

  opts = {
    padding = false, -- don't add an extra new line of top of the list
    auto_preview = false, -- don't preview automatically
  },
}
