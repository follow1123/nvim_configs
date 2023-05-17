-- 缩进对齐线插件
return {
	'lukas-reineke/indent-blankline.nvim',
	event = 'VeryLazy',
	config = function()
		vim.opt.list = true
		require("indent_blankline").setup {
			-- for example, context is off by default, use this to turn it on
			show_current_context = true,
			show_current_context_start = true,
		}
	end
}