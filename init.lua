-- General settings (NOT plugin-specific, put those in the relevant file in `<root>/after/`)
require("sutorio.settings")
-- General remaps (NOT plugin-specific, put those in the relevant file in `<root>/after/`)
require("sutorio.remaps")

vim.pack.add({
  -- 'Swiss army knife' of plugins, set of useful modules
  "https://github.com/nvim-mini/mini.nvim",
  -- QoL plugin collection
  "https://github.com/folke/snacks.nvim",
  -- Adds colour swatches to text recognised as a colour code,
  -- very useful for CSS in particular.
  "https://github.com/catgoose/nvim-colorizer.lua",
  -- Git integration for buffers.
  "https://github.com/lewis6991/gitsigns.nvim",
  -- Edit the filesystem like a buffer.
  "https://github.com/stevearc/oil.nvim",
  -- Pretty list UI for diagnostics, references, quickfix, etc.
  "https://github.com/folke/trouble.nvim",
  -- Builds syntax trees for source files. Canny important.
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  -- Additional treesitter parsers
  -- "https://github.com/nvim-orgmode/tree-sitter-org",
  -- "https://github.com/foxyseta/tree-sitter-prolog",
  -- "https://github.com/opa-oz/tree-sitter-robots-txt",
  -- Still useful even with built-in LSP functionality.
  "https://github.com/neovim/nvim-lspconfig",
  -- Mason is a manager for LSP servers/formatters/linters,
  -- has a nice UI for [un]installing, updating, etc.
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  -- Formatter plugin. This is used primarily because it defaults to LSP
  -- if no override is provided, makes it much easier to configure.
  "https://github.com/stevearc/conform.nvim",
  -- JSON (primarily) schema support: this is going to provide autocomplete
  -- support for a huge variety of config files.
  "https://github.com/b0o/schemastore.nvim",
  -- Show a nice popup with keybindings
  "https://github.com/folke/which-key.nvim",
  -- Snippet collections
  "https://github.com/rafamadriz/friendly-snippets",
  -- Close buffers automatically after a configured time
  "https://github.com/chrisgrieser/nvim-early-retirement",
})

-- Make sure Treesitter is kept up to date whenever the package changes
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})
