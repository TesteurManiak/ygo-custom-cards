-- Sealed Gate
local SET_WHITE_KNIGHT = 0x155d
local s, id = GetID()
function s.initial_effect(c)
  -- always treated as a White Knight card
  local e0 = Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(EFFECT_ADD_SETCODE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetValue(SET_WHITE_KNIGHT)
  c:RegisterEffect(e0)
  -- activate
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
end
s.listed_series = {SET_WHITE_KNIGHT}