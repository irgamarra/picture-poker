local oneCoinBag = getObjectFromGUID("49a549")
local deckBagObject = getObjectFromGUID("12fcbd")
local zones = {}

function setVariables(params)
    zones = params.zones
end

function deleteAllCards(tag)
    for _, object in pairs(getAllObjects()) do
        if object.hasTag(tag) or object.tag == "Deck" then
            object.destroy()
        end
    end
    
    for _, object in ipairs(deckBagObject.getObjects()) do
        object = deckBagObject.takeObject(object)
        object.destroy()
    end
end

function deleteAllCoins()
    for _, object in pairs(getAllObjects()) do
        if( string.match(object.getName(), "^x.*Coin$")
        ) then
            object.destroy()
        end
    end
end

function giveCoinsToAll(number)
    for _, player in ipairs(Player.getPlayers()) do
        giveCoinsToPlayer(player.color, number)
    end
end

function giveCoinsToPlayer(playerColor, numberOfCoins)
    local bucket = getObjectFromGUID(zones.coinZonesGUID[playerColor])
    
    for i = 1, numberOfCoins do
        local coin = oneCoinBag.takeObject()
        coin.setPosition(bucket.getPosition())
    end 
end

function bet(playerColor)
    local bucket = getObjectFromGUID(zones.coinZonesGUID[playerColor])
    local betZone = getObjectFromGUID(zones.betZonesGUID[playerColor])

    for _, object in ipairs(bucket.getObjects()) do
        
        -- TODO: move stack or unit function
        if(object.name == "Custom_Token_Stack") then
            object.takeObject({
                position = betZone.getPosition()
            })
        end
        if(object.name == "Custom_Token") then
            object.setPositionSmooth(betZone.getPosition(), false, false) 
        end
    end
end
-- TODO: delete waitSeconds as parameter
function exchangeBets(waitSeconds)
    for playerColor, betZoneGUID in pairs(zones.betZonesGUID) do
        local coinZoneGUID = zones.coinZonesGUID[playerColor]
        local playerHandGUID = zones.playersHandsGUID[playerColor]
        local coinZone = getObjectFromGUID(coinZoneGUID)
        local playerHand = getObjectFromGUID(playerHandGUID)
        local betZone = getObjectFromGUID(betZoneGUID)
        
        local winnerHand = getBestHand(luigisHand,playerHand))
    end
end

-- TODO: Hand class
function getBestHand(hand1,hand2)
    local rateHand1 = getRate(hand1)
    local rateHand2 = getRate(hand2)
    print(rateHand1.bestSingleCard)
    print(rateHand2.bestSingleCard)
    if(rateHand1.matchRate > rateHand2.matchRate)then
        return hand1
    end
    if(rateHand1.matchRate < rateHand2.matchRate) then
        return hand2
    end
    if(rateHand1.matchRate == rateHand2.matchRate) then
        if(rateHand1.bestMatchCardValue > rateHand2.bestMatchCardValue) then
            return hand1
        end
        if(rateHand1.bestMatchCardValue < rateHand2.bestMatchCardValue) then
            return hand2
        end
        if(rateHand1.bestMatchCardValue == rateHand2.bestMatchCardValue) then
            if(rateHand1.worstPairCardValue > rateHand2.worstPairCardValue) then
                return hand1
            end
            if(rateHand1.worstPairCardValue < rateHand2.worstPairCardValue) then
                return hand2
            end
            if(rateHand1.worstPairCardValue == rateHand2.worstPairCardValue) then
                if(rateHand1.bestSingleCard > rateHand2.bestSingeCard) then
                    return hand1
                end
                if(rateHand1.bestSingleCard < rateHand2.bestSingleCard) then
                    return hand2
                end
                if(rateHand1.bestSingleCard == rateHand2.bestSingleCard) then
                    return nil
                end
            end
        end
    end
end


-- TODO: TOO COMPLEX
function getRate(hand)
    local rate = {matchRate = 0, bestMatchCardValue = 0, worstPairCardValue = 0, bestSingleCard = 0}
    local cardMatches = getDictOfCardMatches(hand)
    
    local isDoubleMatch = false
    for valueOfCard, numberOfSimilarCards in pairs(cardMatches) do
        if(numberOfSimilarCards < 1) then
            if(valueOfCard > rate.bestSingleCard) then
                rate.bestSingleCard = valueOfCard
            end
        else
            if(rate.matchRate == 0) then
                rate.matchRate = numberOfSimilarCards
            else 
                rate.matchRate = rate.matchRate + 0.5
                isDoubleMatch = true
            end

            if(isDoubleMatch) then
                if(numberOfSimilarCards == 3) then
                    rate.worstPairCardValue = rate.bestMatchCardValue
                    rate.worstPairCardValue = valueOfCard
                elseif(rate.bestMatchCardValue >= valueOfCard) then
                    rate.worstPairCardValue = valueOfCard
                else
                    rate.worstPairCardValue = rate.bestMatchCardValue 
                    rate.bestMatchCardValue = valueOfCard
                end
            else
                rate.bestMatchCardValue = valueOfCard
            end
        end
            
    end

    return rate
end


-- index = valueOfCard, value = numberOfSimilarCards
function getDictOfCardMatches(hand)
    local cardMatches = {}
    
    for index, card in ipairs(hand) do
        local valueOfCard = tostring(getValueOfCard(card))
        
        if(cardMatches[valueOfCard] == nil) then
            cardMatches[valueOfCard] = 1
        end
        cardMatches[valueOfCard] = cardMatches[valueOfCard] + getCardMatchesToTheRight(hand, card, index)
        
    end
    return cardMatches
end

function getCardMatchesToTheRight(hand, card, outerIndex)  
  local numberOfMatches = 0
  
  for innerIndex, cardToMatch in ipairs(hand) do
        if(innerIndex > outerIndex) then
        numberOfMatches = numberOfMatches + cardMatched(cardToMatch, card)
        end
  end
  
  return numberOfMatches
end

function cardMatched(card, cardToMatch)
    if(cardToMatch.getName() == card.getName()) then
        return 1
    end
    return 0
end

function getValueOfCard(card)
    return card.getName():sub(1, 1)
end 

function stackObjects(params)
    function coinside()
        waitFrames(1)
        for i = 1, params.numberOfObjects do
            params.positionToSpawn.y = params.positionToSpawn.y + 0
            local objectCloned = params.object.clone({
                position = params.positionToSpawn
            })
        end
        return 1
    end
    startLuaCoroutine(self, "coinside")
end

function waitFrames(frames) 
    while frames > 0 do 
        coroutine.yield(0)
        frames = frames - 1 
    end
end
