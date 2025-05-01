io.stdout:setvbuf("no")

require "card"
require "grabber"
require "gameStart"

function love.load()
    cards = GameClass:cards()
    cardTable = GameClass:cardTable()

    grabber = GrabberClass:new()
end

function love.update()
    checkForMouseMoving()

    GameClass:update()

end

function love.draw()
   GameClass:draw()
end

function checkForMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, card in ipairs(cardTable) do
        card:checkForMouseOver(grabber)
    end
    
    for _, card in ipairs(drawCards) do
        card:checkForMouseOver(grabber)
    end
end
