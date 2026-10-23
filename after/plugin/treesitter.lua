-- Parsers that aren't in nvim-treesitter's supported list. These have to be
-- (re)registered on every `User TSUpdate` event, which nvim-treesitter fires
-- itself before installing/updating, so this must come before `install()`.
-- NOTE: `queries` copies the highlight etc. queries from the parser repo;
--       `robots_txt` ships `highlight.scm` (wrong name), so its queries live
--       in `<root>/queries/robots_txt/` instead.
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  group = vim.api.nvim_create_augroup("Treesitter Custom Parsers", { clear = true }),
  callback = function()
    local parsers = require("nvim-treesitter.parsers")
    parsers.org = {
      install_info = {
        url = "https://github.com/milisims/tree-sitter-org",
        queries = "queries",
      },
    }
    parsers.prolog = {
      install_info = {
        url = "https://github.com/foxyseta/tree-sitter-prolog",
        -- Monorepo: the Prolog grammar sits alongside a ProbLog one.
        location = "grammars/prolog",
        queries = "grammars/prolog/queries",
      },
    }
    -- The grammar is named `robots_txt`, so the parser has to be too.
    parsers.robots_txt = {
      install_info = {
        url = "https://github.com/opa-oz/tree-sitter-robots-txt",
      },
    }
  end,
})

require("nvim-treesitter").install({
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
  "robots_txt",
  "ron",
  "ruby",
  "rust",
  "scss",
  "slint",
  "sql",
  "svelte",
  "swift",
  "tcl",
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
})

-- Neovim's filetype for `robots.txt` is `robots`.
vim.treesitter.language.register("robots_txt", "robots")

-- The `main` branch of nvim-treesitter doesn't enable anything itself: start
-- highlighting and indentation for any buffer whose filetype has a parser.
-- `vim.treesitter.start` errors when no parser is available, hence the `pcall`.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("Treesitter Start", { clear = true }),
  callback = function(event)
    if not pcall(vim.treesitter.start, event.buf) then
      return
    end
    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- REVIEW: not sure if this is super annoying or not: it stickies the current
-- head of the context in a file, eg the current function. Rust in particular
-- benefits a little bit from this, as functions can be quite long.
require("treesitter-context").setup()
