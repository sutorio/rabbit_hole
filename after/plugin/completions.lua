-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- IDE setup: LSP functionality, completions, snippets, formatting etc.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local sutorio_helpers = require("sutorio.helpers")
-- }}}
-- =============================================================================
-- {{{ Nvim settings
-- =============================================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
-- }}}
-- =============================================================================
-- {{{ Completions setup
-- =============================================================================
cmp.setup({
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    -- Enter key confirms completion item
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- Ctrl + space triggers completion menu
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      max_width = 50,
      symbol_map = { Copilot = "" },
    }),
  },
})

-- SQL completions need special handling, using TPope's "dadbod" vim plugin.
-- TODO: wrap this in an error handler in case dadbod isn't available
cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})
-- }}}
-- =============================================================================
-- {{{ Snippets setup
luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged, TextChangedI",
  enable_autosnippets = true,
})
-- For VSCode-style snippets, they need to live in a directory on the
-- runtime path, with a package.json manifest. So this is not, strictly
-- speaking, necessary (LuaSnip will locate the VSCode-style snippets by
-- default). But it allows other loaders to be added that point to this
-- directory without much fuss.
-- Why VSCode style snippets? Because I can reuse them in VSCode
local snippets_fpath =
  sutorio_helpers.path_join(vim.fn.stdpath("config"), "snippets")

require("luasnip.loaders.from_vscode").load({ paths = snippets_fpath })

-- }}}
-- =============================================================================
-- {{{ Copilot setup
-- =============================================================================
-- TODO: tweak this. In particular, I want copilot to start/stop on-demand.
--       The server takes a while to start, so just setting up straightaway
--       is gonna make NVim hang to fuck.
--       See: https://github.com/zbirenbaum/copilot.lua
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
-- }}}
-- =============================================================================
