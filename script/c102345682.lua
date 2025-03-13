-- Shrine of Djeser
local s, id = GetID()
function s.initial_effect(c)
  -- activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
  -- protect tribute summoned gods
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetRange(LOCATION_FZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(s.immtg)
  e2:SetValue(s.immval)
  c:RegisterEffect(e2)
  -- battle phase summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id, 1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(s.spcon)
  e3:SetTarget(s.sptg)
  e3:SetOperation(s.spop)
  c:RegisterEffect(e3)
end
s.listed_names={CARD_OBELISK, CARD_SLIFER, CARD_RA}
function s.thfilter(c)
  return c:IsMonster() and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
  if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,1,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
  end
end
function s.immtg(e, c)
  return c:IsCode(10000000, 10000010, 10000020) and c:IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.immval(e, te)
  local tp = e:GetHandlerPlayer()
  if te:GetOwnerPlayer() == tp then return false end
  local tc = te:GetHandler()
  if te:IsActiveType(TYPE_MONSTER) then
    return not tc:IsAttribute(ATTRIBUTE_DIVINE)
  elseif te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP) then
    return true
  end
  return false
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
  return Duel.GetTurnPlayer()==tp
end
function s.spfilter(c, e, tp)
  return c:IsMonster() and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsCanBeSpecialSummoned(e, 0, tp, true, false)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
      and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND, 0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
  if #g > 0 then
    local tc = g:GetFirst()
    if Duel.SpecialSummon(tc, 0, tp, tp, true, false, POS_FACEUP) ~= 0 then
      tc:CompleteProcedure()
    end
  end
end