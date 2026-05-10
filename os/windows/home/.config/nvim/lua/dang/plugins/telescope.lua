local telescope = require 'telescope'
local actions = require 'telescope.actions'
local builtin = require 'telescope.builtin'

telescope.load_extension 'themes'

telescope.setup {
  defaults = {
    path_display = { 'smart' },
    mappings = {
      i = {
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
      },
    },
  },
  extensions = {
    --themes = {
    --    enable_previewer = true,
    --    enable_live_preview = true,
    --    persist = {
    --        enabled = true,
    --        path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
    --    },
    --},
  },
}
--
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Keymaps
vim.keymap.set('n', '<leader>pr', '<cmd>Telescope oldfiles<CR>', { desc = 'Fuzzy find recent files' })
vim.keymap.set('n', '<leader>pWs', function()
  local word = vim.fn.expand '<cWORD>'
  builtin.grep_string { search = word }
end, { desc = 'Find Connected Words under cursor' })

--vim.keymap.set("n", "<leader>ths", "<cmd>Telescope themes<CR>", { noremap = true, silent = true, desc = "Theme Switcher" })
