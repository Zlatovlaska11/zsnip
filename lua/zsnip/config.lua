local M = {}

-- Default opts
M.options = {
  snippet_path = vim.fn.stdpath("data") .. "/zsnip/snippets.json",
}

function M.setup(user_opts)
  M.options = vim.tbl_deep_extend("force", M.options, user_opts or {})
end

return M

