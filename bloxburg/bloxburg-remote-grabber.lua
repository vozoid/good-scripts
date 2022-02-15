local fireserver = require(game:GetService("ReplicatedStorage").Modules.DataManager).FireServer
local get = getupvalue(fireserver, 4)

function fire(type, data)
    return get(type):FireServer(data)
end

function invoke(type, data)
    return get(type, true):InvokeServer(data)
end
