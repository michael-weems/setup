-- auto run :TSUpdate on first install or when parsers change
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(event)
        -- only run on nvim-treesitter updates/installs
        if event.data.spec and event.data.spec.name == "nvim-treesitter" then
            -- force load plugin if it's not active yet (for vim.pack)
            if not event.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            -- run :TSUpdate (:TSUpdateSync for blocking)
            vim.cmd("TSUpdate")
        end
    end,
})
