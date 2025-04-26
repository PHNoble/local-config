return {
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_dir = require("lspconfig.util").root_pattern(
    "docker-compose.yml",
    "docker-compose.yaml"
  ),
  settings = {},
}
