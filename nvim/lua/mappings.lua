require "nvchad.mappings"
local ts_builtin = require("telescope.builtin")
-- add yours here
vim.keymap.del("n", "<leader>n")
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>gd", ts_builtin.lsp_definitions, { desc = "Go to definition" })
map("n", "<leader>gr", ts_builtin.lsp_references, { desc = "Go to references" })
map("n", "<leader>gi", ts_builtin.lsp_implementations, { desc = "Go to implementations" })
map("n", "<leader>gx", ts_builtin.lsp_type_definitions, { desc = "Go to type definitions" })
map("n", "<leader>gk", vim.diagnostic.open_float, { desc = "Open floating lsp errors"})

map("n", "<leader>ta", "<cmd>TSToolsFixAll<cr>", { desc = "TSTools fix all"})
map("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Organize imports"})
map("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", { desc = "Sort imports"})
map("n", "<leader>tr", "<cmd>TSToolsRemoveUnusedImports<cr>", { desc = "Remove unused imports"})
map("n", "<leader>tf", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add missing imports"})
map("n", "<leader>td", "<cmd>TSToolsGoToSourceDefinition<cr>", { desc = "Go to source definition"})
map("n", "<leader>tR", "<cmd>TSToolsFileReferences<cr>", { desc = "Find file references"})
map("n", "<leader>te", "<cmd>TSToolsRenameFile<cr>", { desc = "Rename file and update imports"})
