-- vim:foldmethod=marker
-- =============================================================================
-- Snacks settings
--
-- For reference, see https://github.com/folke/snacks.nvim
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local snacks = require("snacks")
local helpers = require("sutorio.helpers")
-- }}}
-- =============================================================================
-- {{{ Pickers
-- =============================================================================
snacks.picker.setup({
  enabled = true,
})

helpers.lmap({
  ["fb"] = { mode = "n", rhs = snacks.picker.buffers, desc = "open buffers" },
  ["fc"] = {
    mode = "n",
    rhs = snacks.picker.commands,
    desc = "available commands",
  },
  ["fd"] = { mode = "n", rhs = snacks.picker.diagnostics, desc = "diagnostics" },
  ["ff"] = { mode = "n", rhs = snacks.picker.files, desc = "files in cwd" },
  ["fg"] = { mode = "n", rhs = snacks.picker.grep, desc = "live grep" },
  ["fh"] = { mode = "n", rhs = snacks.picker.help, desc = "help tags" },
  ["fo"] = { mode = "n", rhs = snacks.picker.recent, desc = "recent files" },
  ["fp"] = {
    mode = "n",
    rhs = snacks.picker.projects,
    desc = "project picker",
  },
})
-- }}}
-- =============================================================================
-- {{{ Scratch buffers
-- =============================================================================
helpers.lmap({
  ["esn"] = {
    mode = "n",
    rhs = function()
      snacks.scratch()
    end,
    desc = "new scratch buffer",
  },
  ["ess"] = {
    mode = "n",
    rhs = function()
      snacks.scratch.select()
    end,
    desc = "select existing scratch buffer",
  },
})
-- }}}
