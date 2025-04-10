local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<leader>u', builtin.lsp_references, {desc= 'Telescope lsd defintion'})
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input('Grep >') });
end)
