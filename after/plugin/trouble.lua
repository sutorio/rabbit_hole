-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- Trouble settings
--
-- List UI for diagnostics, LSP references/symbols, quickfix etc. Provides the
-- `:Trouble` command, eg `:Trouble diagnostics toggle`.
--
-- For reference: https://github.com/folke/trouble.nvim
-- =============================================================================
-- {{{ Setup
-- =============================================================================
require("trouble").setup()
-- }}}
-- =============================================================================
-- {{{ Keymaps
-- =============================================================================
-- stylua: ignore start
vim.keymap.set("n", "<Leader>xx", "<Cmd>Trouble diagnostics toggle<Cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<Leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<Cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<Leader>xs", "<Cmd>Trouble symbols toggle focus=false<Cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<Leader>xl", "<Cmd>Trouble lsp toggle focus=false win.position=right<Cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<Leader>xL", "<Cmd>Trouble loclist toggle<Cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<Leader>xQ", "<Cmd>Trouble qflist toggle<Cr>", { desc = "Quickfix List (Trouble)" })
-- stylua: ignore end
-- }}}
-- =============================================================================
