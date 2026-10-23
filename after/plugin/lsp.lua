-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- IDE setup: LSP functionality, completions, snippets, formatting etc.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local helpers = require("sutorio.helpers")
local snacks = require("snacks")
local completion = require("mini.completion")
-- }}}
-- =============================================================================
-- {{{ LSP server custom rules (overrides defaults)
-- =============================================================================
local servers = {
  bashls = {},
  cssls = {},
  -- NOTE: `erlangls` has been dropped from nvim-lspconfig, ELP is the replacement
  elp = {},
  expert = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          enable = true,
          -- REVIEW: this is to suppress the "missing parameters" warning that
          --         often crops up for `setup` options for plugins in particular.
          --         This is not necessarily a good idea: the warning is caused
          --         by plugins {mis|over}specifying the types for option tables.
          --         **IT MAY CAUSE FALSE NEGATIVES, WHEN I HAVE MADE AN ERROR**
          disable = { "missing-parameters", "missing-fields" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files.
          -- NOTE: only `$VIMRUNTIME`: passing the whole runtimepath (i.e. every
          --       plugin) makes the workspace take ~30s to load, during which
          --       lua_ls returns no completions at all.
          library = { vim.env.VIMRUNTIME },
          maxPreload = 10000,
          preloadFileSize = 10000,
          checkThirdParty = false,
        },
      },
    },
  },
  rust_analyzer = {},
  tailwindcss = {},
  ts_ls = {
    -- Only attach inside a JS/TS project. Not calling `on_dir` means the server
    -- doesn't start (the replacement for `single_file_support = false`).
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, {
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
      })
      if root then
        on_dir(root)
      end
    end,
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
}

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

helpers.lmap({
  ["ef"] = {
    mode = "n",
    rhs = function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end,
    desc = "[e]diting: [f]ormat document",
  },
})

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

-- Apply the server-specific overrides on top of the nvim-lspconfig defaults.
for server_name, server in pairs(servers) do
  vim.lsp.config(server_name, server)
end

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
    helpers.kmap({
      ["gd"] = {
        mode = "n",
        rhs = snacks.picker.lsp_definitions,
        desc = "go to definition",
        opts = { buffer = event.buf },
      },
      ["gD"] = {
        mode = "n",
        rhs = snacks.picker.lsp_declarations,
        desc = "go to declaration",
        opts = { buffer = event.buf },
      },
      -- Overrides the built-in `grr` (quickfix list) with the picker. Not
      -- mapped to plain `gr`, since that would shadow the built-in `gr*` keys.
      ["grr"] = {
        mode = "n",
        rhs = snacks.picker.lsp_references,
        desc = "go to references",
        opts = { buffer = event.buf },
      },
      ["gI"] = {
        mode = "n",
        rhs = snacks.picker.lsp_implementations,
        desc = "go to implementation",
        opts = { buffer = event.buf },
      },
      ["gy"] = {
        mode = "n",
        rhs = snacks.picker.lsp_type_definitions,
        desc = "go to type definition",
        opts = { buffer = event.buf },
      },
      ["<F2>"] = {
        mode = "n",
        rhs = vim.lsp.buf.rename,
        desc = "rename symbol",
        opts = { buffer = event.buf },
      },
      ["<F4>"] = {
        mode = "n",
        rhs = vim.lsp.buf.code_action,
        desc = "show code actions",
        opts = { buffer = event.buf },
      },
    })

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
      helpers.lmap({
        ["th"] = {
          mode = "n",
          rhs = function()
            local filter = { bufnr = event.buf }
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled(filter),
              filter
            )
          end,
          desc = "toggle inlay hints",
          opts = { buffer = event.buf },
        },
      })
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

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
--
-- `mason-lspconfig` only knows about LSP servers: other tools (formatters,
-- linters) are listed in `tools` below and installed via the Mason registry.
--
-- NOTE: `mason-lspconfig` v2 no longer has `handlers`: the server configs are
-- registered above via `vim.lsp.config`, and `automatic_enable` (on by default)
-- calls `vim.lsp.enable` for every installed server.
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
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
