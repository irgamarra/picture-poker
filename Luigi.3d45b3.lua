local hand = {}
local maxHand = 5
local discardAnimationSeconds = 1
local dealToLuigiWaitSeconds = 1

local gameObjects = {}
local zones = {}

local coins = 0

local cardsTag = "Poker card"
local coinTag = "Coin"
local coinStackName = "Coin stack"

function setVariables(params)
    gameObjects = params.gameObjects
    zones = params.zones
    maxHand = params.maxHand
end

function playTurn()
    local dealToLuigi = function() gameObjects.bagOfCards.call("dealToLuigi") end
    Wait.time( dealToLuigi, dealToLuigiWaitSeconds)
    waitForHand(discardPhase)  
    -- TODO: rateHandsPhase()
end

function discardPhase()
    local cardsToDiscard = decideDiscards()

    local waitSecondsForEachFunction = discardAnimationSeconds
    local cardsDiscardedPositions = discardCards(cardsToDiscard, waitSecondsForEachFunction)
    
    waitSecondsForEachFunction = waitSecondsForEachFunction * #cardsToDiscard
    refillHand(cardsDiscardedPositions, waitSecondsForEachFunction)
    
    waitSecondsForEachFunction = waitSecondsForEachFunction + 1
    rateHandsPhase(waitSecondsForEachFunction)
end

function rateHandsPhase(waitSeconds)
    local waitSecondsForEachFunction = gameObjects.tableObject.call("exchangeBets", waitSeconds)
    
    -- TODO: gameObjects.tableObject.getLuigisCoins()
    --getCoins()
    -- TODO: gameObjects.tableObject.winLoseCondition() ??
    if(coins == 0) then
        lose()
    end
end

-- TODO:  Cards that do not belong to Luigi's hand shouldn't get inserted. Right now, they can
-- TODO: Should we use gameObjects.tableObject.getLuigisHand() ??
function waitForHand(func)
    function innerCoroutine()
        while #zones.luigisHand.getObjects() < maxHand do
            coroutine.yield(0)
        end
        
        getHand()
        func()

        return 1
    end
    startLuaCoroutine(self, "innerCoroutine")
    
end

function getHand()
    hand = {}
    for _, object in ipairs(zones.luigisHand.getObjects()) do
        
        if(object.hasTag(cardsTag)) then
            table.insert(hand,object)
        end
    end
    return hand
end
-- TODO: gameObjects.tableObject.getLuigisCoins()
function getCoins()
    coins = 0
    for _, object in ipairs(zones.luigisCoins.getObjects()) do
        coins = coin + getCoinNumber(object)
    end
    return coins
end

function getCoinNumber(coin)
    if(coin.hasTag(coinTag)) then
        return 1
    end
    if (coin.name == coinStackName) then
        return #object.getObjects()
    end
    return 0
end

-- TODO: put this function inside Table
function getCardsOnTable()
    return getObjectsWithTag(cardsTag)
end

function decideDiscards()
    local discards = {}
    local cardMatches = getDictOfCardMatches()
    
    for valueOfCard, cardsCount in pairs(cardMatches) do
        if(cardsCount == 1) then
            local cardWithoutMatches = getCardsFromValue(valueOfCard)[1]
            table.insert(discards, cardWithoutMatches)
        end
    end
    return discards
end

-- index = valueOfCard, value = numberOfSimilarCards
function getDictOfCardMatches()
    local cardMatches = {}
    
    for index, card in ipairs(hand) do
        local valueOfCard = tostring(getValueOfCard(card))
        
        if(cardMatches[valueOfCard] == nil) then
            cardMatches[valueOfCard] = 1
        end
        cardMatches[valueOfCard] = cardMatches[valueOfCard] + getCardMatchesToTheRight(card, index)
        
    end
    return cardMatches
end

function getValueOfCard(card)
    return card.getName():sub(1, 1) -- TODO: Does it work?
end 

function getCardMatchesToTheRight(card, outerIndex)  
  local numberOfMatches = 0
  
  for innerIndex, cardToMatch in ipairs(hand) do
        if(innerIndex > outerIndex) then
        numberOfMatches = numberOfMatches + cardMatched(cardToMatch, card)
        end
  end
  
  return numberOfMatches
end

-- TODO: put this function in the object Table
function cardMatched(card, cardToMatch)
    if(cardToMatch.getName() == card.getName()) then
        return 1
    end
    return 0
end

function getCardsFromValue(value)
    local cards = {}
    for index,card in ipairs(hand) do
        if(getValueOfCard(card) == value) then
        table.insert(cards,card)
        end
    end
    return cards
end

function discardCards(cards, waitSeconds)
    if(cards == nil) then
        return nil
    end
    
    local cardsDiscardedPositions = {}

    local waitSecondsForEachDiscard = waitSeconds
    for _, card in ipairs(cards) do
        
        local discard = function () 
            table.insert(cardsDiscardedPositions, card.getPosition()) 
            card.setPositionSmooth(zones.discardZone.getPosition(), false, false) 
        end

        waitSecondsForEachDiscard = waitSecondsForEachDiscard + waitSeconds
        Wait.time(discard, waitSecondsForEachDiscard)
    end
    
    -- local refillHand = function () gameObjects.bagOfCards.call("dealToLuigi", cardsDiscardedPositions) end
    -- Wait.time(refillHand, waitSecondsForEachDiscard)

    return cardsDiscardedPositions
end

function refillHand(cardsDiscardedPositions, waitSeconds)
    local refillHand = function () gameObjects.bagOfCards.call("dealToLuigi", cardsDiscardedPositions) end
    Wait.time(refillHand, waitSeconds)
end

function lose()
end
