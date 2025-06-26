require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Performance optimizations for large JS/TS projects
o.updatetime = 300
o.timeoutlen = 400
o.redrawtime = 1500
o.synmaxcol = 300

-- Better search
o.ignorecase = true
o.smartcase = true

-- File watcher settings
vim.g.netrw_dirhistmax = 0
vim.opt.wildignore:append { "*/node_modules/*", "*/.git/*", "*/dist/*", "*/build/*" }

-- Additional performance optimizations
vim.opt.lazyredraw = true
vim.opt.shadafile = "NONE"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Better completion experience
vim.opt.completeopt = "menuone,noselect,noinsert"
vim.opt.pumheight = 10

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Better scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Faster macros
vim.opt.lazyredraw = false

-- Load shada after UI
vim.schedule(function()
  vim.opt.shadafile = ""
  vim.cmd("silent! rshada")
end)
