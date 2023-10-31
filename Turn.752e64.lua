local bagObject

function setVariables(bag)
    bagObject = bag
end

function turn()
    bagObject.call("draw")
    self.call("waitForDiscards")
    self.call("waitForBets")
    -- Luigi's turn
    self.call("exchangeMoney")
    
    self.call("lose")
    -- if Luigi.loses then
    self.call("win")
    -- end
end

function waitForDiscards()
end

function waitForBets()
end

function exchangeMoney()
end

function win()
    --ui with restart button
end

function lose()
end