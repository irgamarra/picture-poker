local oneCoinBag = getObjectFromGUID("49a549")
local deckBagObject = getObjectFromGUID("12fcbd")

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
    local bucketTag = playerColor .. " coins bucket"
    
    for _, object in pairs(getAllObjects()) do
        
        if object.getName() == bucketTag then
            for i = 1, numberOfCoins do
                local coin = oneCoinBag.takeObject()
                coin.setPosition(object.getPosition())
            end             
        end

    end
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