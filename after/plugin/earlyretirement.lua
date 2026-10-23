-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- Early Retirement settings
--
-- The plugin provides buffer auto-close functionality
--
-- For reference: https://github.com/chrisgrieser/nvim-early-retirement
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local early_retirement = require("early-retirement")
-- }}}
-- =============================================================================
-- {{{ Setup
-- =============================================================================
early_retirement.setup({
  retirementAgeMins = 10,
  deleteBufferWhenFileDeleted = true,
})
-- }}}
-- =============================================================================
