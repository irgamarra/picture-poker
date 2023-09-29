local hand = {}
-- Should we use bag.getLuigisHand() ??
local bagObject = {}
local cardsOnTable = {}
local coins = 0
local handScriptingZone = ""
local coinScriptingZone = ""
local cardsTag = "Deck"
local coinTag = "Coin"
local coinStackName = "Coin stack"
local discardZone = ""

function playTurn()
  setVariables({bagObject = bagObject})
  local cardsToDiscard = decideDiscards()
  discardHand(cardsToDiscard)
  -- refillHand()
  
  table.exchangeBets()

  -- TODO: Table should do lose/win conditions, maybe??
  getCoins()
  if(coins == 0) then
    lose()
  end
  
end

-- TODO: Should this function be one loop?
function setVariables(params)
  params.bagObject = bagObject
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
  -- return bagObject.getLuigisHand() ??
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
  
  for valueOfCard, cardsCount in pairs(cardMatches) do
    if(cardsCount == 1) then
      local cardWithoutMatches = getCardsFromValue(valueOfCard)[1]
      insert(discards, cardWithoutMatches)
    end
  end
  return discards
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

function getCardsFromValue(value)
  local cards = {}
  for index,card in ipairs(hand) do
    if(getValueOfCard(card) == value) then
      insert(cards,card)
    end
  end
  return cards
end

function discardHand(cards)
  if(cards == nil) then
    return false
  end
  for _, card in ipairs(cards) do
    card.setPositionSmoot(discardZone.getPosition(), false, false)
  end
end

function lose()
end
