local M = {}

function M.setup()
	require("Comment").setup()
	vim.keymap.set("n", "<c-/>", function() require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true })
end
return M
