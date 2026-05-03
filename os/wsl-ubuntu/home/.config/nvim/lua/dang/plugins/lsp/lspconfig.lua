-- vim.notify(
-- 	"=== ✅ LSP CONFIG LOADED SUCCESSFULLY ===",
-- 	vim.log.levels.INFO
-- ) vim.notify( "This is a very long error message\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\n...and it keeps going for a while to force the spill indicator",
--     vim.log.levels.ERROR
-- )

-- NOTE: LSP Keybinds
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- Find references for the word under your cursor.
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- NOTE: Diagnostic Setup
-- Define sign icons for each severity
local signs = {
  [vim.diagnostic.severity.ERROR] = ' ',
  [vim.diagnostic.severity.WARN] = ' ',
  [vim.diagnostic.severity.HINT] = '󰠠 ',
  [vim.diagnostic.severity.INFO] = ' ',
}

-- update diagnostic config function
vim.diagnostic.config {
  signs = { text = signs },
  virtual_text = true,
  underline = true, -- Always on
  update_in_insert = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = true,
  },
}

-- <leader>lx toggle for virtual text (no hover changes)
vim.keymap.set('n', '<leader>lx', function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = not current }
end, { desc = 'Toggle LSP virtual text' })

-- NOTE: Setup servers
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Native LSP capabilities (if dropping cmp_nvim_lsp)
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- if ok then
--     capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
-- end

-- Global LSP settings (applied to all servers)
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Configure and enable LSP servers
-- lua_ls
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- workspace = {
      --     library = {
      --         [vim.fn.expand("$VIMRUNTIME/lua")] = true,
      --         [vim.fn.stdpath("config") .. "/lua"] = true,
      --     },
      -- },
    },
  },
})

-- gopls
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- ols
vim.lsp.config('ols', {
  setup = {
    init_options = {
      checker_args = '-strict-style',
      collections = {
        { name = 'shared', path = vim.fn.expand '$HOME/odin-lib' },
      },
    },
  },
})

-- Instead of using mason enable all configured LSP via `automatic_enable=true`
-- Prefer more control, enable manual server call below via vim.lsp.enable("")
-- mason config: lua/sethy/plugins/lsp/mason.lua:22
vim.lsp.enable {
  'lua_ls',
  'gopls',
  'ols',
  'marksman',
}
