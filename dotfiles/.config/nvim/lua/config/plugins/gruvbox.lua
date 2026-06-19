local inlayHint = { italic = true, fg = "#525252" }

require("gruvbox").setup({
  terminal_colors = true,
  contrast = "hard",
  transparent_mode = true,
  overrides = {
    LspInlayHint = inlayHint,
    CocInlayHint = inlayHint,
    CocInlayHintParameter = inlayHint,
    CocInlayHintType = inlayHint,
  },
})

vim.cmd("colorscheme gruvbox")
