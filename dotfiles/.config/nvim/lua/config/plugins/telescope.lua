require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "__pycache__",
      "node_modules",
      "%.pyc",
      "%.git/",
      "venv",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

require("telescope").load_extension("fzf")
