local hand = {}
local cardsOnTable = {}
local coins = 0
local handScriptingZone = ""
local coinScriptingZone = ""
local cardsTag = "Deck"
local coinTag = "Coin"
local coinStackName = "Coin stack"

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
  hand = {}
  for _, object in ipairs(handScriptingZone.getAllObjects()) do
    if(object.hasTag(cardsTag)) then
      insert(hand, object)
    end
  end
  return hand
end

function getCoins()
  coins = 0
  for _, object in ipairs(coinScriptingZone.getAllObjects()) do
    coins = coin + getCoinNumber(object)
  end
  return coins
end

function getCoinNumber(object)
  if(object.hasTag(coinTag)) then
    return 1
  end
  if (object.name == coinStackName) then
    return #object.getAllObjects()
  end
  return 0
end

function getCardsOnTable()
  cardOnTable = {}
  for _, object in ipairs(getAllObjects()) do
    if(object.hasTag(cardsTag)) then
      insert(cardsOnTable, object)
    end
  end
  return cardsOnTable
end

function decideDiscards()
  local discards = {}
  local cardMatches = getDictOfCardMatches()
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

-- index = valueOfCard, value = numberOfSimilarCards
function getDictOfCardMatches()
  local cardMatches = {}
  for index, card in ipairs(hand) do
    local valueOfCard = tostring(getValueOfCard(card))

    if(cardMatches[valueOfCard] == nil) then
      cardMatches[valueOfCard] = 1
    end
    cardMatches[valueOfCard] = cardMatches[valueOfCard] + getCardMatches(card, index)
  end
  return cardMatches
end

function getValueOfCard(card)
  return card.getName():sub(1, 1) -- TODO: Does it work?
end 

function getCardMatches(card, index)  
  local numberOfMatches = 0
  
  for indexToMatch, cardToMatch in ipairs(hand) do
    if(indexToMatch > index and cardToMatch.getName() == card.getName()) then
      numberOfMatches = numberOfMatches + 1
    end
  end
  
  return numberOfMatches
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


function discardHand(cards)
    if(cards == nil) then
      return false
    end

    rateHand()
end

function lose()
end
