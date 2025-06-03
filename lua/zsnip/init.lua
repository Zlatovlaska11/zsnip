local M = {}

local config = require("zsnip.config")

function M.setup(opts)
  config.setup(opts)
  vim.api.nvim_create_user_command("SnippetSave", function()
    require("zsnip.core").SaveSnippet()
  end, {
    range = true,
  })

  vim.api.nvim_create_user_command("SnippetShow", function()
    require("zsnip.core").ShowSnippets()
  end, {})
end

return M
