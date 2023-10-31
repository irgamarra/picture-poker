-- TODO: TOO COMPLEX
function getBestHand(hand1,hand2)
    local rateHand1 = getRate(hand1)
    local rateHand2 = getRate(hand2)
    print(rateHand1.bestSingleCard)
    print(rateHand2.bestSingleCard)

  local bestValue = whichIsBest(rateHand1.matchRate, rateHand2.matchRate)
  if (bestValue == 0) then
    bestValue = whichIsBest(rateHand1.bestMatchCardValue, rateHand2.bestMatchCardValue)
    if(bestValue == 0) then
      bestValue = whichIsBest(rateHand1.worstPairCardValue, rateHand2.worstPairCardValue)
      if(bestValue == 0) then
        bestValue = whichIsBest(rateHand1.bestSinglePair, rateHand2.bestSinglePair)
      end
    end
  end

  if(bestValue == 1) then return hand1 end
  if(bestValue == 2) then return hand2 end
  if(bestValue == 3) then return nil end
end
-- TODO: TOO COMPLEX
function getRate(hand)
    local rate = {matchRate = 0, bestMatchCardValue = 0, worstPairCardValue = -1, bestSingleCard = 0}
    local cardMatches = getDictOfCardMatches(hand)
    log(cardMatches)
    local isDoubleMatch = false
    for card, matches in pairs(cardMatches) do
        card = tonumber(card)
        matches = tonumber(matches)

        if(matches > 1) then
            rate.matchRate = getMatchRate(rate.matchRate, matches)

            if(isDoubleMatch) then
                if(matches == 3) then
                    rate.worstPairCardValue = rate.bestMatchCardValue
                    rate.worstPairCardValue = card
                elseif(rate.bestMatchCardValue >= card) then
                    rate.worstPairCardValue = card
                else
                    rate.worstPairCardValue = rate.bestMatchCardValue 
                    rate.bestMatchCardValue = card
                end
            else
                rate.bestMatchCardValue = card
                isDoubleMatch = true
            end
        else
            if(card > rate.bestSingleCard) then
                rate.bestSingleCard = card
            end
        end
            
    end

    return rate
end

function whichIsBest(value1,value2)
  if(value1 > value2) then
      return 1
  end
  if(value1 < value2) then
      return 2
  end
  if(value1 == value2) then
      return 0
  end
end

-- function getBestPair(hand1,hand2)
--   if(rateHand1.worstPairCardValue > rateHand2.worstPairCardValue) then
--       return hand1
--   end
--   if(rateHand1.worstPairCardValue < rateHand2.worstPairCardValue) then
--       return hand2
--   end
--   if(rateHand1.worstPairCardValue == rateHand2.worstPairCardValue) then
--       getBestSingleCard(hand1,hand2)
--   end
-- end
-- function getBestSingleCard(hand1,hand2)
--   if(rateHand1.bestSingleCard > rateHand2.bestSingeCard) then
--     return hand1
--   end
--   if(rateHand1.bestSingleCard < rateHand2.bestSingleCard) then
--     return hand2
--   end
--   if(rateHand1.bestSingleCard == rateHand2.bestSingleCard) then
--     return nil
--   end
-- end

function getMatchRate(matchRate, numberOfSimilarCards)
  if(matchRate == 0) then
      return numberOfSimilarCards
  else 
      return matchRate + 0.5
  end
end
function getDictOfCardMatches(hand)
    local cardMatches = {}
    
    for index, card in ipairs(hand) do
        local valueOfCard = tostring(getValueOfCard(card))
        
        if(cardMatches[valueOfCard] == nil) then
            cardMatches[valueOfCard] = 1
        end
        cardMatches[valueOfCard] = cardMatches[valueOfCard] + getCardMatchesToTheRight(hand, card, index)
        
    end
    return cardMatches
end

function getCardMatchesToTheRight(hand, card, outerIndex)  
  local numberOfMatches = 0
  
  for innerIndex, cardToMatch in ipairs(hand) do
        if(innerIndex > outerIndex) then
        numberOfMatches = numberOfMatches + cardMatched(cardToMatch, card)
        end
  end
  
  return numberOfMatches
end

function cardMatched(card, cardToMatch)
    if(cardToMatch.getName() == card.getName()) then
        return 1
    end
    return 0
end

function getValueOfCard(card)
    return tonumber(card.getName():sub(1, 1))
end 