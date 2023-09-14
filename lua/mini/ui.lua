-- ###########################
-- #      主题颜色(theme)    #
-- ###########################

vim.cmd("colorscheme slate") -- 默认主题

-- 默认主题颜色设置
vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e1e" }) -- 背景颜色
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#e9e9e9", bg = "#04324f" }) -- 底部状态栏颜色
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#282828" }) -- 模式状态颜色
vim.api.nvim_set_hl(0, "Visual", { fg = "NONE", bg = "#264f78" }) -- visual模式选中文本的颜色
vim.api.nvim_set_hl(0, "ModeMsg", { fg = "#e9e9e9", bold = true }) -- 切换模式时左下角显示的颜色
vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" }) -- 垂直分屏时分割线的背景颜色
vim.api.nvim_set_hl(0, "MatchParen", { -- 光标在括号上时高亮另一对括号
  bg = "NONE",
  fg = "Yellow",
  sp = "Yellow",
  underline = true,
  bold = true,
  italic = true,
})

-- 补全相关颜色
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#cccccc", bg = "#252526" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#042e48" } )
vim.api.nvim_set_hl(0, "PmenuSBar", { bg = "#252525" } )
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#808080" } )
