require "vector"

CardClass = {}

CARD_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
}

function CardClass:new(xPos, yPos, faceUp, counter)
    local card = {}
    local metadata = {__index = CardClass}
    setmetatable(card, metadata)

    card.position = Vector(xPos, yPos)
    card.size = Vector(70, 90)

    card.faceUp = faceUp
    card.grabbable = true
    card.counter = counter

    card.suit = nil
    card.rank = nil
    card.color = nil

    return card
end

function CardClass:update()
    
end

function CardClass:draw()
    width = cards[3].image:getWidth()
    height = cards[3].image:getHeight()

    if self.state ~= CARD_STATE.IDLE and self.grabbable == true and self.faceUp == 1 then
        love.graphics.setColor(0, 0, 0, 0.8) 
        local offset = 18 * (self.state == CARD_STATE.GRABBED and 2 or 1)
        love.graphics.rectangle("fill", self.position.x + offset, (self.position.y - 12) + offset, width + 10, height + 30, 6, 6)
    end

    love.graphics.setColor(1, 1, 1 ,1)

    local cardFace = cards[self.counter]

    if self.faceUp == 0 then
        love.graphics.draw(cardBack, self.position.x, self.position.y, 0, 1.5, 1.5)
    else
        love.graphics.draw(cardFace.image, self.position.x, self.position.y, 0, 1.5, 1.5)
        self.suit = cardFace.suit
        self.rank = cardFace.rank
        self.color = cardFace.color
    end

    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
end

function CardClass:checkForMouseOver()
    if self.state == CARD_STATE.GRABBED then
        return
    end

    local mousePos = grabber.currentMousePos
    local isMouseOver =
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and 
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE

    if self.state == CARD_STATE.MOUSE_OVER then
        if grabber.heldObject and self.faceUp == 1 then
    
            local hasCardOnTop = false
            for _, other in ipairs(cardTable) do
                if other ~= self and
                   other.position.x == self.position.x and
                   other.position.y > self.position.y and
                   (other.position.y - self.position.y) <= 35 and
                   other.faceUp == 1 then
                    hasCardOnTop = true
                    break
                end
            end
    
            if not hasCardOnTop then
                grabber.stackCard = self
            end
        end
    end
end

function CardClass:draw3()
    wasteCards = {}
    local drawX = 740
    local drawY = 50

    for i = #drawPile, #drawPile - 2, -1 do
        if #drawPile == 0 then break end

        if stackTraverse > #drawPile then
            stackTraverse = 1
        end

        local index = drawPile[stackTraverse]
        local newCard = CardClass:new(drawX, drawY, 1, index)
        newCard.grabbable = false
        table.insert(wasteCards, newCard)

        newCard.grabbable = (i == 3 or stackTraverse == #drawPile)

        drawX = drawX - 30
        stackTraverse = stackTraverse + 1
    end
end

-- simple array shuffle :) https://gist.github.com/Uradamus/10323382 
function shuffle()
    for i = #cards, 2, -1 do
        local random = math.random(i)
        cards[i], cards[random] = cards[random], cards[i]
    end
    return cards
end