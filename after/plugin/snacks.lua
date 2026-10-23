-- vim:foldmethod=marker
-- =============================================================================
-- Snacks settings
--
-- For reference, see https://github.com/folke/snacks.nvim
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local snacks = require("snacks")
-- }}}
-- =============================================================================
-- {{{ Pickers
-- =============================================================================
snacks.picker.setup({
  enabled = true,
})

-- stylua: ignore start
vim.keymap.set("n", "<Leader>fb", snacks.picker.buffers, { desc = "open buffers" })
vim.keymap.set("n", "<Leader>fc", snacks.picker.commands, { desc = "available commands" })
vim.keymap.set("n", "<Leader>fd", snacks.picker.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", "<Leader>ff", snacks.picker.files, { desc = "files in cwd" })
vim.keymap.set("n", "<Leader>fg", snacks.picker.grep, { desc = "live grep" })
vim.keymap.set("n", "<Leader>fh", snacks.picker.help, { desc = "help tags" })
vim.keymap.set("n", "<Leader>fo", snacks.picker.recent, { desc = "recent files" })
vim.keymap.set("n", "<Leader>fp", snacks.picker.projects, { desc = "project picker" })
-- stylua: ignore end
-- }}}
-- =============================================================================
-- {{{ Scratch buffers
-- =============================================================================
-- stylua: ignore start
vim.keymap.set("n", "<Leader>esn", function() snacks.scratch() end, { desc = "new scratch buffer" })
vim.keymap.set("n", "<Leader>ess", function() snacks.scratch.select() end, { desc = "select existing scratch buffer" })
-- stylua: ignore end
-- }}}
