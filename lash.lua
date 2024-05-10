
-- IMPORTANT
-- using true and false instead of 0 and 1
-- using tuples instead of return codes
-- using "ijection" for functions when required

-- links: https://www.gammon.com.au/scripts/doc.php?lua=io.popen


-- returns true if affirmative
-- returns false if negative
-- TODO: maybe add case where user cancelled (read from stdout)
confirm = function(prompt) -- TODO: add args for flags
    -- remove if causing problems, needs testing
    -- io.stdout:setvbuf 'no'

    local pipe = nil
    if prompt then
        pipe = io.popen('gum confirm "' .. tostring(prompt) .. '"')
    else
        pipe = io.popen('gum confirm')
    end

    if pipe then
        local _, _, ret_code = pipe:close()
        return (ret_code == 0)
    else
        return false
    end
end

-- returns true, choice if code 0
-- returns false, reason if code 1
choose = function(items)
    if #items < 2 then return false, "not enough items..." end

    local stdout = {}
    local exit_code = nil

    local command = 'gum choose'
    for _,v  in ipairs(items) do
        command = string.format('%s "%s"', command, v)
    end

    io.stdout:setvbuf 'no'
    local pipe = io.popen(command)
    if pipe then
        for line in pipe:lines() do
            table.insert(stdout, line)
        end
        local _, error_msg, ret_code = pipe:close()
        if error_msg then return false, error_msg end
        exit_code = ret_code
    else
        return false, "popen failed!"
    end

    return true, table.concat(stdout, '\n'), exit_code
end

choose_multi = function()

end

-- TODO: add more gum commands here

-- TODO: add commands for eza,

-- returns true,stdout,exit_code if successful
-- returns false,reason if failed
run = function(command)
    -- remove if causing problems, needs testing
    -- io.stdout:setvbuf 'no'
    local stdout = {}
    local exit_code = nil

    local pipe = io.popen(command)
    if pipe then
        for line in pipe:lines() do
            table.insert(stdout, line)
        end
        local _, _, ret_code = pipe:close()
        -- if error_msg then return false, error_msg end
        exit_code = ret_code
        return true, table.concat(stdout, '\n'), exit_code
    end
    return false, "popen failed!"
end

printf = function(...)
    print(string.format(...))
end
