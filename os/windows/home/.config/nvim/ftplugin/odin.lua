function maybe_enable_indent()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(ft) or ft

  -- Check if parser is installed AND has indent rules
  local has_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
  local has_queries = vim.treesitter.query.get(lang, "indents")

  if has_parser and has_queries then
    vim.bo[bufnr].indentexpr = "v:lua.vim.treesitter.indent()"
  end
end

maybe_enable_indent()
