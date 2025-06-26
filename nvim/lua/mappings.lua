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

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Previous error" })
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })

-- Quickfix navigation
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

-- Trouble keymaps
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- UFO folding keymaps
map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
map("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
map("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" })
map("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek fold or hover" })
