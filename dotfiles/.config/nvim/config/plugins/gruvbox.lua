local inlayHint = { italic = true, fg = "#525252" }
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  contrast = "hard", -- can be "hard", "soft" or empty string
  transparent_mode = true,
  -- override names found by running `:filt /\cinlay/ highlight`
  overrides = {
      ["LspInlayHint"] = inlayHint,
      ["CocInlayHint"] = inlayHint,
      ["CocInlayHintParameter"] = inlayHint,
      ["CocInlayHintType"] = inlayHint,
  },
})
vim.cmd("colorscheme gruvbox")
