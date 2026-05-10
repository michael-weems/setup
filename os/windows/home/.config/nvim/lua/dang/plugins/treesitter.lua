vim.treesitter.language.add('odin')

require('nvim-ts-autotag').setup {
  opts = {
    enable_close = true, -- Auto-close tags
    enable_rename = true, -- Auto-rename pairs
    enable_close_on_slash = false, -- Disable auto-close on trailing `</`
  },
  per_filetype = {
    ['html'] = {
      enable_close = true, -- Disable auto-closing for HTML
    },
  },
}
