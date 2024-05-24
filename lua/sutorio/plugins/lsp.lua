return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Mason is a manager for LSP servers/formatters/linters,
            -- has a nice UI for [un]installing, updating, etc.
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Formatter plugin. This is used primarily because it defaults to LSP
            -- if no override is provided, makes it much easier to configure.
            "stevearc/conform.nvim",
        -- Linter plugin. We get linting ootb with a load of LSPs, buuut there are
        -- tools like Vale (the prose linter) that aren't as simple as "here is a file
        -- for programming language x, use language server y"
            "mfussenegger/nvim-lint",
        -- JSON (primarily) schema support: this is going to provide autocomplete
        -- support for a huge variety of config files.
            "b0o/schemastore.nvim",
            -- UI for progress notifications
            { "j-hui/fidget.nvim", opts = {} },
        },
    }
}
