return {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayVariableTypeHints = true,
      },
    },
  },
}