-- God's Anger
local s, id = GetID()
function s.initial_effect(c)
  -- activate
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  -- search & extra tribute summon
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(s.dbcon)
  e2:SetOperation(s.dbop)
  c:RegisterEffect(e2)
end
s.listed_names={CARD_OBELISK, CARD_SLIFER, CARD_RA}
function s.dbfilter(c)
  return c:IsOriginalRace(RACE_DIVINE)
end
function s.dbcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(s.dbfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:ListsCode(CARD_OBELISK, CARD_SLIFER, CARD_RA) and c:IsAbleToHand()
end
function s.dbop(e,tp,eg,ep,ev,re,r,rp)
  -- search
  local g = Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
  if #g>0 and Duel.SelectYesNo(tp, aux.Stringid(id,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg = g:Select(tp,1,1,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
  end
  -- additional tribute summon
  local e1 = Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
  e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
  e1:SetTarget(s.dbfilter)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end