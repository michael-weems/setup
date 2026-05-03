-- Core
require("dang.plugins.lazydev")

-- Syntax & Highlighting
require("dang.plugins.treesitter")

-- Themes
require("dang.plugins.colorscheme")

-- UI & Others
require("dang.plugins.mini")
require("dang.plugins.snacks")
require("dang.plugins.lualine")
require("dang.plugins.noice")

-- File Management
require("dang.plugins.oil")
--require("dang.plugins.fff") -- TODO: look into using this?
require("dang.plugins.telescope")

-- Editing Helpers
-- require("dang.plugins.harpoon")
require("dang.plugins.formatting")
require("dang.plugins.nvim-ufo")
require("dang.plugins.auto-pairs")
require("dang.plugins.comment")
require("dang.plugins.colorizer")
require("dang.plugins.render-markdown")
require("dang.plugins.emmet")

-- Git
require("dang.plugins.gitstuff")

-- Completion
require("dang.plugins.nvim-cmp")

-- LSP 
require("dang.plugins.lsp.mason") -- mason has to load before lspconfig
require("dang.plugins.lsp.lspconfig")

require("dang.plugins.trouble")
require("dang.plugins.todo-comments")
