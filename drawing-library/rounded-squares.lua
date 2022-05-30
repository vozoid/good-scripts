-- color generator stuff

local decode = (syn and syn.crypt.base64.decode) or (crypt and crypt.base64decode) or base64_decode

-- original image data (simgle white pixel .bmp format) 
local chars = decode("Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAAAAADEDgAAxA4AAAAAAAAAAAAA////AA=="):split("")

-- get hex version of image data
local hex_data = ""

for _, v in next, chars do
    hex_data ..= bit.tohex(string.byte(v)) .. " "
end

-- remove color data from image data
hex_data = hex_data:sub(1, -36)

local function image_color(color)
    local str = hex_data

    local hex = color:ToHex()
    local r, g, b = hex:sub(0, 2), hex:sub(3, 4), hex:sub(5, 6)

    -- add new color data to the hex data (adding the 00 so it wont break)
    str ..= ("%s %s %s 00"):format(b, g, r)

    -- transform hex data back into binary data
    local data = ""

    for _, v in next, str:split(" ") do
        data ..= string.char(tonumber("0x" .. v))
    end

    return data
end

-- square generator

function rounded_square(color, rounding)
    local square = Drawing.new("Image")
    square.Data = image_color(color)
    square.Rounding = rounding

    return square
end

local square = rounded_square(Color3.fromRGB(255, 255, 255), 12)
square.Size = Vector2.new(200, 100)
square.Position = Vector2.new(100, 100)
square.Visible = true
