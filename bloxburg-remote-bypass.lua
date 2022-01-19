local remotes = {} -- define remotes table

for _, v in next, getgc() do -- loop through lua garbage collection
    if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then -- check if is function and is an lua closure and is not a synapse function
        if getinfo(v).name == "remoteAdded" then -- check name
            local hashes = getupvalue(v, 1) -- grab hashes and remotes
            local types = getupvalue(getupvalue(v, 2), 1) -- grab types and hashes
            for hash, type in next, types do -- loop through types
                remotes[type:gsub("F_", "")] = hashes[hash] -- add type = remote to remotes table
            end
        end
    end
end

local function fire(type, data) -- fire remote events with type and arguments
    remotes[type]:FireServer(data) -- go through the remotes table to find the correct remote to go with type and fire
end

local function invoke(type, data) -- invoke remote functions with type and arguments
    remotes[type]:InvokeServer(data) -- go through the remotes table to find the correct remote to go with type and invoke
end
