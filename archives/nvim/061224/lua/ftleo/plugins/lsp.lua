
return {
    -- Mason pour gérer les serveurs LSP
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    -- Intégration Mason-LSPconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",   -- Python
                    "omnisharp", -- C#
                    "lua_ls",    -- Lua
                    "marksman",  -- Markdown
                    "clangd",    -- C
                    "bashls",    -- Bash
                },
            })
        end,
    },
    -- Configuration des serveurs LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Configuration des serveurs
            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.omnisharp.setup({
                capabilities = capabilities,
                cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                    },
                },
            })
            lspconfig.marksman.setup({ capabilities = capabilities })
            lspconfig.clangd.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
        end,
    },
    -- Autocomplétion avec nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    -- Formatter
    {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                -- Formatters
                null_ls.builtins.formatting.prettier.with({ filetypes = { "javascript", "typescript", "css", "html", "json", "markdown" } }),
                null_ls.builtins.formatting.black,    -- Python
                null_ls.builtins.formatting.stylua,   -- Lua
                null_ls.builtins.formatting.shfmt,    -- Shell scripts

                -- Linters (facultatif)
                null_ls.builtins.diagnostics.eslint_d, -- JavaScript/TypeScript
                null_ls.builtins.diagnostics.flake8,   -- Python
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.keymap.set("n", "<leader>ft", function()
                        vim.lsp.buf.format({ async = true })
                    end, { buffer = bufnr, desc = "[LSP] Format buffer" })
                end
            end,
        })
    end,
},
}
