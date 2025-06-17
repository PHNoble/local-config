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
