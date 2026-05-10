-- telescope-fzf-native.nvim is a pain in my rear
local hooks = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
    vim
      .system(
        { 'bash', '-c', 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
        { cwd = ev.data.path }
      )
      :wait()
  end
end
vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

vim.pack.add {
  -- Core
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, --enabled (used by telescope & git_worktree.nvim)
  --{ src = "https://github.com/christoomey/vim-tmux-navigator" }, --enabled
  { src = 'https://github.com/folke/lazydev.nvim' }, --enabled

  ---{ src = "https://github.com/dmtrKovalenko/fff.nvim" }, --enabled

  -- all telescope
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', branch = 'master' }, --enabled
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' }, --enabled
  { src = 'https://github.com/andrew-george/telescope-themes' }, --enabled

  { src = 'https://github.com/windwp/nvim-autopairs' }, --enabled
  { src = 'https://github.com/nvim-lualine/lualine.nvim' }, --enabled

  { src = 'https://github.com/stevearc/oil.nvim' }, --enabled

  { src = 'https://github.com/stevearc/conform.nvim' },

  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, --enabled

  { src = 'https://github.com/folke/todo-comments.nvim' }, --enabled
  { src = 'https://github.com/folke/trouble.nvim' }, --enabled

  { src = 'https://github.com/mbbill/undotree' }, --enabled

  --{ src = "https://github.com/folke/snacks.nvim" }, --enabled
  --{ src = "https://github.com/echasnovski/mini.nvim" }, --enabled

  { src = 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring' }, -- enabled
  { src = 'https://github.com/numToStr/Comment.nvim' }, --enabled

  -- git
  { src = 'https://github.com/ThePrimeagen/git-worktree.nvim' }, --enabled
  { src = 'https://github.com/lewis6991/gitsigns.nvim' }, --enabled
  { src = 'https://github.com/tpope/vim-fugitive' }, --enabled
  { src = 'https://github.com/kdheepak/lazygit.nvim' }, --enabled

  { src = 'https://github.com/windwp/nvim-ts-autotag' }, --enabled

  -- completions cmp
  { src = 'https://github.com/hrsh7th/nvim-cmp' }, --enabled
  -- completions dependency
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  { src = 'https://github.com/hrsh7th/cmp-buffer' },
  { src = 'https://github.com/hrsh7th/cmp-path' },
  { src = 'https://github.com/hrsh7th/cmp-cmdline' },
  { src = 'https://github.com/f3fora/cmp-spell' },
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = 'v2.4.1' },
  { src = 'https://github.com/saadparwaiz1/cmp_luasnip' },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/onsails/lspkind.nvim' },

  -- LSP stack
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },

  { src = 'https://github.com/NvChad/nvim-colorizer.lua' }, --enabled

  -- icons
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, --enabled
}

-- NOTE: pack nonactive - show all non active plugins on disk but removed from pack.lua
vim.api.nvim_create_user_command('PackCheck', function()
  local non_active = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  if #non_active == 0 then
    vim.notify('🆗 No non-active plugins found!', vim.log.levels.INFO)
    return
  end

  vim.print '😴 Non-active plugins :'
  print ' '
  -- vim.print(non_active)
  for _, name in ipairs(non_active) do
    print(name)
  end

  print ' '

  local choice = vim.fn.confirm(
    'Delete ALL non-active plugins from disk?',
    '&Yes\n&No',
    2 -- default = No
  )

  if choice == 1 then
    vim.pack.del(non_active)
    vim.notify('🗑️  Deleted ' .. #non_active .. ' non-active plugin(s)', vim.log.levels.INFO)
    print 'Non-active plugins deleted!'
    vim.api.nvim_exec_autocmds('User', { pattern = 'PackChanged' })
  else
    vim.notify('Cancelled. No plugins were deleted!', vim.log.levels.INFO)
  end
end, { desc = 'List non active plugins and select to delete' })
