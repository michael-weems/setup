-- import mason and mason_lspconfig
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'
local mason_tool_installer = require 'mason-tool-installer'

mason.setup {
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
}

mason_lspconfig.setup {
  automatic_enable = false, -- set true to enable all LSP in `ensure_installed`
  -- servers for mason to install
  ensure_installed = {
    'lua_ls',
    'gopls',
    'ols',
  },
}

mason_tool_installer.setup {
  ensure_installed = {
    'stylua',
    'pylint',
    'ols',
    'clangd',
  },
}
