local utf8 = require("utf8")

function love.load()
    max = 3
    factor = math.floor(255/max)
    text = ""
    response = 0
    colorAnswerShown = ""
    red = love.math.random(0, max)*factor
    green = love.math.random(0, max)*factor
    blue = love.math.random(0, max)*factor
    rhexmain, rhexfactor = math.modf(red/16)
    ghexmain, ghexfactor = math.modf(green/16)
    bhexmain, bhexfactor = math.modf(blue/16)
    hex_convert = {[0] = "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D" ,"E", "F"}
    hexTable = {["0"] = 0, ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["A"] = 10, ["B"] = 11, ["C"] = 12, ["D"] = 13, ["E"] = 14, ["F"] = 15}
    rhex2 = hex_convert[rhexfactor*16]
    ghex2 = hex_convert[ghexfactor*16]
    bhex2 = hex_convert[bhexfactor*16]
    rhex1 = hex_convert[rhexmain]
    ghex1 = hex_convert[ghexmain]
    bhex1 = hex_convert[bhexmain]
    love.keyboard.setKeyRepeat(true)
    colorAnswer = tostring(rhex1)..tostring(rhex2)..tostring(ghex1)..tostring(ghex2)..tostring(bhex1)..tostring(bhex2)
    responseRed = 0
    responseGreen = 0
    responseBlue = 0
    rBitValue = 0
    gBitValue = 0
    bBitValue = 0
    char1 = 0
    char2 = 0
    char3 = 0
    char4 = 0
    char5 = 0
    char6 = 0
    valid = 0
    streak = 0
end

function createColor()
        red = love.math.random(0, max)*factor
        green = love.math.random(0, max)*factor
        blue = love.math.random(0, max)*factor
        text = ""
        rhexmain, rhexfactor = math.modf(red/16)
        ghexmain, ghexfactor = math.modf(green/16)
        bhexmain, bhexfactor = math.modf(blue/16)
        rhex2 = hex_convert[rhexfactor*16]
        ghex2 = hex_convert[ghexfactor*16]
        bhex2 = hex_convert[bhexfactor*16]
        rhex1 = hex_convert[rhexmain]
        ghex1 = hex_convert[ghexmain]
        bhex1 = hex_convert[bhexmain]
        colorAnswer = tostring(rhex1)..tostring(rhex2)..tostring(ghex1)..tostring(ghex2)..tostring(bhex1)..tostring(bhex2)
end

function colorGuessed()
    if text_length == 6 then
        responseRed = string.sub(text, 1,1)..string.sub(text, 2,2)
        responseGreen = string.sub(text, 3,3)..string.sub(text, 4,4)
        responseBlue = string.sub(text, 5,5)..string.sub(text, 6,6)
    else
        responseRed = 0
        responseGreen = 0
        responseBlue = 0
    end
end

function checkInput()
        char1 = hexTable[(string.sub(text, 1,1))]
        char2 = hexTable[(string.sub(text, 2,2))]
        char3 = hexTable[(string.sub(text, 3,3))]
        char4 = hexTable[(string.sub(text, 4,4))]
        char5 = hexTable[(string.sub(text, 5,5))]
        char6 = hexTable[(string.sub(text, 6,6))]
    if char1 == nil or char2 == nil or char3 == nil or char4 == nil or char5 == nil or char6 == nil then
        return(1)
    else
        return(0)
    end
end

function convertBits(rbit, gbit, bbit)
    rBitValue = hexTable[(string.sub(rbit, 1,1))]*16 + hexTable[(string.sub(rbit, 2,2))]
    gBitValue = hexTable[(string.sub(gbit, 1,1))]*16 + hexTable[(string.sub(gbit, 2,2))]
    bBitValue = hexTable[(string.sub(bbit, 1,1))]*16 + hexTable[(string.sub(bbit, 2,2))]
end

function love.textinput(t)
    text = text .. t
end

function responseToPlayer()
    if response == 1 and text == colorAnswer and text_length == 6 then
        colorAnswerShown = "Correct"
        colorGuessed()
        convertBits(responseRed, responseGreen, responseBlue)
        createColor()
        streak = streak + 1
        response = 0
    elseif response ==1 and text ~= colorAnswer and text_length == 6 then
        if valid == 1 then
            rBitValue = 0
            gBitValue = 0
            bBitValue = 0
            colorAnswerShown = "Submit a valid 6 character hex code Example: FFFFFF"

        else
            colorAnswerShown = "Wrong: "..tostring(colorAnswer)
            response = 0
            colorGuessed()
            convertBits(responseRed, responseGreen, responseBlue)
            createColor()
            streak = 0
        end
    else
        colorAnswerShown = "Please submit 6 characters"
    end

end

function love.update(dt)
    text_length = string.len(text)

    if text_length <= 6 then      
        love.keyboard.setTextInput(true)
    end

    if key == "backspace" then
        love.keyboard.setTextInput(true)
    end

    if text_length >=6 then
        love.keyboard.setTextInput(false)
    end

    if checkInput() == 1 then
        valid = 1
    else
        valid = 0
    end

end

function love.keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            text = string.sub(text, 1, byteoffset - 1)
        end
    end
    if love.keyboard.isDown("return") then
        response = 1
        responseToPlayer()
    end
end

function love.draw()

    love.graphics.setColor(love.math.colorFromBytes(red, green, blue))
    love.graphics.rectangle('fill', 40, 40, 200, 200, 0, 0)
    love.graphics.setColor(love.math.colorFromBytes(rBitValue, gBitValue, bBitValue))
    love.graphics.rectangle('fill', 440, 40, 200, 200, 0, 0)
    love.graphics.setColor(1,1,1)
    --love.graphics.print(tostring(colorAnswer), 40, 400) --shows answer in hexcode under the color
    love.graphics.rectangle('line', 40, 500, 200, 50, 0, 0)
    love.graphics.print("Input: " .. text, 45, 515)
    love.graphics.print(colorAnswerShown, 45, 565)
    love.graphics.print("Streak: "..tostring(streak))
end