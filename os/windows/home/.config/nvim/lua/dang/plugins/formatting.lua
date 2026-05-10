local conform = require 'conform'

conform.setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    return {
      timeout_ms = 500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters = {
    ['odinfmt'] = {
      command = 'odinfmt',
      args = { '-stdin' },
      stdin = true,
    },
    ['markdown-toc'] = {
      condition = function(_, ctx)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
          if line:find '<!%-%- toc %-%->' then
            return true
          end
        end
      end,
    },
    ['markdownlint-cli2'] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d)
          return d.source == 'markdownlint'
        end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    odin = { 'odinfmt' },
  },
  -- format_on_save = {
  -- 	lsp_fallback = true,
  -- 	async = false,
  -- 	timeout_ms = 1000,
  -- },
}

vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
  conform.format {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  }
end, { desc = 'Format whole file or range (in visual mode) with' })
