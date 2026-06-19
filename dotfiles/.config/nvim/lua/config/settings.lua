-- Filetype support (mostly default in Neovim, but explicit is fine)
vim.cmd("filetype plugin indent on")

-- Encoding
vim.opt.encoding = "utf-8"

-- Mouse right-click extends selection
vim.opt.mousemodel = "extend"

-- Sync with system clipboard
vim.opt.clipboard:prepend("unnamed,unnamedplus")

-- Spell check
vim.opt.spelllang = "fr,en"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.complete:append("kspell")
  end,
})

-- Gitgutter / sign column
vim.g.gitgutter_override_sign_column_highlight = 0
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = "NONE" })

-- Line numbers
vim.opt.numberwidth = 5
vim.opt.number = true
vim.opt.relativenumber = true

-- Completion menu
vim.opt.wildmode = "longest,list"

-- Visual block can go past end of line
vim.opt.virtualedit:append("block")

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Tabs / indentation
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Wildignore
vim.opt.wildignore:append({ "*__pycache__*", "*.pyc" })

-- Hidden buffers
vim.opt.hidden = true

-- No backups
vim.opt.backup = false
vim.opt.writebackup = false

-- Faster updates (also needed for gitgutter/coc)
vim.opt.updatetime = 300

-- Always show sign column
vim.opt.signcolumn = "yes"

-- Line wrapping
vim.opt.linebreak = true

-- Statusline
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
