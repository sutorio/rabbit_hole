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
require("sutorio.helpers").lmap({
  ["xx"] = {
    mode = "n",
    rhs = "<Cmd>Trouble diagnostics toggle<Cr>",
    desc = "Diagnostics (Trouble)",
  },
  ["xX"] = {
    mode = "n",
    rhs = "<Cmd>Trouble diagnostics toggle filter.buf=0<Cr>",
    desc = "Buffer Diagnostics (Trouble)",
  },
  ["xs"] = {
    mode = "n",
    rhs = "<Cmd>Trouble symbols toggle focus=false<Cr>",
    desc = "Symbols (Trouble)",
  },
  ["xl"] = {
    mode = "n",
    rhs = "<Cmd>Trouble lsp toggle focus=false win.position=right<Cr>",
    desc = "LSP Definitions / references / ... (Trouble)",
  },
  ["xL"] = {
    mode = "n",
    rhs = "<Cmd>Trouble loclist toggle<Cr>",
    desc = "Location List (Trouble)",
  },
  ["xQ"] = {
    mode = "n",
    rhs = "<Cmd>Trouble qflist toggle<Cr>",
    desc = "Quickfix List (Trouble)",
  },
})
-- }}}
-- =============================================================================
