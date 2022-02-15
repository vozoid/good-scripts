local remotes = {}

setmetatable(remotes, {
    __newindex = function(t, k, v)
        rawset(t, k:lower(), v)
    end,
    __index = function(t, k)
        return rawget(t, k:lower())
    end
})

for _, v in next, getgc() do
    if type(v) == "function" then
        if getinfo(v).name == "remoteAdded" then
            local hashes = getupvalue(v, 1)
            for hash, type in next, getupvalue(getupvalue(v, 2), 1) do
                remotes[type:gsub("F_", "")] = function(data) 
                    if hashes[hash]:IsA("RemoteEvent") then
                        hashes[hash]:FireServer(data)
                    elseif hashes[hash]:IsA("RemoteFunction") then
                        hashes[hash]:InvokeServer(data)
                    end
                end
            end
        end
    end
end
