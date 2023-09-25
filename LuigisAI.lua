local hand = {}
local cardsOnTable = {}
local coins = 0
local handScriptingZone = ""
local coinScriptingZone = ""

function playTurn()
  setVariables()
  local cardsToDiscard = decideDiscards()
  discardHand(cardsToDiscard)
  
  table.exchangeBets()

  -- TODO: Table should do lose/win conditions, maybe??
  getCoins()
  if(coins == 0) then
    lose()
  end
  
end

function setVariables()
  hand = getHand()
  cardsOnTable = getCardsOnTable()
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

function getCardsOnTable()
  for _, object in ipairs(getAllObjects()) do
    if(object.hasTag("Deck")) then
      insert(cardsOnTable, object)
    end
  end
end

function rateHand()
    local cardMatches = getCardMatches()
    
    -- pair
    
    -- trio
    -- pair + trio
    -- 4 of a kind
    -- 5 of a kind
end

function getCardMatches()
  local cardMatches = {}
  for cardToMatchIndex = 1, #hand do
    local cardToMatch = hand[cardToMatchIndex]
    
    for cardIndex, card in ipairs(hand) do
      if(cardIndex > cardToMatchIndex) then
        if(card.getName() == cardToMatch.getName()) then
            local valueOfCard = card.getName()[1] -- TODO: Does it work?

        end
      end
    end
      
  end
  return cardMatches{}
end

function discardHand(cards)
    if(cards == nil) then
      return false
    end

    rateHand()
end

function lose()
end
