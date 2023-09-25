local hand = {}
local cardsOnTable = {}
local coins = 0
local handScriptingZone = ""
local coinScriptingZone = ""
local cardsTag = "Deck"

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
    if(object.hasTag(cardsTag)) then
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
    if(object.hasTag(cardsTag)) then
      insert(cardsOnTable, object)
    end
  end
end

function decideDiscards()
  local discards = {}
  local cardMatches = getCardMatches() -- index = valueOfCard, value = numberOfMatches
  local cardsWithoutMatches = {}
  
  for valueOfCard, numberOfMatches in pairs(cardMatches) do
    if(numberOfMatches == 1) then
      insert(cardsWithoutMatches, valueOfCard)
    end
  end

  for _, card in ipairs(hand) do
    if(card.getName(1)) then 
    end
  end
  rateHand(cardMatches)

  
end

function rateHand(cardMatches)
  for valueOfCard, numberOfMatches in pairs(cardMatches) do
  
  end
    -- 1 = pair
    
    -- 2 = trio
    -- 3 = pair + trio
    -- 4 = 4 of a kind
    -- 5 = 5 of a kind
end

function getCardMatches()
  local cardMatches = {}
  for cardToMatchIndex = 1, #hand do
    local cardToMatch = hand[cardToMatchIndex]
    
    for cardIndex, card in ipairs(hand) do
      if(cardIndex > cardToMatchIndex) then
        if(card.getName() == cardToMatch.getName()) then
          local valueOfCard = card.getName()[1] -- TODO: Does it work?
          cardMatches = fillCardMatches({cardMatches = cardMatches, valueOfCard = card.getName()[valueOfCard]})
        end
      end
    end
  end
  return cardMatches
end

function getValueOfCard(card)

end
function fillCardMatches(params)
  local cardMatches = tonumber(params.cardMatches)
  local valueOfCard = tostring(params.valueOfCard)
  
  if(cardMatches[valueOfCard] == nil)
    cardMatches[valueOfCard] = 1 
    return cardMatches
  end
  
  cardMatches[valueOfCard] = cardMatches[valueOfCard] + 1
  return cardMatches
end

function discardHand(cards)
    if(cards == nil) then
      return false
    end

    rateHand()
end

function lose()
end
