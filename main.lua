local utf8 = require("utf8")

function love.load()
    max = 3
    factor = math.floor(255/max)
    text = ""
    upperText = ""
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
    maxStreak = streak
    background = love.graphics.newImage("Background.png")
    colorBorder = love.graphics.newImage("SquareBorder.png")
    font = love.graphics.newFont(30)
    inputButton = love.graphics.newImage("inputbutton.png")
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

function windowChangeHeight()
    local windowHeight = love.graphics.getHeight()
    return windowHeight, windowWidth
end

function windowChangeWidth()
    local windowWidth = love.graphics.getWidth()
    return windowWidth
end

function colorGuessed()
    fullCaps()
    if text_length == 6 then
        responseRed = string.sub(upperText, 1,1)..string.sub(upperText, 2,2)
        responseGreen = string.sub(upperText, 3,3)..string.sub(upperText, 4,4)
        responseBlue = string.sub(upperText, 5,5)..string.sub(upperText, 6,6)
    else
        responseRed = 0
        responseGreen = 0
        responseBlue = 0
    end
end

function fontSize()
        if love.graphics.getWidth()<800 then
            local size = 30
            return size
        elseif love.graphics.getWidth()>1300 then
            local size = 50
            return size
        else
            local size = 40 
            return size
    end
end

function fontScale()
    if love.graphics.getWidth()<800 then
            local size = 80
            return size
        elseif love.graphics.getWidth()>1300 then
            local size = 120
            return size
        else
            local size = 100
            return size
    end
end

function checkInput()
        fullCaps()
        char1 = hexTable[(string.sub(upperText, 1,1))]
        char2 = hexTable[(string.sub(upperText, 2,2))]
        char3 = hexTable[(string.sub(upperText, 3,3))]
        char4 = hexTable[(string.sub(upperText, 4,4))]
        char5 = hexTable[(string.sub(upperText, 5,5))]
        char6 = hexTable[(string.sub(upperText, 6,6))]
    if char1 == nil or char2 == nil or char3 == nil or char4 == nil or char5 == nil or char6 == nil then
        return(1)
    else
        return(0)
    end
end

function fullCaps()
    upperText = string.upper(text)
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
    fullCaps()
    if response == 1 and upperText == colorAnswer and text_length == 6 then
        colorAnswerShown = "Correct"
        colorGuessed()
        convertBits(responseRed, responseGreen, responseBlue)
        createColor()
        streak = streak + 1
        if maxStreak <= streak then
            maxStreak = streak
        else
            maxStreak = maxStreak
        end
        response = 0
    elseif response ==1 and upperText ~= colorAnswer and text_length == 6 then
        if valid == 1 then
            rBitValue = 0
            gBitValue = 0
            bBitValue = 0
            colorAnswerShown = ""
            text=""

        else
            colorAnswerShown = "Wrong: "..tostring(colorAnswer)
            response = 0
            colorGuessed()
            convertBits(responseRed, responseGreen, responseBlue)
            createColor()
            maxStreak = maxStreak
            streak = 0
        end
    else
        colorAnswerShown = "Please submit 6 characters"
    end

end

function rectangleSide()
    if 2.5*windowChangeHeight() < windowChangeWidth() then
        local sideLength = windowChangeHeight()/4
        return sideLength

    elseif windowChangeHeight() > 1.5*windowChangeWidth() then
        local sideLength = windowChangeWidth()/4
        return sideLength

    elseif windowChangeHeight() < windowChangeWidth() then
        local sideLength = windowChangeWidth()/4
        return sideLength
    else
        local sideLength = windowChangeHeight()/4
        return sideLength
    end
end

function borderScale()
   local borderS = rectangleSide()/600
   return borderS
end

function love.update(dt)
    text_length = string.len(text)
    fontSize()
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
    if windowChangeHeight() < 400 then
        love.window.setMode(windowChangeWidth(), 400, {resizable = true})
    end
    if windowChangeWidth() < 400 then
        love.window.setMode(400, windowChangeHeight(), {resizable = true})
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
    for i = 0, love.graphics.getWidth()/background:getWidth() do
        for j = 0, love.graphics.getHeight()/background:getHeight() do
            love.graphics.draw(background, i*background:getWidth(), j*background:getHeight())
        end
    end
    love.graphics.setFont(love.graphics.newFont(fontSize()))
    love.graphics.setColor(love.math.colorFromBytes(red, green, blue))
    love.graphics.rectangle('fill', (windowChangeWidth()/2-1.25*rectangleSide()), (windowChangeHeight()/10), rectangleSide(), rectangleSide(), 0, 0)
    love.graphics.setColor(love.math.colorFromBytes(rBitValue, gBitValue, bBitValue))
    love.graphics.rectangle('fill', (windowChangeWidth()/2)+0.25*rectangleSide(), (windowChangeHeight()/10), rectangleSide(), rectangleSide(), 0, 0)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(inputButton, (windowChangeWidth()/2)-200, windowChangeHeight()-120)
    love.graphics.print("Input: " .. string.upper(text), (windowChangeWidth()/2)-190, windowChangeHeight()-105)
    love.graphics.print(colorAnswerShown, (windowChangeWidth()/2)-190, windowChangeHeight()-185)
    love.graphics.print("Streak: "..tostring(streak), (windowChangeWidth()/2)-fontScale(), 5)
    love.graphics.draw(colorBorder, (windowChangeWidth()/2-1.25*rectangleSide()), (windowChangeHeight()/10), 0, borderScale())
    love.graphics.draw(colorBorder, (windowChangeWidth()/2)+0.25*rectangleSide(), (windowChangeHeight()/10), 0, borderScale())
    love.graphics.print("Max: "..tostring(maxStreak), 10, 5)
end