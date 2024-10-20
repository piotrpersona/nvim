nvim_create_user_command('GoModTidy', go_mod_tidy, {})
vim.keymap.set("n", "<leader>gmt", function()
  vim.cmd([[ ! go mod tidy ]])
  vim.cmd([[ LspRestart ]])
end);
