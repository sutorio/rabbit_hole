-- Overrides for the nvim-lspconfig `jsonls` defaults: schemas for a huge range
-- of config files, from schemastore.nvim.
return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
