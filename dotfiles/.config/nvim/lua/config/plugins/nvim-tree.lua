require("nvim-tree").setup({
  filters = {
    custom = { "\\.pyc$", "\\.sw[op]$", "__pycache__" },
  },
  git = {
    enable = true,
  },
  renderer = {
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
})
