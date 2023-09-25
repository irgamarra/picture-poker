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

-- TODO: Should this function be one loop?
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
  local cardMatches = getDictOfCardMatches() -- index = valueOfCard, value = numberOfMatches
  local cardsWithoutMatches = {}
  
  for valueOfCard, numberOfMatches in pairs(cardMatches) do
    if(numberOfMatches == 1) then
      local cardWithoutMatches = getCardsFromValue(hand, valueOfCard)[1]
      insert(discards, cardsWithoutMatches)
    end
  end

  for _, card in ipairs(hand) do
    if(getValueOfCard(card) == ) then 
    end
  end
  rateHand(cardMatches)

  
end

function getDictOfCardMatches()
  local cardMatches = {}
  for cardToMatchIndex, cardToMatch, ipairs(hand) do
    for cardIndex, card in ipairs(hand) do
      if(cardIndex > cardToMatchIndex) then
        if(card.getName() == cardToMatch.getName()) then
          local valueOfCard = getValueOfCard(card)
          cardMatches = fillCardMatches(cardMatches, valueOfCard)
        end
      end
    end
  end
  return cardMatches
end

function getCardsFromValue(hand, value)
  local cards = {}
  for index,card in ipairs(hand) do
    if(getValueOfCard(card) == value) then
      insert(cards,card)
    end
  end
  return cards
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

function getValueOfCard(card)
  return card.getName()[1] -- TODO: Does it work?
end 
function fillCardMatches(cardMatches, valueOfCard)
  cardMatches = tonumber(cardMatches)
  valueOfCard = tostring(valueOfCard)
  
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
