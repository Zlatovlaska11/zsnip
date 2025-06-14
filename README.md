# Zlatovlas Snippets (zsnip)

💡 A minimal Neovim plugin for saving and browsing custom code snippets using Telescope.

## Features

- 📌 Save visual selections as code snippets
- 🔍 Browse saved snippets via Telescope
- 📂 Stores snippets in a JSON file (`~/.local/share/nvim/zsnip/snippets.json`)
- 🔎 Preview full snippet content in Telescope
- 🧠 Automatically detects filetype when saving

## Installation

Use your favorite plugin manager. For example, with `lazy.nvim`:

```lua
{
  "Zlatovlaska11/zsnip",
  config = function()
    require("zsnip").setup({
        -- the default location is in ~/.local/share/nvim/zsnip/snippets.json
        -- if you would like the override the path there is the snippet_path opt
        -- snippet_path = "/home/yourname/.config/nvim/snippets.json"
    })
  end,
}
```
## Usage

### Commands
```vim
:SnippetSave — Save a selected snippet (in visual mode)

:SnippetShow — Show saved snippets in a Telescope picker
```
### Keymaps

You can add this to your config to save snippets easily:

```lua 
vim.keymap.set("v", "<leader>ss", ":SnippetSave<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>zs", ":SnippetShow<CR>", { noremap = true, silent = true })
```


