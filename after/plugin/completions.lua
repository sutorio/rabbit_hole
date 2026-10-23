-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- IDE setup: LSP functionality, completions, snippets, formatting etc.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local completion = require("mini.completion")
local snippets = require("mini.snippets")
local icons = require("mini.icons")
local helpers = require("sutorio.helpers")
-- }}}
-- =============================================================================
-- {{{ Nvim settings
-- =============================================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
-- }}}
-- =============================================================================
-- {{{ Snippets setup
snippets.setup({
  snippets = {
    -- Load custom file with global snippets first
    snippets.gen_loader.from_file("~/.config/nvim/snippets/global.json"),
    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    -- NOTE: plugins such as "friendly snippets" should make their snippet
    --       collections available on the "snippets/" runtime path.
    snippets.gen_loader.from_lang(),
  },
})
-- Loaded snippets aren't shown in the completion menu by default: this starts
-- a tiny LSP server that serves them to `mini.completion` as completion items.
-- `match = false` leaves the matching/sorting to the completion engine.
snippets.start_lsp_server({ match = false })
-- }}}
-- =============================================================================
-- {{{ Completions setup
-- =============================================================================
completion.setup({
  mappings = {
    -- Manually trigger the completion menu (this is the default, set here
    -- so it's explicit).
    force_twostep = "<C-Space>",
  },
})
icons.setup()
icons.tweak_lsp_kind()
-- }}}
-- =============================================================================
-- {{{ Completion keymaps
-- =============================================================================
-- `<C-n>`/`<C-p>` move through the menu (built in).
-- `<Tab>` accepts the highlighted item, or the first item if nothing has been
-- highlighted yet. Inside a snippet session it jumps to the next tabstop.
-- `<CR>` only confirms an item that has been explicitly highlighted, otherwise
-- it's a normal newline.
local function pmenu_has_selection()
  return vim.fn.complete_info({ "selected" }).selected ~= -1
end

helpers.kmap({
  ["<Tab>"] = {
    mode = "i",
    rhs = function()
      if snippets.session.get() then
        return '<Cmd>lua require("mini.snippets").session.jump("next")<CR>'
      end
      if vim.fn.pumvisible() == 1 then
        return pmenu_has_selection() and "<C-y>" or "<C-n><C-y>"
      end
      return "<Tab>"
    end,
    desc = "accept completion / next snippet tabstop",
    opts = { expr = true },
  },
  ["<S-Tab>"] = {
    mode = "i",
    rhs = function()
      if snippets.session.get() then
        return '<Cmd>lua require("mini.snippets").session.jump("prev")<CR>'
      end
      return "<S-Tab>"
    end,
    desc = "previous snippet tabstop",
    opts = { expr = true },
  },
  ["<CR>"] = {
    mode = "i",
    rhs = function()
      if vim.fn.pumvisible() == 1 and pmenu_has_selection() then
        return "<C-y>"
      end
      return "<CR>"
    end,
    desc = "confirm selected completion",
    opts = { expr = true },
  },
})
-- }}}
-- =============================================================================
