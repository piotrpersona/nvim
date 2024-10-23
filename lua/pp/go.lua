vim.keymap.set("n", "<leader>gmt", function()
  vim.cmd([[ ! go mod tidy ]])
  vim.cmd([[ LspRestart ]])
end);
