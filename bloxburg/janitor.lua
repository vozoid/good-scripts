local remotes = {}

for _, v in next, getgc() do
    if type(v) == "function" then
        if getinfo(v).name == "remoteAdded" then
            local hashes = getupvalue(v, 1)
            
            for hash, type in next, getupvalue(getupvalue(v, 2), 1) do
                local remote = hashes[hash]
                
                remotes[type:gsub("F_", "")] = function(data) 
                    if remote:IsA("RemoteEvent") then
                        return remote:FireServer(data)
                    elseif remote:IsA("RemoteFunction") then
                        return remote:InvokeServer(data)
                    end
                end
            end

            break
        end
    end
end

local services = setmetatable({}, {
    __index = function(_, k)
        return game:GetService(k)
    end
})

local client = services.Players.LocalPlayer
local environment = workspace.Environment

function closestTrash()
    local target
    local pos
    local distance = math.huge

    for _, spawn in next, environment.Locations.GreenClean.Spawns:GetChildren() do
        if spawn:FindFirstChild("Object") then
            if ((spawn:FindFirstChildOfClass("Part") and spawn:FindFirstChildOfClass("Part").Position or spawn.Position) - client.Character.HumanoidRootPart.Position).magnitude < distance then
                target = spawn
                pos = (spawn:FindFirstChildOfClass("Part") and spawn:FindFirstChildOfClass("Part").Position or spawn.Position)
                distance = ((spawn:FindFirstChildOfClass("Part") and spawn:FindFirstChildOfClass("Part").Position or spawn.Position) - client.Character.HumanoidRootPart.Position).magnitude
            end
        end
    end

    return target, pos
end

function playingAnimation()
    for _, anim in next, client.Character.Humanoid.Animator:GetPlayingAnimationTracks() do
        if anim.Animation.AnimationId == "rbxassetid://1015198302" or "rbxassetid://1015232152" then
            return true
        end
    end
end

while task.wait(0.1) do
    if services.ReplicatedStorage.Stats[client.Name].Job.Value == "CleanJanitor" then
        workspace.Gravity = 0

        for _, part in next, client.Character:GetDescendants() do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        local spawn, pos = closestTrash()

        if (pos - client.Character.HumanoidRootPart.Position).magnitude < 80 then
            client.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)

            repeat 
                remotes.CleanJanitorObject{Spawn = spawn}
                task.wait()
            until
                playingAnimation()
        else
            client.Character.HumanoidRootPart.CFrame = CFrame.new(client.Character.HumanoidRootPart.Position.X, pos.Y, client.Character.HumanoidRootPart.Position.Z)

            local tween = services.TweenService:Create(client.Character.HumanoidRootPart, TweenInfo.new((pos - client.Character.HumanoidRootPart.Position).magnitude / 20, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos.X, pos.Y, pos.Z)})
            tween:Play()

            repeat 
                task.wait()
            until
                (spawn.Position - client.Character.HumanoidRootPart.Position).magnitude <= 80

            tween:Cancel()
            client.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
            
            repeat 
                remotes.CleanJanitorObject{Spawn = spawn}
                task.wait()
            until
                playingAnimation()
        end
    end
end
