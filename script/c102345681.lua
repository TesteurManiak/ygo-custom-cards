-- Nameless Pharaoh
local s, id = GetID()
function s.initial_effect(c)
  --search
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1, id)
  e1:SetTarget(s.thtg)
  e1:SetOperation(s.thop)
  c:RegisterEffect(e1)
  local e2 = e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --triple tribute
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_TRIPLE_TRIBUTE)
  e3:SetValue(s.ttcon)
  c:RegisterEffect(e3)
  --additional tribute summon
  local e4 = Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(id, 1))
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1, id+100)
  e4:SetCondition(s.tscon)
  e4:SetTarget(s.tstg)
  e4:SetOperation(s.tsop)
  c:RegisterEffect(e4)
end
s.listed_names={CARD_OBELISK, CARD_SLIFER, CARD_RA}
function s.thfilter(c)
  return not c:IsCode(id) and (c:IsCode(10000000, 10000010, 10000020) or c:ListsCode(CARD_OBELISK, CARD_SLIFER, CARD_RA)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.ttcon(e,c)
  return c:IsRace(RACE_DIVINE)
end
function s.tscon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsMainPhase()
end
function s.tsfilter(c)
  return c:IsLevel(10) and (c:IsDefense(4000) or c:IsDefense(-1)) and c:IsSummonable(true,nil)
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
  local g=Duel.SelectMatchingCard(tp,s.tsfilter,tp,LOCATION_HAND,0,1,1,nil)
  local tc=g:GetFirst()
  if tc then
    Duel.Summon(tp,tc,true,nil,1)
  end
end