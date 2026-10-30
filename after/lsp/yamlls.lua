-- Overrides for the nvim-lspconfig `yamlls` defaults: use schemastore.nvim's
-- schemas instead of the server's built-in SchemaStore download.
return {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}
