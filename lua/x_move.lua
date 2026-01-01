local M = {}

function M.move_line_up()
    vim.cmd("move -2")
    vim.cmd("normal! V") -- 高亮当前行，易于观察，下次进入 move_visual_block 
end

function M.move_line_down()
    vim.cmd("move +1")
    vim.cmd("normal! V")
end

-- 上移（-1）/下移(1)
function M.move_visual_block(opts)
    local s = opts.line1
    local e = opts.line2
	local dir = tonumber(opts.args)
    local target
    if dir == 1 then
        target = e+1       -- 下移
    elseif dir == -1 then
        target = s-2       -- 上移
    else
        return
    end

    -- 构造命令
    local cmd = string.format(":%d,%dm%d", s, e, target)
    vim.cmd(cmd)
    -- reselect-Visual, :h gv  
	-- NOTE: visual range will automatically change if move command affects it, `affect` means:
	-- move line before range block to after it, and vice versa
    vim.cmd("normal! gv")
end

function M.setup()
    vim.keymap.set('n', '<A-Up>', M.move_line_up, { desc = "Move line up" })
    vim.keymap.set('n', '<A-Down>', M.move_line_down, { desc = "Move line down" })
	vim.api.nvim_create_user_command('XMoveBlock', M.move_visual_block,
	{
		nargs = 1,
		range = true,
		desc = "移动选中块, 1向下，-1向上",
		complete = function()
			return {"1", "-1"}
		end
	})
	vim.keymap.set('x', '<A-Up>', ':XMoveBlock -1<CR>',{ noremap = true, silent = true } )
	vim.keymap.set('x', '<A-Down>',  ':XMoveBlock 1<CR>', { noremap = true, silent = true })
end

return M
