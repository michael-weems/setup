-- NOTE: Default Keymaps for Comment.nvim
--   gc  → Toggle comment (linewise)          
--   gb  → Toggle comment (blockwise)         
--   gcc → Toggle comment on current line     
--   gbc → Toggle comment on current line (blockwise) 

-- Context commentstring (must be set up first)
require("ts_context_commentstring").setup({
  enable_autocmd = false, -- Comment.nvim will handle triggering
})

-- Main Comment.nvim setup
require("Comment").setup({
  padding = true,
  sticky = true,
  ignore = "^$",
})
