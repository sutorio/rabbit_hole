-- TODO: base mappings
require("which-key").setup({})
-- NOTE: using native keymaps. However, doing that prevents naming the
-- keymap groups: which-key just prints `+prefix`.
-- Therefore, names *only* are specified here.
require("which-key").add({
  { "<Leader>e", group = "Editing" },
  { "<Leader>es", group = "Scratch buffers" },
  { "<Leader>f", group = "Find" },
  { "<Leader>l", group = "LSP" },
  { "<Leader>lc", group = "LSP code actions" },
  { "<Leader>lg", group = "LSP goto" },
  { "<Leader>lw", group = "LSP workspace" },
  { "<Leader>n", group = "NVim-related" },
  { "<Leader>t", group = "Toggle" },
})
