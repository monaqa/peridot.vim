local M = {}

---@alias context {count: integer, count1: integer, set_count: boolean, repeated: boolean}

local opfunc = nil
local textobj_func = nil

---@type context
local common_ctx = {}

---dot repeatable な編集操作。
---@param f fun(ctx: {count: integer, count1: integer, set_count: boolean, repeated: boolean}): nil
---@return fun(): string
function M.repeatable_edit(f)
    return function ()
        common_ctx.repeated = false
        common_ctx.count = vim.v.count
        common_ctx.count1 = vim.v.count1
        common_ctx.set_count = vim.v.count == vim.v.count1

        opfunc = f
        vim.o.operatorfunc = "peridot#_lua_opfunc"

        return [[g@<Cmd>lua require("peridot").set_counter()<CR>]]
    end
end

function M.repeatable_textobj(f)
    return function ()
        common_ctx.repeated = false
        textobj_func = f
        return [[<Cmd>lua require("peridot")._textobj()<CR>]]
    end
end

function M._textobj()
    common_ctx.count = vim.v.count
    common_ctx.count1 = vim.v.count1
    common_ctx.set_count = vim.v.count == vim.v.count1
    textobj_func(common_ctx)
    common_ctx.repeated = true
end

function M.set_counter()
    common_ctx.count = vim.v.count
    common_ctx.count1 = vim.v.count1
    common_ctx.set_count = vim.v.count == vim.v.count1
end

function M._opfunc(table)
    vim.pretty_print(common_ctx)
    opfunc(common_ctx)
    common_ctx.repeated = true
end

return M
