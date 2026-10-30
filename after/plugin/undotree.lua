-- vim:foldmethod=marker
-- =============================================================================
-- Undotree settings
--
-- Uses Neovim's built-in undotree plugin (0.12+), which isn't loaded by
-- default. For reference, see `:help package-undotree`.
-- =============================================================================
-- {{{ Setup
-- =============================================================================
vim.cmd.packadd("nvim.undotree")
-- }}}
-- =============================================================================
-- {{{ Mappings
-- =============================================================================
-- `:Undotree` toggles: it closes the window if it's already open.
vim.keymap.set(
  "n",
  "<Leader>eu",
  vim.cmd.Undotree,
  { desc = "undotree toggle open/close" }
)
-- }}}
-- =============================================================================
