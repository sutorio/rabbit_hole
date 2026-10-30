-- vim:foldmethod=marker
-- =============================================================================
-- Vim Colour File
-- Name:       sutor_dark_fusion.lua
-- Maintainer: https://github.com/DanCouper
-- License:    The MIT License (MIT)
-- Ported From: https://github.com/MaxGraey/atom-dark-fusion-syntax
--              (MIT, Copyright (c) 2015 Maxim Shaydo)
--
-- The Atom theme only styles syntax plus a few editor details (gutter,
-- selection, guides). The rest of the UI (menus, statusline, diagnostics,
-- diffs) is derived from the same palette.
-- =============================================================================
-- {{{ Setup
-- =============================================================================
vim.cmd.highlight("clear")
vim.g.colors_name = "sutor_dark_fusion"
vim.o.background = "dark"
-- }}}
-- =============================================================================
-- {{{ Colour palette
-- =============================================================================
-- Values from the theme's `colors.less`/`syntax-variables.less`, with the LESS
-- colour functions (mix, lighten, spin...) resolved to plain hex.
local p = {
  white = "#DEE2E3",
  very_light_gray = "#BCC7D2", -- main text
  light_gray = "#7C8591", -- comments
  dark_gray = "#505662", -- guides
  gray = "#3D424B", -- invisible characters
  very_dark_gray = "#2F3542", -- background

  cyan = "#44C0C6", -- also the theme's "blue" and "purple"
  orange = "#FC8458",
  light_orange = "#D1BC92",
  green = "#CAE359",
  red = "#C65353",
  dark_red = "#AC3939",

  selection = "#444B58",
  gutter_bg = "#2A303D",
  gutter_text = "#61697B",
  gutter_text_selected = "#798296",
  tag_punctuation = "#1F8799",

  -- Derived for Neovim UI (not in the Atom theme): palette colours blended
  -- into the background.
  cursorline = "#373E4B",
  search = "#59616D",
  diff_add_bg = "#4B5446",
  diff_change_bg = "#483E45",
  diff_text_bg = "#684B48",
  diff_delete_bg = "#4D3B45",
}
-- }}}
-- =============================================================================
-- {{{ Editor highlight groups
-- =============================================================================
-- stylua: ignore start
local editor = {
  Normal       = { fg = p.very_light_gray, bg = p.very_dark_gray },
  NormalFloat  = { fg = p.very_light_gray, bg = p.gutter_bg },
  FloatBorder  = { fg = p.dark_gray, bg = p.gutter_bg },
  FloatTitle   = { fg = p.white, bg = p.gutter_bg, bold = true },
  Cursor       = { fg = p.very_dark_gray, bg = p.white },
  CursorLine   = { bg = p.cursorline },
  CursorColumn = { bg = p.cursorline },
  ColorColumn  = { bg = p.gray },
  Visual       = { bg = p.selection },
  Search       = { fg = p.white, bg = p.search },
  IncSearch    = { fg = p.very_dark_gray, bg = p.light_orange },
  CurSearch    = { link = "IncSearch" },
  Substitute   = { fg = p.very_dark_gray, bg = p.orange },
  MatchParen   = { fg = p.white, bg = p.dark_gray, bold = true },

  LineNr       = { fg = p.gutter_text, bg = p.gutter_bg },
  CursorLineNr = { fg = p.gutter_text_selected, bg = p.very_dark_gray },
  SignColumn   = { bg = p.gutter_bg },
  FoldColumn   = { fg = p.light_gray, bg = p.gutter_bg },
  Folded       = { fg = p.light_gray, bg = p.gutter_bg, italic = true },

  Whitespace   = { fg = p.gray },
  NonText      = { fg = p.gray },
  SpecialKey   = { fg = p.gray },
  EndOfBuffer  = { fg = p.very_dark_gray },
  Conceal      = { fg = p.light_gray },

  Pmenu        = { fg = p.very_light_gray, bg = p.gutter_bg },
  PmenuSel     = { fg = p.white, bg = p.selection },
  PmenuSbar    = { bg = p.gray },
  PmenuThumb   = { bg = p.light_gray },
  PmenuMatch   = { fg = p.cyan, bold = true },
  WildMenu     = { link = "PmenuSel" },

  StatusLine   = { fg = p.very_light_gray, bg = p.gray },
  StatusLineNC = { fg = p.light_gray, bg = p.gutter_bg },
  WinSeparator = { fg = p.gray },
  TabLine      = { fg = p.light_gray, bg = p.gutter_bg },
  TabLineFill  = { bg = p.gutter_bg },
  TabLineSel   = { fg = p.white, bg = p.very_dark_gray, bold = true },
  WinBar       = { fg = p.very_light_gray },
  WinBarNC     = { fg = p.light_gray },

  Directory    = { fg = p.cyan },
  Title        = { fg = p.orange, bold = true },
  ErrorMsg     = { fg = p.red, bold = true },
  WarningMsg   = { fg = p.orange },
  ModeMsg      = { fg = p.cyan },
  MoreMsg      = { fg = p.cyan },
  Question     = { fg = p.light_orange },
  QuickFixLine = { bg = p.selection },

  SpellBad     = { sp = p.red, undercurl = true },
  SpellCap     = { sp = p.cyan, undercurl = true },
  SpellLocal   = { sp = p.light_orange, undercurl = true },
  SpellRare    = { sp = p.orange, undercurl = true },

  -- Git/diff colours, from the theme's gutter colours.
  Added        = { fg = p.green },
  Changed      = { fg = p.orange },
  Removed      = { fg = p.red },
  DiffAdd      = { bg = p.diff_add_bg },
  DiffChange   = { bg = p.diff_change_bg },
  DiffText     = { bg = p.diff_text_bg },
  DiffDelete   = { fg = p.red, bg = p.diff_delete_bg },
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- {{{ Default Vim syntax groups
-- =============================================================================
-- Treesitter groups that aren't set below fall back to these.
-- stylua: ignore start
local syntax = {
  Comment        = { fg = p.light_gray, italic = true },

  Constant       = { fg = p.orange },
  String         = { fg = p.orange },
  Character      = { fg = p.orange },
  Number         = { fg = p.light_orange },
  Float          = { fg = p.light_orange },
  Boolean        = { fg = p.orange },

  Identifier     = { fg = p.very_light_gray },
  Function       = { fg = p.white },

  Statement      = { fg = p.cyan },
  Keyword        = { fg = p.cyan },
  Conditional    = { fg = p.cyan },
  Repeat         = { fg = p.cyan },
  Label          = { fg = p.cyan },
  Exception      = { fg = p.cyan },
  Operator       = { fg = p.light_orange },

  PreProc        = { fg = p.cyan },
  Include        = { fg = p.cyan },

  Type           = { fg = p.light_orange },
  StorageClass   = { fg = p.cyan },
  Structure      = { fg = p.light_orange },

  Special        = { fg = p.cyan },
  SpecialChar    = { fg = p.cyan },
  Tag            = { fg = p.cyan },
  Delimiter      = { fg = p.very_light_gray },
  SpecialComment = { fg = p.light_gray, bold = true },

  Underlined     = { underline = true },
  Bold           = { bold = true },
  Italic         = { italic = true },
  Error          = { fg = p.very_dark_gray, bg = p.red },
  Todo           = { fg = p.very_dark_gray, bg = p.light_orange, bold = true },
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- {{{ Treesitter groups
-- =============================================================================
-- Mapped from the theme's TextMate scopes (`common.less` and the per-language
-- files) to nvim-treesitter's capture names.
-- stylua: ignore start
local treesitter = {
  ["@comment"]               = { link = "Comment" },

  ["@variable"]              = { fg = p.very_light_gray },
  ["@variable.builtin"]      = { fg = p.cyan },          -- this, super, self
  ["@variable.parameter"]    = { fg = p.light_orange },
  ["@variable.member"]       = { fg = p.very_light_gray },
  ["@property"]              = { fg = p.very_light_gray },

  ["@constant"]              = { fg = p.light_orange },  -- variable.other.constant
  ["@constant.builtin"]      = { fg = p.orange },        -- true, null, undefined
  ["@module"]                = { fg = p.light_orange },
  ["@label"]                 = { fg = p.cyan },

  ["@string"]                = { fg = p.orange },
  ["@string.regexp"]         = { fg = p.orange },
  ["@string.escape"]         = { fg = p.cyan },
  ["@string.special.symbol"] = { fg = p.orange },
  ["@string.special.url"]    = { fg = p.orange, underline = true },
  ["@character"]             = { fg = p.orange },
  ["@number"]                = { fg = p.light_orange },
  ["@number.float"]          = { fg = p.light_orange },
  ["@boolean"]               = { fg = p.orange },

  ["@type"]                  = { fg = p.light_orange },
  ["@type.builtin"]          = { fg = p.cyan },          -- storage.type
  ["@attribute"]             = { fg = p.cyan },          -- decorators

  ["@function"]              = { fg = p.white },
  ["@function.call"]         = { fg = p.white },
  ["@function.method"]       = { fg = p.white },
  ["@function.method.call"]  = { fg = p.white },
  ["@function.builtin"]      = { fg = p.light_orange },  -- support.function
  ["@constructor"]           = { fg = p.light_orange },

  ["@keyword"]               = { fg = p.cyan },
  ["@keyword.operator"]      = { fg = p.light_orange },
  ["@operator"]              = { fg = p.light_orange },

  ["@punctuation.bracket"]   = { fg = p.very_light_gray },
  ["@punctuation.delimiter"] = { fg = p.light_orange },  -- terminators, key-value
  ["@punctuation.special"]   = { fg = p.dark_red },      -- embedded sections, eg `${}`

  ["@tag"]                   = { fg = p.cyan },
  ["@tag.builtin"]           = { fg = p.cyan },
  ["@tag.attribute"]         = { fg = p.light_orange },
  ["@tag.delimiter"]         = { fg = p.tag_punctuation },

  ["@markup.heading"]        = { fg = p.orange, bold = true },
  ["@markup.strong"]         = { fg = p.orange, bold = true },
  ["@markup.italic"]         = { fg = p.cyan, italic = true },
  ["@markup.strikethrough"]  = { strikethrough = true },
  ["@markup.quote"]          = { fg = p.orange },
  ["@markup.list"]           = { fg = p.red },
  ["@markup.raw"]            = { fg = p.green },
  ["@markup.link"]           = { fg = p.orange },
  ["@markup.link.label"]     = { fg = p.red },
  ["@markup.link.url"]       = { fg = p.orange, underline = true },

  ["@diff.plus"]             = { link = "Added" },
  ["@diff.minus"]            = { link = "Removed" },
  ["@diff.delta"]            = { link = "Changed" },

  -- CSS: selectors are cyan/light orange, property names plain, values orange.
  ["@property.css"]          = { fg = p.very_light_gray },
  ["@string.css"]            = { fg = p.orange },
  ["@type.css"]              = { fg = p.light_orange },  -- class/id selectors
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- {{{ Diagnostic and LSP groups
-- =============================================================================
-- stylua: ignore start
local diagnostics = {
  DiagnosticError            = { fg = p.red },
  DiagnosticWarn             = { fg = p.orange },
  DiagnosticInfo             = { fg = p.cyan },
  DiagnosticHint             = { fg = p.light_orange },
  DiagnosticOk               = { fg = p.green },
  DiagnosticUnderlineError   = { sp = p.red, undercurl = true },
  DiagnosticUnderlineWarn    = { sp = p.orange, undercurl = true },
  DiagnosticUnderlineInfo    = { sp = p.cyan, undercurl = true },
  DiagnosticUnderlineHint    = { sp = p.light_orange, undercurl = true },
  DiagnosticUnderlineOk      = { sp = p.green, undercurl = true },
  DiagnosticUnnecessary      = { fg = p.light_gray },

  LspReferenceText           = { bg = p.selection },
  LspReferenceRead           = { bg = p.selection },
  LspReferenceWrite          = { bg = p.selection, underline = true },
  LspInlayHint               = { fg = p.gutter_text, italic = true },
  LspCodeLens                = { fg = p.gutter_text },
  LspSignatureActiveParameter = { fg = p.light_orange, bold = true },
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- {{{ Plugin groups
-- =============================================================================
-- stylua: ignore start
local plugins = {
  -- mini.statusline
  MiniStatuslineModeNormal  = { fg = p.very_dark_gray, bg = p.cyan, bold = true },
  MiniStatuslineModeInsert  = { fg = p.very_dark_gray, bg = p.green, bold = true },
  MiniStatuslineModeVisual  = { fg = p.very_dark_gray, bg = p.orange, bold = true },
  MiniStatuslineModeReplace = { fg = p.very_dark_gray, bg = p.red, bold = true },
  MiniStatuslineModeCommand = { fg = p.very_dark_gray, bg = p.light_orange, bold = true },
  MiniStatuslineModeOther   = { fg = p.very_dark_gray, bg = p.light_gray, bold = true },
  MiniStatuslineDevinfo     = { fg = p.very_light_gray, bg = p.selection },
  MiniStatuslineFilename    = { fg = p.light_gray, bg = p.gutter_bg },
  MiniStatuslineFileinfo    = { fg = p.very_light_gray, bg = p.selection },
  -- mini.hipatterns
  -- NOTE: these are *user-defined* in the mini.hipatterns setup function
  MiniHipatternsImportant   = { fg = p.very_dark_gray, bg = p.red, bold = true },
  MiniHipatternsFixme       = { fg = p.very_dark_gray, bg = p.orange, bold = true },
  MiniHipatternsTodo        = { fg = p.very_dark_gray, bg = p.light_orange, bold = true },
  MiniHipatternsReview      = { fg = p.very_dark_gray, bg = p.cyan, bold = true },
  MiniHipatternsHack        = { fg = p.very_dark_gray, bg = p.dark_red, bold = true },
  MiniHipatternsNote        = { fg = p.very_dark_gray, bg = p.green, bold = true },
  -- gitsigns
  GitSignsAdd               = { fg = p.green, bg = p.gutter_bg },
  GitSignsChange            = { fg = p.orange, bg = p.gutter_bg },
  GitSignsDelete            = { fg = p.red, bg = p.gutter_bg },
}
-- stylua: ignore end
-- }}}
-- =============================================================================
-- {{{ Apply
-- =============================================================================
for _, section in ipairs({ editor, syntax, treesitter, diagnostics, plugins }) do
  for group, attrs in pairs(section) do
    vim.api.nvim_set_hl(0, group, attrs)
  end
end
-- }}}
-- =============================================================================
