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
    local bucket = zones.coinZones[playerColor]
    
    for i = 1, numberOfCoins do
        local coin = oneCoinBag.takeObject()
        coin.setPosition(bucket.getPosition())
    end 
end

function bet(playerColor)
    local bucket = zones.coinZones[playerColor]
    local betZone = zones.betZones[playerColor]

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

-- function startGameBet(waitForCoinStack)
--     function waitForCoinStack()
--         while
--     end
--     if (waitForCoinsStack) then
--         startLuaCoroutine(self, waitForCoinStack)
--     end
-- end

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