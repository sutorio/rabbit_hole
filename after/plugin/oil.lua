require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  delete_to_trash = true,
  experimental_watch_for_changes = true,
})

require("sutorio.helpers").lmap({
  ["n-"] = { mode = "n", rhs = "<Cmd>Oil<Cr>", desc = "open parent directory" },
})
