require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown", "man" },
  layout = {
    default_direction = "prefer_right",
    placement = "window",
  },
  attach_mode = "window",
  show_guides = true,
  filter_kind = false,
  keymaps = {
    ["<F2>"] = "actions.close",
  },
})

require("lualine").setup({
  sections = {
    lualine_c = { "aerial" },
  },
})
