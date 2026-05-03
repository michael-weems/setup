return("oil").setup({
   default_file_explorer = true,
   columns = { 'icon' },
   keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<M-h>'] = 'actions.select_split',
      ['<C-r>'] = 'actions.refresh',
      ['q'] = 'actions.close',
   },
   delete_to_trash = true,
   view_options = {
      show_hidden = true,
   },
   skip_confirm_for_simple_edits = true,
})

      -- Open parent directory in current window
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Open parent directory in floating window
vim.keymap.set('n', '<leader>-', require('oil').toggle_float)

vim.api.nvim_create_autocmd("FileType", {
   pattern = "oil", -- TODO: adjust if oil uses a specific file type identifier
   callback = function()
      vim.opt_local.cursorline = true
   end,
})
