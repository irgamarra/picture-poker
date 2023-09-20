-- https://www.reddit.com/r/tabletopsimulator/comments/m9dtpp/scripting_pawels_super_basic_scripting_guide/

local maxHand = 0
local deckObject = {}
local luigisHandPositions = {}
local luigisHand = {}

function setVariables(maxHand, deckObject)
    self.maxHand = maxHand
    self.deckObject = deckObject
    self.call("setLuigisHandPositions")
end

function dealToLuigi()
    for _, position in ipairs(luigisHandPositions) do
        deckObject.takeObject({
            position = position,
        })
    end
end

function dealFiveToSeatedPlayers()
    for _,playerColor in ipairs(getSeatedPlayers()) do
        deckObject.deal(maxHand, playerColor)
    end
end

function fillHandToSeatedPlayers()
    for _,player in ipairs(getPlayers()) do
        local handsCount = player.getHandCount()
        local cardsToDeal = maxHand - handsCount
        deckObject.deal(cardsToDeal, player.color)
    end
end

function setLuigisHandPositions() do
    for _, snapPoint in ipairs(Global.getSnapPoints()) do
        table.insert(luigisHandPositions, snapPoint.position)
    end
end

function setLuigisHand()
    local listOfCards = {}

    for _, object in ipairs(Global.getObjects()) do
        if(#listOfCards < maxHand) then
            if(self.call("isObjectInLuigisHand",object)) then
                table.insert(listOfCards, object)
            end
        end
    end

    self.luigisHand = listOfCards
end

function isObjectInLuigisHand(object) do
    for _, position in ipairs(luigisHandPositions) do
        if(object.position == position) then
            return true
        end
    end
    return false
end
function getLuigisHand()
    if(#self.luigisHand = 0) then
        self.call("setLuigisHand")
    end

    return self.luigisHand
end
