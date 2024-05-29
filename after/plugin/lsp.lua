-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- IDE setup: LSP functionality, completions, snippets, formatting etc.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
-- }}}
-- =============================================================================
-- {{{ LSP server custom rules (overrides defaults)
-- =============================================================================
local servers = {
  bashls = {},
  cssls = {},
  denols = {
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  },
  emmet_ls = {
    -- The Emmet language server requires hints re. which extensions it
    -- should provide completions for. I only care about HTML/HTML templating
    filetypes = { "html", "heex", "eex", "njk", "astro" },
  },
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
          -- The Lua language server is being used for Neovim stuff,
          -- globals listed relate to Neovim development.
          globals = { "vim" },
          -- REVIEW: this is to suppress the "missing parameters" warning that
          --         often crops up for `setup` options for plugins in particular.
          --         This is not necessarily a good idea: the warning is caused
          --         by plugins {mis|over}specifying the types for option tables.
          --         **IT MAY CAUSE FALSE NEGATIVES, WHEN I HAVE MADE AN ERROR**
          disable = { "missing-parameters", "missing-fields" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          maxPreload = 10000,
          preloadFileSize = 10000,
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
  rust_analyzer = {},
  tailwindcss = {
    root_dir = lspconfig.util.root_pattern("tailwind.config.[mc]?js"),
    settings = {
      tailwindCSS = {
        experimental = {
          -- class variance authority support: see https://cva.style/docs/getting-started/installation
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
    -- Probably want to disable formatting for this lang server
    tsserver = {
      root_dir = lspconfig.util.root_pattern(
        "package.json",
        "tsconfig.json",
        "jsconfig.json"
      ),
      single_file_support = false,
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
  formatters_by_ft = {
    lua = { "stylua" },
    ruby = { "rubyfmt" },
  },
})

local InitFormatting = function()
  local callback = function(args)
    require("conform").format({
      bufnr = args.buf,
      lsp_fallback = true,
      quiet = true,
    })
  end

  vim.api.nvim_create_autocmd("BufWritePre", { callback = callback })

  vim.keymap.set("n", "<leader>ef", callback, { desc = "format document" })
end
-- }}}
-- =============================================================================
-- {{{ Linters
-- =============================================================================
-- local lint = require("lint")
--
-- lint.linters_by_ft = {
--   javascript = { "eslint" },
--   javascriptreact = { "eslint" },
--   ["javascript.jsx"] = { "eslint" },
--   typescript = { "eslint" },
--   typescriptreact = { "eslint" },
--   ["typescript.tsx"] = { "eslint" },
-- }

-- }}}
-- =============================================================================
-- =============================================================================
-- {{{ LSP: config functions
-- =============================================================================
local InitDiagnosticsUi = function()
  local diagnosticsIcons = {
    Error = "",
    Hint = "",
    Information = "",
    Question = "",
    Warning = "",
  }

  -- LSP handlers configuration
  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },

    diagnostic = {
      -- virtual_text = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = false,
      signs = {
        active = {
          {
            texthl = "DiagnosticSignError",
            text = diagnosticsIcons.Error,
            numhl = "DiagnosticSignError",
          },
          {
            texthl = "DiagnosticSignWarn",
            text = diagnosticsIcons.Warning,
            numhl = "DiagnosticSignWarn",
          },
          {
            texthl = "DiagnosticSignHint",
            text = diagnosticsIcons.Hint,
            numhl = "DiagnosticSignHint",
          },
          {
            texthl = "DiagnosticSignInfo",
            text = diagnosticsIcons.Info,
            numhl = "DiagnosticSignInfo",
          },
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    },
  }

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end,
    desc = "Open a diagnostic popup under the cursor",
  })

  vim.diagnostic.config(config.diagnostic)
  -- REVIEW: this was being handled by noice.nvim
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, config.float)
  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

local InitLinting = function()
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end
-- }}}
-- =============================================================================
-- {{{ LSP: finalise setup
-- =============================================================================

InitDiagnosticsUi()

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local buffer = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- stylua: ignore start
    vim.keymap.set("n", "K",    vim.lsp.buf.hover,           { buffer = buffer, desc = "hover info" })
    vim.keymap.set("n", "gd",   vim.lsp.buf.definition,      { buffer = buffer, desc = "go to definition" })
    vim.keymap.set("n", "gD",   vim.lsp.buf.declaration,     { buffer = buffer, desc = "go to declaration" })
    vim.keymap.set("n", "gi",   vim.lsp.buf.implementation,  { buffer = buffer, desc = "go to implementation" })
    vim.keymap.set("n", "go",   vim.lsp.buf.type_definition, { buffer = buffer, desc = "go to type definition" })
    vim.keymap.set("n", "gr",   vim.lsp.buf.references,      { buffer = buffer, desc = "show references" })
    vim.keymap.set("n", "gs",   vim.lsp.buf.signature_help,  { buffer = buffer, desc = "show signature help" })
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename,          { buffer = buffer, desc = "rename symbol" })
    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action,     { buffer = buffer, desc = "show code actions" })
    vim.keymap.set("n", "gl",   vim.diagnostic.open_float,   { buffer = buffer, desc = "open float" })
    vim.keymap.set("n", "[d",   vim.diagnostic.goto_prev,    { buffer = buffer, desc = "go to next" })
    vim.keymap.set("n", "]d",   vim.diagnostic.goto_next,    { buffer = buffer, desc = "go to previous" })
    -- stylua: ignore end

    InitFormatting()
    InitLinting()
  end,
})

local default_setup = function(server)
  lspconfig[server].setup({})
end

local mason_config = { ensure_installed = {}, handlers = { default_setup } }

for name, config in pairs(servers) do
  table.insert(mason_config.ensure_installed, name)
  mason_config.handlers[name] = function()
    lspconfig[name].setup(config)
  end
end

require("mason").setup({})
require("mason-lspconfig").setup(mason_config)

InitLinting()
InitFormatting()
-- }}}
-- =============================================================================
