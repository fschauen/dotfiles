local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("fschauen", { clear = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Briefly highlight yanked text.",
    group = group,
    pattern = "*",
    callback = function(_)
      vim.highlight.on_yank()
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    desc = "Hide cursor line when entering insert mode.",
    group = group,
    pattern = "*",
    callback = function(_)
      vim.opt.cursorlineopt = "number"
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    desc = "Show cursor line when leaving insert mode.",
    group = group,
    pattern = "*",
    callback = function(_)
      vim.opt.cursorlineopt = "both"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Replicate gitcommit filetype options for Neogit commit.",
    group = group,
    pattern = "NeogitCommitMessage",
    callback = function(_)
      require("fschauen.util.options").set_gitcommit_buffer_options()
    end,
  })
end

return M
