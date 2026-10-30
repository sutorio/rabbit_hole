function SetupColour(colour)
  colour = colour or "sutor_dark_fusion"
  vim.cmd.colorscheme(colour)

  -- Transparent background: keep each group's other attributes (`nvim_set_hl`
  -- replaces the whole group) and drop just the background.
  for _, group in ipairs({ "Normal", "NormalFloat" }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
end

SetupColour()
