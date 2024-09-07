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
    rhex2 = hex_convert[rhexfactor*16]
    ghex2 = hex_convert[ghexfactor*16]
    bhex2 = hex_convert[bhexfactor*16]
    rhex1 = hex_convert[rhexmain]
    ghex1 = hex_convert[ghexmain]
    bhex1 = hex_convert[bhexmain]
    love.keyboard.setKeyRepeat(true)
    colorAnswer = tostring(rhex1)..tostring(rhex2)..tostring(ghex1)..tostring(ghex2)..tostring(bhex1)..tostring(bhex2)
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

function love.textinput(t)
    text = text .. t
end

function responseToPlayer()
    if response == 1 and text == colorAnswer then
        colorAnswerShown = "Correct"
        createColor()
        response = 0
    elseif response ==1 and text ~= colorAnswer then
        colorAnswerShown = "Wrong: "..tostring(colorAnswer)
        response = 0
        createColor()
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
    love.graphics.setColor(1,1,1)
    --love.graphics.print(tostring(colorAnswer), 40, 400) --shows answer in hexcode under the color
    love.graphics.rectangle('line', 40, 500, 200, 50, 0, 0)
    love.graphics.print("Input: " .. text, 45, 515)
    love.graphics.print(colorAnswerShown, 45, 565)
end