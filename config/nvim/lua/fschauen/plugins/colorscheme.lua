return {
  {
    'fschauen/solarized.nvim',
    dev = true,
  },
  {
    'fschauen/gruvbox.nvim',
    dev = true,
    config = function ()
      vim.cmd [[colorscheme gruvbox]]
    end,
  },
}

