-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- Key mappings and remappings that *dont* depend on a specific plugin.
-- =============================================================================
-- {{{ Commands to bind to leader mappings
-- =============================================================================
local usercmd = vim.api.nvim_create_user_command

usercmd("ToggleWordWrap", "set wrap!", {})

usercmd("ToggleColorColumn", function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "80"
  else
    vim.wo.colorcolumn = ""
  end
end, {})

usercmd("ToggleListChars", "set list!", {})
-- }}}
-- =============================================================================
-- {{{ Adjustments to existing builtin mappings
-- =============================================================================
-- Adjust the behaviour of `J` in normal mode: instead of moving the cursor to the join position, keep it where it is.
vim.keymap.set("n", "J", "mzJ`z")

-- Adjust behaviour of Ctrl-d/u (page up/down): keep cursor in same place on screen.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Adjust behaviour of search: keep focus (and cursor) in centre of screen when paging through results.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- }}}
-- =============================================================================
-- {{{ Non-leader mappings
-- =============================================================================
-- In visual mode, `J` will move the highlighted area *up*, `K` will move it *down*
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- }}}
-- =============================================================================
-- {{{ Leader mappings
-- =============================================================================
-- stylua: ignore start
-- -----------------------------------------------------------------------------
-- B is for buffer-related tasks
-- -----------------------------------------------------------------------------
-- "update" rather than "write"; "update" only updates if the file has changed;
-- "write" will update regardless (will act like 'touch' and update the timestamp).
vim.keymap.set("n", "<Leader>w", "<Cmd>update<Cr>", { desc = "save current file" })
-- -----------------------------------------------------------------------------
-- E is for text-editing-related tasks
-- -----------------------------------------------------------------------------
-- When you paste *over* other text, Vim replaces the buffer with the replaced text.
-- This is really annoying most of the time! So `<leader>p` will do what is expected (keep original text in-buffer).
vim.keymap.set("x", "<Leader>ep", [["_dP]], { desc = "paste but keep original text in buffer" })
-- Search based on the word under the cursor. Note that this seeds the search, can modify the search once the command is ran.
vim.keymap.set("n", "<Leader>es", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "start search based on word under cursor" })
vim.keymap.set({ "n", "v" }, "<Leader>ey", [["+y]], { desc = "yank to system clipboard" })
vim.keymap.set("n", "<Leader>eY", [["+Y]], { desc = "yank line to system clipboard" })
-- NOTE: this is crap - p is already taken & only got paste below & don't have
-- `<space>ep` behaviour &c. Have a think, may need some magic.
vim.keymap.set("n", "<Leader>ez", [["+p]], { desc = "paste from system clipboard" })
-- -----------------------------------------------------------------------------
-- Neovim-specific/inbuilt system-related tasks
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<Leader>ns", "<Cmd>so<Cr>", { desc = "source current file" })
vim.keymap.set("n", "<Leader>nx", "<Cmd>!chmod +x %<CR>", { desc = "chmod +x the current file", silent = true })
-- -----------------------------------------------------------------------------
-- Toggles
-- -----------------------------------------------------------------------------
vim.keymap.set("n", "<Leader>tb", "<Cmd>ToggleColorColumn<Cr>", { desc = "toggle colorcolumn", silent = true })
vim.keymap.set("n", "<Leader>tl", "<Cmd>ToggleListChars<Cr>", { desc = "toggle list chars", silent = true })
vim.keymap.set("n", "<Leader>tw", "<Cmd>ToggleWordWrap<Cr>", { desc = "toggle word wrap", silent = true })
-- stylua: ignore end

-- NOTE: quickfix/location list navigation uses the built-in `]q`/`[q` and
--       `]l`/`[l` (plus `]Q`/`[Q` etc for first/last), see `:help ]q`.
-- }}}
-- =============================================================================
