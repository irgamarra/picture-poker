local startingCoins = 10
local copiesOfEachCard = 5
local maxHand = 5

local tagForCards = "Poker card"
local bagGUID = "a0ed74"
local luigiGUID = "3d45b3"
local turnGUID = "752e64"
local tableGUID = "a1b071"
local discardZoneGUID = "670a2b"

local zones = {
    luigisHand = {},
    luigisCoins = {},
    discardZone = {},
}

local gameObjects = {
    bagOfCards = {},
    luigi = {},
    turn = {},
    table = {}
}

local discardCount = 0

function onLoad()
    getGameObjects() 
    getZones()
    setVariablesOfGameObjects()
end

function getGameObjects()
    gameObjects.bagOfCards = getObjectFromGUID(bagGUID)
    gameObjects.luigi = getObjectFromGUID(luigiGUID)
    gameObjects.turn = getObjectFromGUID(turnGUID)
    gameObjects.table = getObjectFromGUID(tableGUID)
end

function getZones()
    zones.luigisHand = getObjectFromGUID('116688')
    zones.discardZone = getObjectFromGUID(discardZoneGUID)
end
function setVariablesOfGameObjects()
    local params = {
        startingCoins = startingCoins,
        tableObject = gameObjects.table,
        copiesOfEachCard = copiesOfEachCard,
        zones = zones,
        gameObjects = gameObjects,
        maxHand = maxHand,
    }
    gameObjects.turn.call("setVariables", bagGUID)
    gameObjects.bagOfCards.call("setVariables", params)
    gameObjects.luigi.call("setVariables", params)
end

function startButton()
    gameObjects.table.call("deleteAllCards", tagForCards)
    gameObjects.table.call("deleteAllCoins")
    gameObjects.bagOfCards.call("buildDeck")
    gameObjects.table.call("giveCoinsToAll", startingCoins)
    gameObjects.bagOfCards.call("dealFiveToSeatedPlayers")
    --self.UI.show("Discard")
    visibilityToAllSeatedColors()
end

function nextTurn()
    gameObjects.table.call("deleteAllCards", tagForCards)
    gameObjects.bagOfCards.call("buildDeck")
    gameObjects.bagOfCards.call("dealFiveToSeatedPlayers")
    visibilityToAllSeatedColors()
end

function discard(player_clicker)
    hideVisibilityForColor(player_clicker.color)
    discardCount = discardCount + 1
    gameObjects.bagOfCards.call("fillHandOfPlayer", player_clicker)

    if(discardCount == #getSeatedPlayers()) then
        gameObjects.luigi.call("playTurn")
        discardCount = 0
    end
end

function visibilityToAllSeatedColors()
    local visibility = ""
    for _, playerColor in ipairs(getSeatedPlayers()) do
        visibility = visibility .. "|" .. playerColor
    end
    UI.setAttribute("Discard", "visibility", visibility)
end

function hideVisibilityForColor(playerColor)
    local currentVisibility = self.UI.getAttribute("Discard", "visibility")
    local colors = currentVisibility:split("|")
    local newVisibility = ""

    for _, color in ipairs(colors) do
        if color ~= playerColor then
            if newVisibility ~= "" then
                newVisibility = newVisibility .. "|"
            end
            newVisibility = newVisibility .. color
        end
    end
    if(newVisibility == "") then
        newVisibility = "0"
    end
    UI.setAttribute("Discard", "visibility", newVisibility)
end

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end