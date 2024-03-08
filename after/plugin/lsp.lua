-- vim:fileencoding=utf-8:foldmethod=marker
-- =============================================================================
-- IDE setup: LSP functionality, completions, snippets, formatting etc.
-- =============================================================================
-- {{{ Aliases
-- =============================================================================
local sutorio_helpers = require("sutorio.helpers")
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
local lspkind = require("lspkind")
local luasnip = require("luasnip")
-- }}}
-- =============================================================================
-- {{{ LSP server custom rules (overrides defaults)
-- =============================================================================
local deno_ls_custom_config = function()
  lspconfig.denols.setup({
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  })
end

local emmet_ls_custom_config = function()
  lspconfig.emmet_ls.setup({
    -- The Emmet language server requires hints re. which extensions it
    -- should provide completions for. I only care about HTML/HTML templating
    filetypes = {
      "html",
      "heex",
      "eex",
      "njk",
    },
  })
end

local jsonls_custom_config = function()
  lspconfig.jsonls.setup({
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  })
end

local lua_ls_custom_config = function()
  lspconfig.lua_ls.setup({
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
  })
end

local tailwindcss_custom_config = function()
  lspconfig.tailwindcss.setup({
    root_dir = lspconfig.util.root_pattern("tailwind.config.js"),
    settings = {
      tailwindCSS = {
        experimental = {
          -- class variance authority support: see https://cva.style/docs/getting-started/installation
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  })
end

local tsserver_custom_config = function()
  lspconfig.tsserver.setup({
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
    single_file_support = false,
  })
end

local vale_ls_custom_config = function()
  lspconfig.vale_ls.setup({
    root_dir = lspconfig.util.root_pattern(".vale.ini"),
  })
end
-- =============================================================================
-- {{{ Formatters
-- =============================================================================
-- `conform.nvim` frovides the formatting infra.
-- NOTE: Conform is used simply because it's much easier to set up than anything
-- else with regards to defaulting back to the formatting implementation included
-- in the given LSP.
require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    lua = { "stylua" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    markdown = { "deno_fmt" },
    json = { "deno_fmt" },
    jsonc = { "deno_fmt" },
    ruby = { "rubyfmt" },
  },
})
-- }}}
-- =============================================================================
-- {{{ Linters
-- =============================================================================
local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "eslint" },
  javascriptreact = { "eslint" },
  ["javascript.jsx"] = { "eslint" },
  typescript = { "eslint" },
  typescriptreact = { "eslint" },
  ["typescript.tsx"] = { "eslint" },

  -- markdown = { "vale" },
}

-- }}}
-- =============================================================================
-- =============================================================================
-- {{{ Completions setup
-- =============================================================================
local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    -- { name = "orgmode" },
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
      symbol_map = { Copilor = "" },
    }),
  },
})
-- }}}
-- =============================================================================
-- {{{ LSP: config functions
-- =============================================================================
local InitDiagnosticsUi = function()
  local diagnostics = {
    Error = "",
    Hint = "",
    Information = "",
    Question = "",
    Warning = "",
  }

  local signs = {
    { name = "DiagnosticSignError", text = diagnostics.Error },
    { name = "DiagnosticSignWarn", text = diagnostics.Warning },
    { name = "DiagnosticSignHint", text = diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = diagnostics.Info },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = sign.name }
    )
  end

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
        active = signs,
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
  -- NOTE: this is being handled by noice.nvim
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

local InitHighlighting = function(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    -- Set up an augroup for LSP highlighting...
    local lsp_highlight_grp =
      vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

    -- ...then apply
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.schedule(vim.lsp.buf.document_highlight)
      end,
      group = lsp_highlight_grp,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.schedule(vim.lsp.buf.clear_references)
      end,
      group = lsp_highlight_grp,
      buffer = bufnr,
    })
  end
end

local InitLinting = function(client)
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

local InitFormatting = function(client)
  -- NOTE: I give up. The built in formatting works...sometimes. Most of the time
  -- it's an ultra-frustrating garbage fire.
  client.server_capabilities.document_formatting = true
  client.server_capabilities.document_range_formatting = true

  vim.keymap.set("n", "<leader>ef", function()
    require("conform").format({ lsp_fallback = true })
  end, { desc = "format document" })
end
-- }}}
-- =============================================================================
-- {{{ Snippets setup
local SetupLuaSnip = function()
  luasnip.setup({
    history = true,
    updateevents = "TextChanged, TextChangedI",
    enable_autosnippets = true,
  })
  -- For VSCode-style snippets, they need to live in a directory on the
  -- runtime path, with a package.json manifest. So this is not, strictly
  -- speaking, necessary (LuaSnip will locate the VSCode-style snippets by
  -- default). But it allows other loaders to be added that point to this
  -- directory without much fuss.
  local snippets_fpath =
    sutorio_helpers.path_join(vim.fn.stdpath("config"), "snippets")

  require("luasnip.loaders.from_vscode").load({ paths = snippets_fpath })
end

-- }}}
-- =============================================================================
-- {{{ Copilot setup
-- =============================================================================
local SetupCopilot = function()
  -- TODO: tweak this. In particular, I want copilot to start/stop on-demand.
  --       The server takes a while to start, so just setting up straightaway
  --       is gonna make NVim hang to fuck.
  --       See: https://github.com/zbirenbaum/copilot.lua
  require("copilot").setup()
  require("copilot_cmp").setup()
end
-- }}}
-- =============================================================================
-- {{{ LSP: finalise setup
-- =============================================================================

InitDiagnosticsUi()
SetupLuaSnip()
SetupCopilot()

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

    local opts = { buffer = buffer }

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

    InitHighlighting(client, buffer)
    InitFormatting(client)
    InitLinting(client)
  end,
})

local default_setup = function(server)
  lspconfig[server].setup({})
end

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "cssls",
    "denols",
    "emmet_ls",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "ruby_ls",
    "rust_analyzer",
    "tsserver",
    "tailwindcss",
    -- "vale_ls",
  },
  handlers = {
    default_setup,
    denols = deno_ls_custom_config,
    emmet_ls = emmet_ls_custom_config,
    jsonls = jsonls_custom_config,
    lua_ls = lua_ls_custom_config,
    tailwindcss = tailwindcss_custom_config,
    tsserver = tsserver_custom_config,
    -- vale_ls = vale_ls_custom_config,
  },
})
-- }}}
-- =============================================================================
