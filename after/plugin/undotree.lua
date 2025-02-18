-- vim:foldmethod=marker
-- =============================================================================
-- Undotree settings
--
-- For reference, see https://github.com/mbbill/undotree
-- =============================================================================
local helpers = require("sutorio.helpers")

helpers.lmap({
  ["eu"] = {
    mode = "n",
    rhs = vim.cmd.UndotreeToggle,
    desc = "undotree toggle open/close",
  },
})
