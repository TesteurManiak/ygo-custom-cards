-- White Knight Gardna
local s, id = GetID()
function s.initial_effect(c)
  -- special summon from hand
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1, id)
  e1:SetCondition(s.spcon)
  e1:SetTarget(s.sptg)
  e1:SetOperation(s.spop)
  c:RegisterEffect(e1)
  -- cannot be destroyed by battle
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  -- graveyard battle protection
  local e3 = Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_REMOVE)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(s.protcon)
  e3:SetCost(s.protcost)
  e3:SetOperation(s.protop)
  c:RegisterEffect(e3)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
  tp = e:GetHandlerPlayer()
  local ac = Duel.GetAttacker()
  return ac and ac:IsControler(1-tp)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
  local c = e:GetHandler()
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
      and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
  if c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
  end
end
function s.battlefilter(c, tp)
  return c and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function s.protcon(e, tp, eg, ep, ev, re, r, rp)
  tp = e:GetHandlerPlayer()
  local a = Duel.GetAttacker()
  local d = Duel.GetAttackTarget()
  return s.battlefilter(a, tp) or s.battlefilter(d, tp)
end
function s.protcost(e, tp, eg, ep, ev, re, r, rp, chk)
  local c = e:GetHandler()
  if chk == 0 then
    if c.IsAbleToRemoveAsCost then
      return c:IsAbleToRemoveAsCost()
    end
    return c:IsAbleToRemove()
  end
  Duel.Remove(c, POS_FACEUP, REASON_COST)
end
function s.protop(e, tp, eg, ep, ev, re, r, rp)
  tp = e:GetHandlerPlayer()
  local a = Duel.GetAttacker()
  local d = Duel.GetAttackTarget()
  local tc = nil
  if s.battlefilter(a, tp) then
    tc = a
  elseif s.battlefilter(d, tp) then
    tc = d
  end
  if not tc then return end
  local e1 = Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
  tc:RegisterEffect(e1)
  local e2 = Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetLabel(tp)
  e2:SetCondition(s.bdcon)
  e2:SetOperation(s.bdop)
  e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e2, tp)
end
function s.bdcon(e, tp, eg, ep, ev, re, r, rp)
  return ep == e:GetLabel()
end
function s.bdop(e, tp, eg, ep, ev, re, r, rp)
  Duel.ChangeBattleDamage(e:GetLabel(), 0)
end
