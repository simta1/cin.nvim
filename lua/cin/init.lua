local M = {}

M.config = {
    mapping = false,
    types = {
        "int", "float", "double", "char", "bool", "string", "std::string",
        "long long", "long double",
        "ll", "ld", "ull"
    }
}

function M.insert_cin(start_line, end_line)
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    local variables = {}
    local indent = ""

    for _, line in ipairs(lines) do
        indent = line:match("^%s*") or ""
        local vars_str = nil
        for _, t in ipairs(M.config.types) do
            local m = line:match("%f[%a]" .. t .. "%s+(.+);")
            if m then
                vars_str = m
                break
            end
        end

        if vars_str then
            for var_str in vars_str:gmatch("[^,]+") do
                local var = var_str:match("^%s*(.-)%s*$")
                if var and var ~= "" then
                    table.insert(variables, var)
                end
            end
        end
    end

    if #variables > 0 then
        local res = indent .. "cin >> " .. table.concat(variables, " >> ") .. ";"
        vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { res })
        vim.api.nvim_win_set_cursor(0, { end_line + 1, #res })
    else
        vim.api.nvim_echo({{ "No valid variable declaration found", "WarningMsg" }}, false, {})
    end
end

function M.setup(opts)
    if opts then
        M.config = vim.tbl_deep_extend("force", M.config, opts)
    end

    vim.api.nvim_create_user_command("InsertCin", function(cmd_opts)
        M.insert_cin(cmd_opts.line1, cmd_opts.line2)
    end, { range = true })
    
    if M.config.mapping then
        local grp = vim.api.nvim_create_augroup("CppCinKeymaps", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = grp,
            pattern = "cpp",
            callback = function(ev)
                vim.keymap.set({ "n", "x" }, M.config.mapping, ":InsertCin<CR>", { buffer = ev.buf, silent = true })
            end,
        })
    end
end

return M
