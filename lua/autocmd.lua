-- 去除回车后注释下一行
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
})


if _G.IS_WINDOWS then
	-- -- 进入insert模式后切换为中文输入法
	-- vim.api.nvim_create_autocmd({"InsertLeave"}, {
	-- 	pattern = { "*" },
	-- 	callback = function()
	-- 		vim.fn.system("im-select.exe 1033")
	-- 	end,
	-- })
	-- 离开insert模式后切换为英文输入法
	vim.api.nvim_create_autocmd({"InsertLeave"}, {
		pattern = { "*" },
		callback = function()
			vim.fn.system("im_select.exe 1")
		end,
	})
else
	-- 离开插入模式后输入法自动切换为英文
	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		pattern = { "*" },
		callback = function()
			local input_status = tonumber(vim.fn.system("fcitx5-remote"))
			if input_status == 2 then
				vim.fn.system("fcitx5-remote -c")
			end
		end,
	})
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = { "*" },
	command = "silent! wall",
	nested = true,
})
if not _G.IS_GUI then
	-- vim退出后还原光标样式
	vim.api.nvim_create_autocmd({ "VimLeave" }, {
		pattern = { "*" },
		callback = function()
			vim.api.nvim_command("set guicursor=n-v-c-sm:ver25")
			vim.fn.system("im-select.exe 2052")
		end,
		nested = true,
	})
end

-- 关闭buffer时先关闭nvimtree
vim.api.nvim_create_autocmd({ "BufDelete" }, {
	pattern = { "*" },
	-- command = "lua print(123123)",
	callback = function()
		local tree = require("nvim-tree.api").tree
		if tree.is_visible() then
			tree.close()
		end
	end,
	-- nested = true,
})

 -- vim 启动后打开上一次的session,TODO 打开时主题有问题
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	pattern = { "*" },
-- 	callback = function()
-- 		local buf_id = vim.api.nvim_get_current_buf()
-- 		local buf_name = vim.api.nvim_buf_get_name(buf_id)
-- 		-- print(buf_name == "")
-- 		if buf_name == "" then
-- 			require("persistence").load {
-- 				last = true
-- 			}
-- 		end
-- 	end
-- })
-- 复制时高亮
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})
