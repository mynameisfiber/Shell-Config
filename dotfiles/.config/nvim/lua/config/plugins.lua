local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme: load immediately, high priority
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.plugins.gruvbox")
    end,
  },

  -- Treesitter: load when opening a file
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require("config.plugins.treesitter")
    end,
  },

  -- Statusline: load very early but not before UI
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.plugins.lualine")
    end,
  },

  -- File explorer: load on command or key
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<F3>", ":NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.plugins.nvim-tree")
    end,
  },

  -- Fuzzy finder: load on command or key
  {
    "nvim-telescope/telescope.nvim",
    version="*",
    cmd = "Telescope",
    keys = {
      { "t", ":Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help tags" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("config.plugins.telescope")
    end,
  },

  -- Comments: load on key or operator
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.comment")
    end,
  },

  -- Text objects: load when editing
  {
    "echasnovski/mini.ai",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("config.plugins.mini-ai")
    end,
  },

  -- Undo tree: load on command or key
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<F5>", ":UndotreeToggle<CR>", desc = "Toggle undo tree" },
    },
    config = function()
      require("config.plugins.undotree")
    end,
  },

  -- Git signs: load when opening a file
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.plugins.gitsigns")
    end,
  },

  -- Fugitive: load on Git command
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiff", "Gblame", "Gstatus" },
    keys = {
      { "<leader>gs", ":Git<CR>", desc = "Git status" },
      { "<leader>gd", ":Gdiff<CR>", desc = "Git diff" },
      { "<leader>gb", ":Git blame<CR>", desc = "Git blame" },
    },
    config = function()
      require("config.plugins.fugitive")
    end,
  },

  -- Symbols / outline: load on command, key, or LSP attach
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    keys = {
      { "<F2>", ":AerialToggle!<CR>", desc = "Toggle symbols outline" },
    },
    event = { "LspAttach" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("config.plugins.aerial")
    end,
  },

  -- LSP / completion: load when editing files
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("config.plugins.coc")
    end,
  },

  -- Tmux clipboard: load when needed
  {
    "roxma/vim-tmux-clipboard",
    event = "VeryLazy",
  },

  -- Clipboard image: load on command
  {
    "ekickx/clipboard-image.nvim",
    cmd = "PasteImg",
    ft = { "markdown" },
    config = function()
      require("config.plugins.clipboard-image")
    end,
  },
}, {
  defaults = {
    lazy = true,
    version = false,
  },
  install = {
    colorscheme = { "gruvbox" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
