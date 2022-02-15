local remotes = {}

for _, v in next, getgc() do
    if type(v) == "function" then
        if getinfo(v).name == "remoteAdded" then
            local hashes = getupvalue(v, 1)
            for hash, type in next, getupvalue(getupvalue(v, 2), 1) do
                local remote = hashes[hash]
                remotes[type:gsub("F_", "")] = function(data) 
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(data)
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(data)
                    end
                end
            end
        end
    end
end
