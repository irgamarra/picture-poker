local startingCoins = 10
local copiesOfEachCard = 5
local maxHand = 5

local buttonDiscardID = "Discard"
local buttonBetID = "Bet"

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
    betZonesGUID = {},
    coinZonesGUID = {},
}

local betZonesGUID = {
    White = "e4b599",
}
local coinZonesGUID = {
    White = "e2380e"
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
    zones.betZonesGUID = betZonesGUID
    zones.coinZonesGUID = coinZonesGUID
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
    
    -- TODO: Make it work
    -- for key,gameObject in ipairs(gameObjects) do
    --     gameObject.call("setVariables", params)
    -- end

    gameObjects.bagOfCards.call("setVariables", params)
    gameObjects.luigi.call("setVariables", params)
    gameObjects.table.call("setVariables", params)
end

function startButton()
    gameObjects.table.call("deleteAllCards", tagForCards)
    gameObjects.table.call("deleteAllCoins")
    gameObjects.bagOfCards.call("buildDeck")
    gameObjects.table.call("giveCoinsToAll", startingCoins)
    gameObjects.bagOfCards.call("dealFiveToSeatedPlayers")
    --gameObjects.table.call("startGameBet", true)
    
    UIVisibilityToAllSeatedColors(buttonDiscardID)
    UIVisibilityToAllSeatedColors(buttonBetID)
end

function nextTurn()
    gameObjects.table.call("deleteAllCards", tagForCards)
    gameObjects.bagOfCards.call("buildDeck")
    gameObjects.bagOfCards.call("dealFiveToSeatedPlayers")
    UIVisibilityToAllSeatedColors(buttonDiscardID)
end

function discard(player_clicker)
    local betZone = getObjectFromGUID(zones.betZonesGUID[player_clicker.color])
    if(#betZone.getObjects() < 1) then
        print(player_clicker.color.." please make a bet first")
        return false
    end
    hideUIVisibilityForColor(player_clicker.color, buttonDiscardID)
    hideUIVisibilityForColor(player_clicker.color, buttonBetID)
    discardCount = discardCount + 1
    gameObjects.bagOfCards.call("fillHandOfPlayer", player_clicker)

    if(discardCount == #getSeatedPlayers()) then
        gameObjects.luigi.call("playTurn")
        discardCount = 0
    end

    return true
end

function bet(player_clicker)
    gameObjects.table.call("bet", player_clicker.color)
end

function UIVisibilityToAllSeatedColors(id)
    local visibility = ""
    for _, playerColor in ipairs(getSeatedPlayers()) do
        visibility = visibility .. "|" .. playerColor
    end
    UI.setAttribute(id, "visibility", visibility)
end

function hideUIVisibilityForColor(playerColor, id)
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
    UI.setAttribute(id, "visibility", newVisibility)
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