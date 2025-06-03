local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local config = require("zsnip.config")

local M = {}

local function append_snippet(snippet)
  local path = config.options.snippet_path

  local snippets = {}
  if vim.fn.filereadable(path) == 1 then
    local lines = vim.fn.readfile(path)
    local json = table.concat(lines, "\n")
    local ok, parsed = pcall(vim.fn.json_decode, json)
    if ok and type(parsed) == "table" then
      snippets = parsed
    end
  end

  table.insert(snippets, snippet)

  local encoded = vim.fn.json_encode(snippets)

  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile({ encoded }, path)
end

function M.SaveSnippet()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.fn.getline(start_line, end_line)

  local title = vim.fn.input("Enter snippet name: ")

  local snippet = {
    title = title,
    content = table.concat(lines, "\n"),
    filetype = vim.bo.filetype,
    created_at = os.time(),
  }

  append_snippet(snippet)
end

function M.DeleteSnippet(name)
  local filepath = config.options.snippet_path

  if vim.fn.filereadable(filepath) == 0 then
    print("No snippets found.")
    return
  end

  local lines   = vim.fn.readfile(filepath)
  local decoded = vim.fn.json_decode(table.concat(lines, "\n"))
  if type(decoded) ~= "table" then
    print("Failed to parse snippets.json")
    return
  end
  local snippets = decoded

  local new_snippets = {}
  for _, snippet in ipairs(snippets) do
    if snippet.title ~= name then
      table.insert(new_snippets, snippet)
    end
  end

  local encoded = vim.fn.json_encode(new_snippets)

  vim.fn.writefile({ encoded }, filepath)
end

function M.ShowSnippets()
  local filepath = config.options.snippet_path

  if vim.fn.filereadable(filepath) == 0 then
    print("No snippets found.")
    return
  end

  local lines   = vim.fn.readfile(filepath)
  local decoded = vim.fn.json_decode(table.concat(lines, "\n"))
  if type(decoded) ~= "table" then
    print("Failed to parse snippets.json")
    return
  end
  local snippets = decoded

  pickers.new({}, {
    prompt_title = "Snippets",
    finder = finders.new_table {
      results = snippets,
      entry_maker = function(snippet)
        return {
          value   = snippet,
          display = snippet.title or "[No Title]",
          ordinal = snippet.title or "",
        }
      end,
    },
    sorter = conf.generic_sorter({}),

    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry)
        local content = entry.value.content or ""
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false,
          vim.split(content, "\n"))
        vim.bo[self.state.bufnr].filetype = entry.value.filetype or "text"
      end,
    }),

    attach_mappings = function(prompt_bufnr, map)
      local function insert_selected_snippet()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not entry then
          return
        end

        local to_insert = entry.value.content or ""
        vim.api.nvim_put(vim.split(to_insert, "\n"), 'l', true, true)
      end

      map("i", "<CR>", insert_selected_snippet)
      map("n", "<CR>", insert_selected_snippet)
      map("i", "<C-d>", function(prompt_bufnr)
        local entry = action_state.get_selected_entry()

        require("zsnip.core").DeleteSnippet(entry.value.title)

        actions.close(prompt_bufnr)
      end)
      return true
    end,
  }):find()
end

return M
