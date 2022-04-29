-- SCRIPT

local function ismouseover(obj)
    local posX, posY = obj.Position.X, obj.Position.Y
    local sizeX, sizeY = posX + obj.Size.X, posY + obj.Size.Y

    if game:GetService("UserInputService"):GetMouseLocation().X >= posX and game:GetService("UserInputService"):GetMouseLocation().Y >= posY and game:GetService("UserInputService"):GetMouseLocation().X <= sizeX and game:GetService("UserInputService"):GetMouseLocation().Y <= sizeY then
        return true
    end

    return false
end

local allowedcharacters = {}

local shiftcharacters = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    ["["] = "{",
    ["\\"] = "|",
    [";"] = ":",
    ["'"] = "\"",
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~"
}

for i = 32, 126 do
    table.insert(allowedcharacters, utf8.char(i))
end

local function createbox(box, text)
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and ismouseover(box) then
            game:GetService("ContextActionService"):BindActionAtPriority("disablekeyboard", function() return Enum.ContextActionResult.Sink end, false, 3000, Enum.UserInputType.Keyboard)
            
            local connection
            connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode ~= Enum.KeyCode.Backspace then
                        local str = game:GetService("UserInputService"):GetStringForKeyCode(input.KeyCode)
        
                        if table.find(allowedcharacters, str) then
                            if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightShift) and not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                                text.Text = text.Text .. str:lower()
                            else
                                text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                            end
                        end
                    else
                        text.Text = text.Text:sub(1, -2)
                    end
        
                    if input.KeyCode == Enum.KeyCode.Return then
                        game:GetService("ContextActionService"):UnbindAction("disablekeyboard")
                        connection:Disconnect()
                    end
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    game:GetService("ContextActionService"):UnbindAction("disablekeyboard")
                    connection:Disconnect()
                end
            end)
        end
    end)
end

-- EXAMPLES

local box = Drawing.new("Square")
box.Visible = true
box.Filled = true
box.Thickness = 0
box.Position = Vector2.new(100, 100)
box.Size = Vector2.new(200, 50)

local text = Drawing.new("Text")
text.Visible = true
text.Size = 20
text.Color = Color3.fromRGB(255, 255, 255)
text.Position = Vector2.new(200, 112.5)
text.Center = true

createbox(box, text)
