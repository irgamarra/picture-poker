local hand = {}
local discards = {}
local coins = 0
local handScriptingZone = ""

function setVariables()
  hand = getHand()
  discards = getDiscards()
  coins = getCoins()
end

-- TODO:  Cards that do not belong to Luigi's hand shouldn't get inserted. Right now, they can
function getHand()
  for _, object in ipairs(handScriptingZone.getAllObjects()) do
    if(object.hasTag("Deck")) then
      insert(hand, object)
    end
  end
end

function getCoins()
  coins = 0
  for _, object in ipairs(coinScriptingZone.getAllObjects()) do
    if(object.hasTag("Coin")) then
      coins = coins + 1
    end
    if (object.name == "Coin stack") then
      coins = coins + #object.getAllObjects()
    end
  end
end

function getDiscards()
  for _, object in ipairs(getAllObjects()) do
    if(object.hasTag("Deck")) then
      insert(discards, object)
    end
  end
end

function rateHand()
end

function discardHand()
end
