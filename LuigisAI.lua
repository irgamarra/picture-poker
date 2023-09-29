local hand = {}
local bagObject = {}
local tableObject = {}

-- local zones = "" -- object for all zones
local handScriptingZone = "" -- zones.luigisHand
local coinScriptingZone = "" -- zones.coins
local discardZone = "" -- zones.discard

local cardsOnTable = {}
local coins = 0

local cardsTag = "Deck"
local coinTag = "Coin"
local coinStackName = "Coin stack"

function setVariables(params)
  bagObject = params.bagObject
  discardZone = params.discardZone
  tableObject = params.tableObject
  
  hand = getHand()
  cardsOnTable = getCardsOnTable()
  coins = getCoins()
end

function playTurn()
  setVariables({bagObject = bagObject})
  local cardsToDiscard = decideDiscards()
  discardHand(cardsToDiscard)
  -- TODO: tableObject.refillHand()
  
  tableObject.exchangeBets()

  -- TODO: tableObject.getLuigisCoins()
  getCoins()
  -- TODO: tableObject.winLoseCondition() ??
  if(coins == 0) then
    lose()
  end
  
end

-- TODO:  Cards that do not belong to Luigi's hand shouldn't get inserted. Right now, they can
-- TODO: Should we use tableObject.getLuigisHand() ??
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

-- TODO: tableObject.getLuigisCoins()
function getCoins()
  coins = 0
  for _, object in ipairs(coinScriptingZone.getAllObjects()) do
    coins = coin + getCoinNumber(object)
  end
  return coins
end

function getCoinNumber(coin)
  if(coin.hasTag(coinTag)) then
    return 1
  end
  if (coin.name == coinStackName) then
    return #object.getAllObjects()
  end
  return 0
end

-- TODO: put this function inside Table
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
    cardMatches[valueOfCard] = cardMatches[valueOfCard] + getCardMatchesToTheRight(card, index)
  end
  return cardMatches
end

function getValueOfCard(card)
  return card.getName():sub(1, 1) -- TODO: Does it work?
end 

function getCardMatchesToTheRight(card, outerIndex)  
  local numberOfMatches = 0
  
  for innerIndex, cardToMatch in ipairs(hand) do
    if(innerIndex > outerIndex) then
      numberOfMatches = numberOfMatches + cardMatched(cardToMatch, card)
    end
  end
  
  return numberOfMatches
end

-- TODO: put this function in the object Table
function cardMatched(card, cardToMatch)
  if(cardToMatch.getName() == card.getName()) then
      return 1
  end
  return 0
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
    card.setPositionSmooth(discardZone.getPosition(), false, false)
  end
end

function lose()
end
