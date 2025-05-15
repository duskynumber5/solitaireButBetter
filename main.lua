io.stdout:setvbuf("no")

require "card"
require "grabber"
require "gameStart"

function love.load()
    cards = GameClass:cards()
    cardTable = GameClass:cardTable()

    grabber = GrabberClass:new()

    black = {0, 0, 0, 0.7}
    white = {1, 1, 1, 1}
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
    
    for _, card in ipairs(wasteCards) do
        card:checkForMouseOver(grabber)
    end
end

function love.keypressed(key)
    if key == "r" then
        love.load()
    end

    if key == "escape" then
        love.event.quit()
    end
end
