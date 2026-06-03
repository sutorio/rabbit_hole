-- vim:foldmethod=marker
-- =============================================================================
-- Colorizer settings
--
-- Colorizer will highlight anything it detects as a color declaration (eg hex
-- colours, CSS rgb colours, etc) in that colour.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local colorizer = require("colorizer")
local helpers = require("sutorio.helpers")
-- }}}
-- =============================================================================
-- {{{ Setup
-- =============================================================================
colorizer.setup({
  -- Specify filetypes to attach to. Can customise here per-filetype.
  -- NOTE: see defaults at https://github.com/catgoose/nvim-colorizer.lua#default-configuration
  filetypes = { "*" },
  options = {
    parsers = {
      css = true, -- preset: enables names, hex, rgb, hsl, oklch, css_var
      css_fn = true, -- preset: enables rgb, hsl, oklch
      hwb = { enable = true }, -- hwb() function (CSS Color Level 4)
      css_color = { enable = true }, -- color() function (srgb, display-p3, a98-rgb, etc.)
      xterm = { enable = true }, -- xterm 256-color codes (#xNN, \e[38;5;NNNm)
      hsluv = { enable = true }, -- hsluv()/hsluvu() functions
      css_var_rgb = { enable = true }, -- CSS vars with R,G,B (e.g. --color: 240,198,198)
    },
    display = {
      mode = "background", -- string or list: "background"|"foreground"|"underline"|"virtualtext"
    },
    always_update = true,
    debounce_ms = 200,
  },
})
-- }}}
-- =============================================================================
-- {{{ Mappings
-- =============================================================================
helpers.lmap({
  ["tc"] = {
    mode = "n",
    rhs = "<Cmd>ColorizerToggle<Cr>",
    desc = "toggle color highlights",
  },
})
-- }}}
-- =============================================================================
