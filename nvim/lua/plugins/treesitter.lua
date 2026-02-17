-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "elixir",
      "heex",
      "dockerfile",
      "yaml",
      "json",
      "bash",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
