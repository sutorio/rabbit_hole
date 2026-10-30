-- Overrides for the nvim-lspconfig `lua_ls` defaults. Files in `after/lsp/` are
-- merged on top of nvim-lspconfig's `lsp/` configs, see `:help lsp-config`.
return {
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
}
