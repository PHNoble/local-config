local lspconfig = require('lspconfig')
local defaults = require("nvchad.configs.lspconfig").defaults()

-- local tsserver_opts = require("configs.tsserver")
local docker_compose_opts = require("configs.docker-compose-ls")

local M = {}

M.setup = function()
  -- setup servers
  lspconfig.html.setup({})
  lspconfig.cssls.setup({})

  lspconfig.docker_compose_language_service.setup(vim.tbl_deep_extend("force", defaults or {}, docker_compose_opts))
end


return M
