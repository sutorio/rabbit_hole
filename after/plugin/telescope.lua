-- vim:foldmethod=marker
-- =============================================================================
-- Telescope settings
--
-- For reference, see https://github.com/nvim-telescope/telescope.nvim
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local helpers = require("sutorio.helpers")
-- }}}
-- =============================================================================
-- {{{ Setup & extension loading
-- =============================================================================
telescope.setup({
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = false,
    },
  },
  extensions = {
    projects = {
      display_type = "full",
    },
  },
})

-- REVIEW: noice tends to fuck everything and I'm sick of it fucking everything
-- telescope.load_extension("noice")
telescope.load_extension("project")
-- }}}
-- =============================================================================
-- {{{ Keymaps
-- =============================================================================
helpers.lmap({
  ["fb"] = { mode = "n", rhs = builtin.buffers, desc = "open buffers" },
  ["fc"] = { mode = "n", rhs = builtin.commands, desc = "available commands" },
  ["fd"] = { mode = "n", rhs = builtin.diagnostics, desc = "diagnostics" },
  ["ff"] = { mode = "n", rhs = builtin.find_files, desc = "files in cwd" },
  ["fg"] = { mode = "n", rhs = builtin.live_grep, desc = "live grep in cwd" },
  ["fh"] = { mode = "n", rhs = builtin.help_tags, desc = "help tags" },
  ["fo"] = { mode = "n", rhs = builtin.oldfiles, desc = "recent files" },
  -- REVIEW: noice tends to fuck everything and I'm sick of it fucking everything
  -- ["fn"] = { mode = "n", rhs = function() require("noice").cmd("history") end, desc = "notification messages" },
  ["fp"] = {
    mode = "n",
    rhs = telescope.extensions.project.project,
    desc = "project picker",
  },
})
-- }}}
