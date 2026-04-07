-- Sealed Gate
local SET_WHITE_KNIGHT = 0x155d
local s, id = GetID()
function s.initial_effect(c)
  -- activate
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
end
s.listed_series = {SET_WHITE_KNIGHT}