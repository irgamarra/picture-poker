local copiesOfEachCard = 5
local positionCardClonedOffsetZ = -4

local tableObject = {}
local maxHand = 5
local luigisHandPositions = {}
local luigisHand = {}

function setVariables(params)
    tableObject = params.tableObject
    copiesOfEachCard = params.copiesOfEachCard
    self.call("setLuigisHandPositions")
end
local copiesOfEachCard = 5
local positionCardClonedOffsetZ = -4
local deckBagObject = getObjectFromGUID("12fcbd")

function setVariables(params)
    tableObject = params.tableObject
    copiesOfEachCard = params.copiesOfEachCard
    self.call("setLuigisHandPositions")
end

function buildDeck()
    local positionCardCloned = self.getPosition()
    for _, card in ipairs(self.getObjects()) do
        local cardObject = self.takeObject({guid = card.guid})
        for i = 1, copiesOfEachCard do
            local cardClone = cardObject.clone()
            deckBagObject.putObject(cardClone)
        end
        self.putObject(cardObject)
    end
end

function dealToLuigi()
    for _, position in ipairs(luigisHandPositions) do
        deckBagObject.takeObject({
            position = position,
        })
    end
end

function dealFiveToSeatedPlayers()
    local deckSize = copiesOfEachCard * #self.getObjects()

    function waitForDeckBagObject()
        while #deckBagObject.getObjects() < deckSize do
            coroutine.yield(0)
        end
        for _,playerColor in ipairs(getSeatedPlayers()) do
            deckBagObject.deal(maxHand, playerColor)
        end
        return 1
    end

    startLuaCoroutine(self, "waitForDeckBagObject")
end

function fillHandOfPlayer(player)
    local handsCount = #player.getHandObjects(1)
    local cardsToDeal = maxHand - handsCount
    deckBagObject.deal(cardsToDeal, player.color)
end

function setLuigisHandPositions()
    for _, snapPoint in ipairs(Global.getSnapPoints()) do
        if(snapPoint.tags[1] == "Luigis hand") then
            table.insert(luigisHandPositions, snapPoint.position)
        end
    end
end

function getLuigisHand()
    if(#luigisHand == 0) then
        self.call("setLuigisHand")
    end

    return luigisHand
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

    luigisHand = listOfCards
end

function isObjectInLuigisHand(object)
    for _, position in ipairs(luigisHandPositions) do
        if(object.position == position) then
            return true
        end
    end
    return false
end
