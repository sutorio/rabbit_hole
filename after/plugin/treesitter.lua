require("nvim-treesitter.configs").setup({
  -- This takes a a list of parser names or "all".
  -- Latter is used. but note this makes an inial cold startup (rare) slow,
  -- and makes `:checkhealth` (common) hang while each parser is checked.
  ensure_installed = {
    "astro",
    "awk",
    "bash",
    "c",
    "c_sharp",
    "cmake",
    "comment",
    "cpp",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "editorconfig",
    "eex",
    "elixir",
    "elm",
    "erlang",
    "forth",
    "fsharp",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "gleam",
    "glsl",
    "go",
    "graphql",
    "heex",
    "hjson",
    "html",
    "http",
    "ini",
    "javascript",
    "jq",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "just",
    "kdl",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "nginx",
    "ocaml",
    "odin",
    "org",
    "printf",
    "prolog",
    "python",
    "query",
    "regex",
    "rescript",
    "robots",
    "ron",
    "ruby",
    "rust",
    "scss",
    "slint",
    "sql",
    "svelte",
    "swift",
    "tcl",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "typespec",
    "vim",
    "vimdoc",
    "wgsl",
    "wgsl_bevy",
    "xml",
    "yaml",
    "zig",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- REVIEW: not sure if this is super annoying or not: it stickies the current
-- head of the context in a file, eg the current function. Rust in particular
-- benefits a little bit from this, as functions can be quite long.
require("treesitter-context").setup({})

-- FIXME: I cannot get this to force all files to open unfolded; until fixed,
-- this is too annoying to use.
-- use TreeSitter to handle where code can be folded:
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- By default this means files will open with the code folded; don't want that.
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = "*",
--   command = "normal zR",
--   desc = "default to open folds on new buffers/files",
-- })
