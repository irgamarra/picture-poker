local hand = {}
local discards = {}
local coins = 0
local handScriptingZone = ""

function setVariables()
  hand = getHand()
  discards = getDiscards()
  coins = getCoins()
end

function getHand()
  for _, object in ipairs(handScriptingZone.getAllObjects()) do
    if(object.hasTag("Deck")) then
      insert(hand, object)
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
