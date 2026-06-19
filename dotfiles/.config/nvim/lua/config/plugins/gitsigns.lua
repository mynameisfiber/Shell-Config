require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true, buffer = bufnr })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, buffer = bufnr })

    vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    vim.keymap.set("n", "<leader>hS", gs.stage_buffer)
    vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)
    vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
    vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
    vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame)
    vim.keymap.set("n", "<leader>hd", gs.diffthis)
    vim.keymap.set("n", "<leader>hD", function() gs.diffthis("~") end)
    vim.keymap.set("n", "<leader>td", gs.toggle_deleted)
  end,
})
