-- vim:foldmethod=marker
-- =============================================================================
-- Vim Colour File
-- Name:       sutor_one.lua
-- Maintainer: https://github.com/DanCouper
-- License:    The MIT License (MIT)
-- Based On:   https://github.com/olivercederborg/poimandres.nvim
--             https://github.com/kyazdani42/nvim-palenight.lua/blob/master/lua/palenight.lua
-- =============================================================================
-- {{{ Colour palette + utils
-- =============================================================================
-- Set a highlight group from an entry in the big lua tables of groups below.
-- `gui` is a comma-separated attribute list, eg "bold" or "bold,italic".
local function highlight(group, styles)
  local attrs = { fg = styles.fg, bg = styles.bg, sp = styles.sp }
  for attr in (styles.gui or ""):gmatch("[^,]+") do
    if attr ~= "NONE" then
      attrs[attr] = true
    end
  end
  vim.api.nvim_set_hl(0, group, attrs)
end

-- Palette. aliased to "p", going to use it a lot.
local p = {
  yellow = "#FFFAC2",
  teal1 = "#5DE4C7",
  teal2 = "#5FB3A1",
  teal3 = "#42675A",
  blue1 = "#89DDFF",
  blue2 = "#ADD7FF",
  blue3 = "#91B4D5",
  blue4 = "#7390AA",
  pink1 = "#FAE4FC",
  pink2 = "#FCC5E9",
  pink3 = "#D0679D",
  purple1 = "#dad4f7",
  purple2 = "#B5A9EF",
  purple3 = "#8C7AE6",
  blueGray1 = "#A6ACCD",
  blueGray2 = "#767C9D",
  blueGray3 = "#506477",
  background1 = "#303340",
  background2 = "#1B1E28",
  background3 = "#171922",
  text = "#E4F0FB",
  white = "#FFFFFF",
  none = "NONE",
  -- highlight colours for grabbing visual attention
  attention_red = "#FF0000",
  attention_orange = "#FFA500",
  attention_yellow = "#FFFF00",
  attention_green = "#00FF00",
  attention_blue = "#0000FF",
  attention_purple = "#800080",
}

-- Semantic naming for palette colours.
local groups = {
  primary = p.teal3,

  background = p.background2,
  panel = p.background3,
  border = p.background3,
  comment = p.blueGray2,
  link = p.blue3,
  punctuation = p.blueGray2,

  error = p.pink3,
  hint = p.blue1,
  info = p.blue3,
  warn = p.yellow,
}
-- }}}
-- =============================================================================
-- Editor Highlight Groups {{{
-- =============================================================================
-- stylua: ignore start
local editor_syntax = {
    ColorColumn          = { bg = p.blueGray3 },
    CursorLine           = { bg = p.background1 },
    CursorLineNr         = { fg = p.text },
    Directory            = { fg = p.blue3, bg = p.none },
    ErrorMsg             = { fg = p.pink3, gui = "bold" },
    Folded               = { fg = p.text, bg = p.none, gui = "italic" },
    FoldColumn           = { fg = p.blueGray3 },
    IncSearch            = { fg = groups.background, bg = p.blue2 },
    LineNr               = { fg = p.blueGray3 },
    MatchParen           = { bg = p.blueGray3, fg = p.background3 },
    Normal               = { fg = p.text, bg = groups.background },
    NormalFloat          = { fg = p.text, bg = groups.panel },
    NormalNC             = { fg = p.text, bg = groups.panel },
    Pmenu                = { fg = p.blueGray1, bg = groups.panel },
    PmenuSbar            = { bg = p.blueGray2 },
    PmenuSel             = { fg = p.text, bg = p.background1 },
    PmenuThumb           = { bg = p.blueGray3 },
    RedrawDebugClear     = { fg = "#ffffff", bg = p.yellow },
    RedrawDebugComposed  = { fg = "#ffffff", bg = p.teal2 },
    RedrawDebugRecompose = { fg = "#ffffff", bg = p.pink3 },
    Search               = { fg = p.white, bg = p.blueGray3 },
    SignColumn           = { fg = p.text, bg = p.none },
    SpecialKey           = { fg = p.teal1 },
    SpellBad             = { gui = "underline", sp = p.pink3 },
    SpellCap             = { gui = "underline", sp = p.blue1 },
    SpellLocal           = { gui = "underline", sp = p.yellow },
    SpellRare            = { gui = "underline", sp = p.blue1 },
    TabLine              = { fg = p.blue3, bg = groups.panel },
    TabLineFill          = { bg = groups.panel },
    TabLineSel           = { fg = p.text, bg = p.background1, gui = 'bold' },
    Title                = { fg = p.text },
    VertSplit            = { fg = groups.border, bg = groups.border },
    Visual               = { fg = groups.background, bg = p.blue2 },
    VisualNOS            = { fg = p.text, bg = groups.border },
    WarningMsg           = { fg = p.yellow },
    Whitespace           = { fg = p.blueGray3 },

    Conceal              = {},
    ModeMsg              = { fg = p.blue3 },
    MsgArea              = {},
    MsgSeparator         = {},
    MoreMsg              = { fg = p.blue3 },
    NonText              = { fg = p.blueGray3 },
    Question             = { fg = p.yellow },
    QuickFixLine         = {},
    StatusLine           = { fg = p.blue3, bg = groups.panel },
    StatusLineNC         = { fg = p.blue3, bg = groups.background },
    StatusLineTerm       = { fg = p.blue3, bg = groups.panel },
    StatusLineTermNC     = { fg = p.blue3, bg = groups.background },
    WildMenu             = { fg = p.background3, bg = p.blue2 },
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- Default Vim Syntax Highlight Groups {{{
-- =============================================================================
-- These groups are not listed as default vim groups,
-- but they are defacto standard group names for syntax highlighting.
-- commented out groups should chain up to their "preferred" group by
-- default,

-- stylua: ignore start
local default_code_syntax = {
    Constant       = { fg = p.text },           -- (preferred) any constant
    String         = { fg = p.teal1 },          --   a string constant: "this is a string"
    Character      = { fg = p.pink3 },          --  a character constant: 'c', '\n'
    Number         = { fg = p.teal1 },          --   a number constant: 234, 0xff
    Boolean        = { fg = p.teal1 },          --  a boolean constant: TRUE, false
    Float          = { fg = p.teal1 },          --    a floating point constant: 2.3e10

    Identifier     = { fg = p.blueGray1 },      -- (preferred) any variable name
    Function       = { fg = p.teal1 },          -- function name (also: methods for classes)

    Statement      = { fg = p.text },           -- (preferred) any statement
    Conditional    = { fg = p.blue3 },          --  if, then, else, endif, switch, etc.
    Repeat         = { fg = p.blue3 },          --   for, do, while, etc.
    Label          = { fg = p.text },           --    case, default, etc.
    Operator       = { fg = p.blue2 },          -- "sizeof", "+", "*", etc.
    Keyword        = { fg = p.blue2 },          --  any other keyword
    Exception      = { fg = p.blue3 },          --  try, catch, throw

    PreProc        = { fg = p.text },           -- (preferred) generic Preprocessor

    Type           = { fg = p.blueGray1 },      -- (preferred) int, long, char, etc.
    Structure      = { fg = p.blueGray1 },      --  struct, union, enum, etc. ]]

    Special        = { fg = p.blueGray2 },       -- (preferred) any special symbol
    Tag            = { fg = p.text },            --    you can use CTRL-] on this
    Delimiter      = { fg = p.blueGray1 },       --  character that needs attention
    SpecialComment = { fg = p.blueGray1 },       -- special things inside a comment

    Comment        = { fg = p.blue3, gui = "italic" },       -- (preferred) any special symbol

    Underlined     = { gui = "underline" },                  -- (preferred) text that stands out, HTML links
    Bold           = { gui = "bold" },
    Italic         = { gui = "italic" },

    Error          = { fg = p.pink3 },                            -- (preferred) any erroneous construct
    Todo           = { bg = p.yellow, fg = p.background3 },       -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- Diagnostic Highlight Groups {{{
-- =============================================================================
local diagnostic_groups = {
  DiagnosticError = { fg = groups.error },
  DiagnosticHint = { fg = groups.hint },
  DiagnosticInfo = { fg = groups.info },
  DiagnosticWarn = { fg = groups.warn },
  DiagnosticFloatingError = { fg = groups.error },
  DiagnosticFloatingHint = { fg = groups.hint },
  DiagnosticFloatingInfo = { fg = groups.info },
  DiagnosticFloatingWarn = { fg = groups.warn },
  DiagnosticSignError = { fg = groups.error },
  DiagnosticSignHint = { fg = groups.hint },
  DiagnosticSignInfo = { fg = groups.info },
  DiagnosticSignWarn = { fg = groups.warn },
  DiagnosticUnderlineError = { sp = groups.error, gui = "undercurl" },
  DiagnosticUnderlineHint = { sp = groups.hint, gui = "undercurl" },
  DiagnosticUnderlineInfo = { sp = groups.info, gui = "undercurl" },
  DiagnosticUnderlineWarn = { sp = groups.warn, gui = "undercurl" },
  DiagnosticVirtualTextError = { fg = groups.error },
  DiagnosticVirtualTextHint = { fg = groups.hint },
  DiagnosticVirtualTextInfo = { fg = groups.info },
  DiagnosticVirtualTextWarn = { fg = groups.warn },
}
-- }}}
-- =============================================================================
-- Treesitter Syntax Highlight Groups {{{
-- =============================================================================
local treesitter_groups = {
  ["@boolean"] = default_code_syntax.Boolean,
  ["@comment"] = default_code_syntax.Comment,
  ["@keyword.conditional"] = default_code_syntax.Conditional,
  ["@constant.builtin"] = { fg = p.blue2 },
  ["@constructor"] = { fg = p.teal1 },
  ["@variable.member"] = { fg = p.text },
  ["@function"] = default_code_syntax.Function,
  ["@function.builtin"] = { fg = p.blue2 },
  ["@keyword.import"] = { fg = p.blue2 },
  ["@keyword"] = { fg = p.blue2 },
  ["@keyword.function"] = { fg = p.blue2 },
  ["@keyword.operator"] = { fg = p.teal1 },
  ["@label"] = { fg = p.blue3 },
  ["@function.method"] = { fg = p.teal1 },
  ["@number"] = default_code_syntax.Number,
  ["@operator"] = default_code_syntax.Operator,
  ["@variable.parameter"] = { fg = p.text },
  ["@property"] = { fg = p.text },
  ["@punctuation.bracket"] = { fg = groups.punctuation },
  ["@punctuation.delimiter"] = { fg = groups.punctuation },
  ["@punctuation.special"] = { fg = groups.punctuation },
  ["@string"] = default_code_syntax.String,
  ["@string.escape"] = { fg = p.pink3 },
  ["@tag"] = { fg = p.text },
  ["@tag.attribute"] = { fg = p.blue2, gui = "italic" },
  ["@tag.delimiter"] = { fg = p.text },
  ["@string.special.url"] = { fg = groups.link },
  ["@markup.heading"] = { fg = p.text, gui = "bold" },
  ["@type"] = default_code_syntax.Type,
  ["@type.builtin"] = default_code_syntax.Type,
  ["@keyword.modifier"] = default_code_syntax.Type,
  ["@type.definition"] = default_code_syntax.Type,
  ["@variable"] = { fg = p.text },
  ["@variable.builtin"] = { fg = p.blue2 },
}
-- }}}
-- =============================================================================
-- Treesitter Language-specific Syntax Highlight Groups {{{
-- =============================================================================
local treesitter_language_groups = {
  -- Make Elixir stuff Elixir-coloured!
  ["@number.float.elixir"] = { fg = p.purple3 },
  ["@function.elixir"] = { fg = p.purple2 },
  ["@function.call.elixir"] = { fg = p.purple2 },
  ["@keyword.operator.elixir"] = { fg = p.purple3 },
  ["@string.elixir"] = { fg = p.purple1 },
}
-- }}}
-- =============================================================================
-- LSP-specific Highlight Groups {{{
-- =============================================================================
local lsp_groups = {
  LspReferenceText = { fg = p.background2, bg = p.blue2 },
  LspReferenceRead = { fg = p.background2, bg = p.blue2 },
  LspReferenceWrite = { fg = p.background2, bg = p.blue2 },
}
-- }}}
-- =============================================================================
-- Gitsigns Highlight goups {{{
-- =============================================================================
local gitsigns_groups = {
  GitSignsAdd = { fg = p.teal3, bg = p.none, gui = "bold" },
  GitSignsAddNr = { fg = p.teal3, gui = "bold" },
  GitSignsChange = { fg = p.blue3, bg = p.none, gui = "bold" },
  GitSignsChangeNr = { fg = p.blue3, gui = "bold" },
  GitSignsDelete = { fg = p.pink3, bg = p.none, gui = "bold" },
  GitSignsDeleteNr = { fg = p.pink3, gui = "bold" },
}
-- }}}
-- =============================================================================
-- Which-key Highlight Groups {{{
-- =============================================================================
local which_key_groups = {
  WhichKey = { fg = p.text },
  WhichKeyGroup = { fg = p.text },
  WhichKeySeparator = { fg = p.text },
  WhichKeyDesc = { fg = p.text },
  WhichKeyFloat = { bg = groups.panel },
  WhichKeyValue = { fg = p.text },
}
-- }}}
-- =============================================================================
-- Mini.nvim Highlight Groups {{{
-- =============================================================================
local mini_groups = {
  -- mini.statusline
  MiniStatuslineModeNormal = { bg = p.blue2, fg = p.background3 },
  MiniStatuslineModeInsert = { bg = p.teal1, fg = p.background3 },
  MiniStatuslineModeVisual = { bg = p.purple1, fg = p.background3 },
  MiniStatuslineModeReplace = { bg = p.pink2, fg = p.background3 },
  MiniStatuslineModeCommand = { bg = p.pink3, fg = p.background3 },
  MiniStatuslineModeOther = { bg = p.yellow, fg = p.background3 },
  -- mini.hipatterns
  -- NOTE: these are *user-defined* in the mini.hipatterns setup function
  MiniHipatternsImportant = { bg = p.attention_red, fg = p.background3 },
  MiniHipatternsFixme = { bg = p.attention_orange, fg = p.background3 },
  MiniHipatternsTodo = { bg = p.attention_yellow, fg = p.background3 },
  MiniHipatternsReview = { bg = p.attention_purple, fg = p.white },
  MiniHipatternsHack = { bg = p.attention_blue, fg = p.white },
  MiniHipatternsNote = { bg = p.attention_green, fg = p.background3 },
}
-- }}}
-- =============================================================================
-- {{{ Apply
-- =============================================================================
for _, section in ipairs({
  editor_syntax,
  default_code_syntax,
  diagnostic_groups,
  treesitter_groups,
  treesitter_language_groups,
  lsp_groups,
  gitsigns_groups,
  which_key_groups,
  mini_groups,
}) do
  for group, styles in pairs(section) do
    highlight(group, styles)
  end
end
-- }}}
-- =============================================================================
