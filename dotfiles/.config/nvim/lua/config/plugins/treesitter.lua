require("nvim-treesitter").setup({
  -- Install parsers automatically
  ensure_installed = {
    "python",
    "go",
    "typescript",
    "javascript",
    "json",
    "html",
    "css",
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "markdown_inline",
    "bash",
    "yaml",
    "toml",
    "dockerfile",
  },

  -- Install missing parsers on open
  auto_install = true,

  -- Enable syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- Enable indentation
  indent = {
    enable = true,
  },

  -- Enable incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "v",
      node_incremental = "v",
      scope_incremental = "<C-v>",
      node_decremental = "V",
    },
  },

  -- Text objects
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
  },
})
