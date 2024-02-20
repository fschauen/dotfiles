return {
  "norcalli/nvim-colorizer.lua",

  cond = function(_)
    return vim.o.termguicolors
  end,

  event = { "BufNewFile", "BufReadPost" },

  opts = {
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    mode = "foreground",
  },

  config = function(_, opts)
    require("colorizer").setup(nil, opts)
  end,
}
