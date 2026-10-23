-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- IDE setup: LSP functionality, completions, snippets, formatting etc.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local snacks = require("snacks")
local completion = require("mini.completion")
-- }}}
-- =============================================================================
-- {{{ Formatters
-- =============================================================================
-- `conform.nvim` provides the formatting infra.
-- NOTE: Conform is used simply because it's much easier to set up than anything
-- else with regards to defaulting back to the formatting implementation included
-- in the given LSP.
require("conform").setup({
  notify_on_error = false,
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt

    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = "never"
    else
      lsp_format_opt = "fallback"
    end

    return {
      timeout_ms = 500,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = {
      "oxfmt",
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    typescript = {
      "oxfmt",
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    typescriptreact = {
      "oxfmt",
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    rust = { "rustfmt" },
  },
})

vim.keymap.set("n", "<Leader>ef", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[e]diting: [f]ormat document" })

-- }}}
-- =============================================================================
-- {{{ LSP Setup
-- =============================================================================
-- NOTE: This is taken from https://github.com/nvim-lua/kickstart.nvim
--       including the following explanation:
--
-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
  capabilities = completion.get_lsp_capabilities(),
})

-- Server-specific overrides of the nvim-lspconfig defaults live in `after/lsp/`
-- (one `<server>.lua` file per server, returning a config table).

-- Holds the buffer-local reference-highlight autocmds (see the LspAttach
-- callback). Created up front so it always exists when LspDetach clears it,
-- even if no attached server supports document highlights.
local highlight_augroup =
  vim.api.nvim_create_augroup("LSP Highlight", { clear = true })

-- Clear reference highlights when an LSP detaches.
vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("LSP Detach", { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()
    vim.api.nvim_clear_autocmds({
      group = highlight_augroup,
      buffer = event.buf,
    })
  end,
})

--  This function gets run when an LSP attaches to a particular buffer.
--  That is to say, every time a new file is opened that is associated with
--  an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--  function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LSP Actions", { clear = true }),
  callback = function(event)
    -- NOTE: Neovim already maps `K` (hover), `grn` (rename), `gra` (code
    --       action), `grr`, `gri`, `grt`, `gO` and insert-mode `<C-s>`
    --       (signature help) by default, see `:help lsp-defaults`. The
    --       mappings here add to/override those.
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
    end
    map("gd", snacks.picker.lsp_definitions, "go to definition")
    map("gD", snacks.picker.lsp_declarations, "go to declaration")
    -- Overrides the built-in `grr` (quickfix list) with the picker. Not
    -- mapped to plain `gr`, since that would shadow the built-in `gr*` keys.
    map("grr", snacks.picker.lsp_references, "go to references")
    map("gI", snacks.picker.lsp_implementations, "go to implementation")
    map("gy", snacks.picker.lsp_type_definitions, "go to type definition")
    map("<F2>", vim.lsp.buf.rename, "rename symbol")
    map("<F4>", vim.lsp.buf.code_action, "show code actions")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
      client
      and client:supports_method(
        vim.lsp.protocol.Methods.textDocument_documentHighlight,
        event.buf
      )
    then
      -- Avoid stacking duplicate autocmds if several clients attach.
      vim.api.nvim_clear_autocmds({
        group = highlight_augroup,
        buffer = event.buf,
      })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if
      client
      and client:supports_method(
        vim.lsp.protocol.Methods.textDocument_inlayHint,
        event.buf
      )
    then
      map("<Leader>th", function()
        local filter = { bufnr = event.buf }
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled(filter),
          filter
        )
      end, "toggle inlay hints")
    end
  end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  -- NOTE: needs a Nerd Font (as do the `mini.icons` glyphs).
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
  },
})

-- Mason manages the language servers: every LSP server installed via `:Mason`
-- is enabled automatically (mason-lspconfig's `automatic_enable`, on by
-- default), using nvim-lspconfig's config plus any override in `after/lsp/`.
-- So to add or remove a language server, (un)install it in `:Mason`.
--
-- `ensure_installed` is just the baseline for a fresh install.
-- `mason-lspconfig` only knows about LSP servers: other tools (formatters,
-- linters) are listed in `tools` below and installed via the Mason registry.
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls", -- needed to work on this config
    "expert", -- Elixir
    "jsonls",
    "rust_analyzer",
    "ts_ls",
    "yamlls",
  },
})

local tools = {
  "stylua", -- Used to format Lua code
}
local registry = require("mason-registry")
-- `refresh` is async: it updates the package registry (if stale), then
-- installs any listed tool that's missing.
registry.refresh(function()
  for _, name in ipairs(tools) do
    local pkg = registry.get_package(name)
    if not pkg:is_installed() and not pkg:is_installing() then
      pkg:install()
    end
  end
end)
