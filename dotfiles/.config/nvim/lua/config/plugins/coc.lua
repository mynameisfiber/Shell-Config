-- List of extensions Coc should load.
-- Install them manually with :CocInstall or the shell script below.
vim.g.coc_global_extensions = {
  "coc-pyright",
  "coc-highlight",
  "coc-json",
  "coc-html",
  "coc-yank",
  "coc-eslint",
  "coc-tsserver",
  "coc-go",
}

-- Clean extensions not in the global list
vim.api.nvim_create_user_command("CocClean", function()
  local loaded = vim.fn.CocAction("loadedExtensions") or {}
  local to_clean = vim.tbl_filter(function(ext)
    return not ext:match("friendly%-snippets") and not vim.tbl_contains(vim.g.coc_global_extensions, ext)
  end, loaded)

  if #to_clean > 0 then
    vim.cmd("CocUninstall " .. table.concat(to_clean, " "))
  else
    print("Nothing to clean")
  end
end, {})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  command = "silent call CocAction('runCommand', 'editor.action.organizeImport')",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.b.coc_root_patterns = { ".git", ".env", "venv", ".venv", "setup.cfg", "setup.py", "pyrightconfig.json", "env" }
  end,
})

vim.keymap.set("n", "<leader>y", ":<C-u>CocList -A --normal yank<CR>", { silent = true })

vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- Diagnostics
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Documentation
vim.keymap.set("n", "K", function()
  if vim.fn.CocAction("hasProvider", "hover") == 1 then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_feedkeys("K", "in", false)
  end
end, { silent = true })

-- Highlight symbol under cursor
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  command = "silent call CocActionAsync('highlight')",
})

-- Rename / format / code actions
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)")
vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)")
vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)")

vim.api.nvim_create_augroup("mygroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "mygroup",
  pattern = { "typescript", "json" },
  callback = function()
    vim.opt_local.formatexpr = "CocAction('formatSelected')"
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = "mygroup",
  pattern = "CocJumpPlaceholder",
  command = "call CocActionAsync('showSignatureHelp')",
})

vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)")
vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)")
vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)")
vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)")
vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)")

-- Scroll float windows
vim.keymap.set({ "n", "i", "v" }, "<C-f>", function()
  return vim.fn["coc#float#has_scroll"]() == 1 and vim.fn["coc#float#scroll"](1) or "<C-f>"
end, { expr = true, silent = true, nowait = true })
vim.keymap.set({ "n", "i", "v" }, "<C-b>", function()
  return vim.fn["coc#float#has_scroll"]() == 1 and vim.fn["coc#float#scroll"](0) or "<C-b>"
end, { expr = true, silent = true, nowait = true })

-- Selection ranges
vim.keymap.set("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
vim.keymap.set("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- Commands
vim.api.nvim_create_user_command("Format", function()
  vim.fn.CocActionAsync("format")
end, {})
vim.api.nvim_create_user_command("Fold", function(args)
  vim.fn.CocAction("fold", args.args)
end, { nargs = "?" })
vim.api.nvim_create_user_command("OR", function()
  vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")
end, {})

-- CoCList mappings
vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>o", ":<C-u>CocList outline<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>j", ":<C-u>CocNext<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>k", ":<C-u>CocPrev<CR>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<CR>", { silent = true, nowait = true })

-- Tab completion (must be in Vimscript for <SID>)
vim.cmd([[
  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
]])
