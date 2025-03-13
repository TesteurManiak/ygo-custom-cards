-- In the Name of the Gods
local s, id = GetID()
function s.initial_effect(c)
  -- activate
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
end
s.listed_names={CARD_MONSTER_REBORN,CARD_OBELISK, CARD_SLIFER, CARD_RA}