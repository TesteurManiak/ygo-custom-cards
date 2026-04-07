-- White Knight Swordsman
local SET_WHITE_KNIGHT = 0x155d
local s, id = GetID()
function s.initial_effect(c)
	-- search on summon
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.srtg)
	e1:SetOperation(s.srop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	-- atk boost during battle phase
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard, SET_WHITE_KNIGHT))
	e3:SetCondition(s.bpcon)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	-- atk/def up from GY
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE, 0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard, SET_WHITE_KNIGHT))
	e4:SetValue(300)
	c:RegisterEffect(e4)
	local e5 = e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
function s.srfilter(c)
	return c:IsSetCard(SET_WHITE_KNIGHT) and c:IsAbleToHand()
end
function s.srtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.srfilter, tp, LOCATION_DECK, 0, 1, nil)
			and Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 2, tp, LOCATION_DECK)
end
function s.srop(e, tp, eg, ep, ev, re, r, rp)
	local dc = Duel.GetMatchingGroup(s.srfilter, tp, LOCATION_DECK, 0, nil)
	local max = math.min(2, #dc)
	if max < 1 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.srfilter, tp, LOCATION_DECK, 0, 1, max, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
		local dg = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, 1, 1, nil)
		Duel.SendtoGrave(dg, REASON_EFFECT)
	end
end
function s.bpcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetCurrentPhase() == PHASE_BATTLE
end
