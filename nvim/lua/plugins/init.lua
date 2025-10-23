return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require('configs.conform')
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "change",
          expose_as_code_action = "all",
          tsserver_max_memory = 8192,
          complete_function_calls = true,
          include_completions_with_insert_text = true,
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
          tsserver_plugins = {},
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          }
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.lspconfig").setup()
    end,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  -- Essential productivity plugins
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup({
        auto_preview = false,
        auto_fold = true,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                 desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
    opts = {
      terminal_cmd = "~/.claude/local/claude"
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
        "javascript", "typescript", "tsx", "json", "jsonc"
      },
    },
  }, {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false, -- NOTE: NO NEED to Lazy load
  -- Optional. You can alse set your own keybindings
  keys = {
    -- Global Minimap Controls
    { "<leader>nm",  "<cmd>Neominimap toggle<cr>",      desc = "Toggle global minimap" },
    { "<leader>no",  "<cmd>Neominimap on<cr>",          desc = "Enable global minimap" },
    { "<leader>nc",  "<cmd>Neominimap off<cr>",         desc = "Disable global minimap" },
    { "<leader>nr",  "<cmd>Neominimap refresh<cr>",     desc = "Refresh global minimap" },

    -- Window-Specific Minimap Controls
    { "<leader>nwt", "<cmd>Neominimap winToggle<cr>",   desc = "Toggle minimap for current window" },
    { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>",  desc = "Refresh minimap for current window" },
    { "<leader>nwo", "<cmd>Neominimap winOn<cr>",       desc = "Enable minimap for current window" },
    { "<leader>nwc", "<cmd>Neominimap winOff<cr>",      desc = "Disable minimap for current window" },

    -- Tab-Specific Minimap Controls
    { "<leader>ntt", "<cmd>Neominimap tabToggle<cr>",   desc = "Toggle minimap for current tab" },
    { "<leader>ntr", "<cmd>Neominimap tabRefresh<cr>",  desc = "Refresh minimap for current tab" },
    { "<leader>nto", "<cmd>Neominimap tabOn<cr>",       desc = "Enable minimap for current tab" },
    { "<leader>ntc", "<cmd>Neominimap tabOff<cr>",      desc = "Disable minimap for current tab" },

    -- Buffer-Specific Minimap Controls
    { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>",   desc = "Toggle minimap for current buffer" },
    { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>",  desc = "Refresh minimap for current buffer" },
    { "<leader>nbo", "<cmd>Neominimap bufOn<cr>",       desc = "Enable minimap for current buffer" },
    { "<leader>nbc", "<cmd>Neominimap bufOff<cr>",      desc = "Disable minimap for current buffer" },

    ---Focus Controls
    { "<leader>nf",  "<cmd>Neominimap focus<cr>",       desc = "Focus on minimap" },
    { "<leader>nu",  "<cmd>Neominimap unfocus<cr>",     desc = "Unfocus minimap" },
    { "<leader>ns",  "<cmd>Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
  },
  init = function()
    -- The following options are recommended when layout == "float"
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36 -- Set a large value

    --- Put your configuration here
    vim.g.neominimap = {
      auto_enable = true,
    }
  end,
},
  -- Enhanced git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
          { desc = "Stage hunk" })
        map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
          { desc = "Reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function() gs.blame_line { full = true } end, { desc = "Blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
      end,
    },
  },
}
