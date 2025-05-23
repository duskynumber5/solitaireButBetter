
require "vector"
require "card"

GrabberClass = {}

function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)

    grabber.previousMousePos = nil
    grabber.currentMousePos = nil

    grabber.grabPos = nil
  
    grabber.heldObject = nil

    grabber.stackCard = nil
    grabber.cardUnder = nil

    return grabber
end

function GrabberClass:update()
    self.currentMousePos = Vector(
        love.mouse.getX(),
        love.mouse.getY()
    )
    
    -- click
    if love.mouse.isDown(1) and self.heldObject then
        self.heldObject.position.x = self.currentMousePos.x - 30
        self.heldObject.position.y = self.currentMousePos.y - 30
        if #self.heldStack > 1 then
            for i, c in ipairs(self.heldStack) do
                if c ~= self.heldObject then
                    c.position.x = self.heldObject.position.x
                    c.position.y = self.heldObject.position.y + (30 * (i-1))
                end
            end
        end
    end
    -- release
    if not love.mouse.isDown(1) and self.grabPos ~= nil then
        self:release()
    end

end

function GrabberClass:grab(card)
    self.grabPos = self.currentMousePos
    self.heldObject = card
    self.heldStack = getStackedCards(card)


    self.heldObject.state = CARD_STATE.GRABBED
    
    self.heldObject.start = Vector(
        self.heldObject.position.x,
        self.heldObject.position.y
    )

    if card.position.y > 50 or card.position.x < 500 then
        for _, c in ipairs(self.heldStack) do
            for i = #cardTable, 1, -1 do
                if cardTable[i] == c then
                    table.remove(cardTable, i)
                end
            end
        end
        
        for _, c in ipairs(self.heldStack) do
            table.insert(cardTable, c)
        end
    end
    
    checkIfCardBelow()
end

function GrabberClass:release()

    if self.heldObject == nil then 
        return
    end
    
    local isValidReleasePosition = false

    if self.stackCard then
        if self.stackCard.position.x < 500 and self.stackCard.position.y == 50 then
            if self.stackCard.suit == self.heldObject.suit and 
            getRankIndex(self.stackCard.rank) == getRankIndex(self.heldObject.rank) - 1 
            and #self.heldStack <= 1 then
                isValidReleasePosition = true
                self.heldObject.position.x = self.stackCard.position.x
                self.heldObject.position.y = self.stackCard.position.y
            else
                isValidReleasePosition = false
            end
        elseif self.stackCard.position.x > 500 and self.stackCard.position.y == 50 then
            isValidReleasePosition = false
        elseif self.stackCard.position.y ~= 50 then
            if self.stackCard.color ~= self.heldObject.color and 
            getRankIndex(self.stackCard.rank) == getRankIndex(self.heldObject.rank) + 1 then
                isValidReleasePosition = true
                self.heldObject.position.x = self.stackCard.position.x
                self.heldObject.position.y = self.stackCard.position.y + 30
                for i, c in ipairs(self.heldStack) do
                    if c ~= self.heldObject then
                        c.position.x = self.heldObject.position.x
                        c.position.y = self.heldObject.position.y + (30 * (i - 1))
                    end
                end
            else
                isValidReleasePosition = false
            end
        else 
            isValidReleasePosition = false
        end
    else 
        isValidReleasePosition = false
    end

    local pos = checkForCardOver()
    if pos and not self.stackCard then
        if pos.y == 50 then
            if self.heldObject.rank == "Ace" then
                isValidReleasePosition = true
                self.heldObject.position.x = pos.x
                self.heldObject.position.y = pos.y
            else
                isValidReleasePosition = false
            end
        else
            if self.heldObject.rank == "King" then
                isValidReleasePosition = true
                self.heldObject.position.x = pos.x
                self.heldObject.position.y = pos.y
                for i, c in ipairs(self.heldStack) do
                    if c ~= self.heldObject then
                        c.position.x = self.heldObject.position.x
                        c.position.y = self.heldObject.position.y + (30 * (i - 1))
                    end
                end
            else
                isValidReleasePosition = false
            end
        end
    end

    if isValidReleasePosition == false then
        self.heldObject.position = self.heldObject.start
        for i, c in ipairs(self.heldStack) do
            if c ~= self.heldObject then
                c.position.x = self.heldObject.position.x
                c.position.y = self.heldObject.position.y + (30 * (i - 1))
            end
        end
    end

    if self.cardUnder and isValidReleasePosition then
        local hasCardOnTop = false
        for _, other in ipairs(cardTable) do
            if other ~= self.cardUnder and other.faceUp == 1 and
               other.position.x == self.cardUnder.position.x and
               other.position.y > self.cardUnder.position.y and
               (other.position.y - self.cardUnder.position.y) <= 35 then
                hasCardOnTop = true
                break
            end
        end
    
        if not hasCardOnTop then
            if self.cardUnder.faceUp == 0 then
                self.cardUnder.faceUp = 1
            end
    
            if self.cardUnder.faceUp == 1 and not self.cardUnder.grabbable then
                self.cardUnder.grabbable = true
            end
        end
    end    

    self.heldObject.state = 0

    self.stackCard = nil
    self.cardUnder = nil
    
    self.heldObject = nil
    self.heldStack = nil
    grabbedStack = {}
    self.grabPos = nil
end

function checkForCardOver()    
    for _, pos in ipairs(validPos) do
        local mousePos = grabber.currentMousePos
        if mousePos.x > pos.x and mousePos.x < pos.x + 70 and
        mousePos.y > pos.y and mousePos.y < pos.y + 90 then
            
            local occupied = false

            for _, card in ipairs(cardTable) do
                if card ~= grabber.heldObject and
                   card.position.x == pos.x and
                   card.position.y == pos.y then
                    occupied = true
                    break
                end
            end

            if not occupied then
                return pos
            end
        end
    end
    return nil
end

function checkIfCardBelow()
    grabber.cardUnder = nil
    for _, c in ipairs(cardTable) do
        if c ~= grabber.heldObject and
        math.abs(c.position.x - grabber.heldObject.position.x) < 5 and
        math.abs(c.position.y - grabber.heldObject.position.y + 30) <= 5 then
            grabber.cardUnder = c
            break
        end
    end
end

function getStackedCards(card)
    grabbedStack = {}
    table.insert(grabbedStack, card)

    local currentY = card.position.y
    local x = card.position.x

    while true do
        local found = nil
        for _, other in ipairs(cardTable) do
            if other ~= card and
               other.position.x == x and
               math.abs(other.position.y - currentY - 30) <= 5 and
               other.faceUp == 1 then
                found = other
                break
            end
        end

        if found then
            table.insert(grabbedStack, found)
            currentY = found.position.y
            card = found
        else
            break
        end
    end

    return grabbedStack
end

function getRankIndex(rank)
    for i, r in ipairs(ranks) do
        if r == rank then return i end
    end
    return nil
end