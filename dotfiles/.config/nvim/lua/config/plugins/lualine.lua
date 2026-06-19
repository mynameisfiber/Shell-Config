require("lualine").setup({
  options = {
    theme = "gruvbox",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename", "aerial" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  tabline = {
    lualine_a = { "tabs" },
    lualine_b = { "buffers" },
    lualine_z = { "filename" },
  },
  extensions = { "nvim-tree", "fugitive" },
})
