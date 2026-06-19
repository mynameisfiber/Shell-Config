-- Leader
vim.g.mapleader = ","

-- Search keeps cursor centered
vim.keymap.set("n", "n", "nzz")

-- Exit insert mode with jk
vim.keymap.set("i", "jk", "<Esc>")

-- Disable arrow keys
vim.keymap.set({ "n", "i" }, "<right>", "<nop>")
vim.keymap.set({ "n", "i" }, "<left>", "<nop>")
vim.keymap.set({ "n", "i" }, "<up>", "<nop>")
vim.keymap.set({ "n", "i" }, "<down>", "<nop>")

-- Window navigation
vim.keymap.set({ "n", "i" }, "<C-Right>", "<C-w>l", { silent = true })
vim.keymap.set({ "n", "i" }, "<C-Left>", "<C-w>h", { silent = true })
vim.keymap.set({ "n", "i" }, "<C-Up>", "<C-w>k", { silent = true })
vim.keymap.set({ "n", "i" }, "<C-Down>", "<C-w>j", { silent = true })

-- Window resizing
vim.keymap.set("n", "<C-A-l>", "<C-w>>")
vim.keymap.set("n", "<C-A-k>", "<C-w>-")
vim.keymap.set("n", "<C-A-j>", "<C-w>+")
vim.keymap.set("n", "<C-A-h>", "<C-w><")
vim.keymap.set("n", "<C-l>", "5<C-w>>")
vim.keymap.set("n", "<C-k>", "5<C-w>-")
vim.keymap.set("n", "<C-j>", "5<C-w>+")
vim.keymap.set("n", "<C-h>", "5<C-w><")

-- Tabs
vim.keymap.set("n", "<C-t>", ":tabnew<CR>")
vim.keymap.set("i", "<C-t>", "<Esc>:tabnew<CR>")
vim.keymap.set("", "fj", ":tabnext<CR>")
vim.keymap.set("", "fJ", ":tabprevious<CR>")
vim.keymap.set("n", "gt", "<nop>")
vim.keymap.set("n", "gT", "<nop>")

-- Split creation
-- window
vim.keymap.set("n", "<leader>swh", ":topleft vnew<CR>")
vim.keymap.set("n", "<leader>swl", ":botright vnew<CR>")
vim.keymap.set("n", "<leader>swk", ":topleft new<CR>")
vim.keymap.set("n", "<leader>swj", ":botright new<CR>")
-- buffer
vim.keymap.set("n", "<leader>sh", ":leftabove vnew<CR>")
vim.keymap.set("n", "<leader>sl", ":rightbelow vnew<CR>")
vim.keymap.set("n", "<leader>sk", ":leftabove new<CR>")
vim.keymap.set("n", "<leader>sj", ":rightbelow new<CR>")

-- General
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("", "q:", ":q<CR>")

-- Reload all buffers
vim.keymap.set("n", "<F7>", ":bufdo e!<CR>")

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Leader-Leader to last insert location
vim.keymap.set("n", "<leader><leader>", "`^")

-- Yank, comment, paste
vim.keymap.set("n", "<leader>Y", "yy<Plug>(comment_toggle_linewise_current)p")
vim.keymap.set("v", "<leader>Y", "ygv<Plug>(comment_toggle_linewise_visual)P")
vim.keymap.set("n", "Y", "yy")
vim.keymap.set("n", "p", ":pu<CR>")
vim.keymap.set("n", "P", ":pu!<CR>")

-- Fold toggle with Space
vim.keymap.set("n", "<Space>", function()
  return vim.fn.foldlevel(".") > 0 and "za" or "<Space>"
end, { expr = true, silent = true })
vim.keymap.set("v", "<Space>", "zf")
