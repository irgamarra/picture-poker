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
        
        if(luigiWins(zones.LuigisHand, playerHand)) then

        end
    end
end

function luigiWins(luigisHand, playerHand) 
    
    if(rateHand(luigisHand) > rateHand(playerHand)) then
        return true
    end
    return false
end

-- TODO: To move hand functions to a Hand class
function getMatchRate(hand)
    local rate = {}
    local cardMatches = getDictOfCardMatches(hand)
    
    local matchRate = 0
    
    for valueOfCard, numberOfSimilarCards in pairs(cardMatches) do
        numberOfSimilarCards = numberOfSimilarCards - 1
        if(matchRate == 0) then
            matchRate = numberOfSimilarCards
        else 
            matchRate = matchRate + 0.5
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
