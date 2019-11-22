local Map = {}
Map.__index = Map

function Map:new(nome, nivel, mapa)
  
  local map = {
        nome = nome,
        nivel = nivel,
        mapa = mapa,
    
  }
  setmetatable(map, Map)
  return map
    
end

return Map