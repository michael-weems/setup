local treesitter = require("nvim-treesitter")

local ensure_installed = {
    "json", "javascript", "typescript", "go", "yaml", "html", "css", "python", "http",
    "odin", "markdown", "markdown_inline", "bash", "lua", "vim",
    "dockerfile", "gitignore", "vimdoc", "c", "rust",
}

treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then
            return
        end

        -- load parser safely
        local ok_add = pcall(vim.treesitter.language.add, lang)
        if not ok_add then
            return
        end

        -- start treesitter safely
        pcall(vim.treesitter.start, buf, lang)

        -- enable indentation only for real languages
        if ft ~= "yaml" and ft ~= "markdown" then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.bo[buf].smartindent = false
            vim.bo[buf].cindent = false
        end
    end,
})

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true,           -- Auto-close tags
        enable_rename = true,          -- Auto-rename pairs
        enable_close_on_slash = false, -- Disable auto-close on trailing `</`
    },
    per_filetype = {
        ["html"] = {
            enable_close = true, -- Disable auto-closing for HTML
        },
    },
})
