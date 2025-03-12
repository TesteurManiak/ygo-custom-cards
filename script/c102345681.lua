-- Nameless Pharaoh
local s, id = GetID()
function s.initial_effect(c)
  --summon
  local e1 = Effect.CreateEffect(c)
  c:RegisterEffect(e1)
  --triple tribute for divine-beast
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
  e2:SetValue(s.ttcon)
  c:RegisterEffect(e2)
end
function s.ttcon(e,c)
  return c:IsRace(RACE_DIVINE)
end