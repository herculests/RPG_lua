local Map = {}

local Map = {}
Map.__index = Map

function Map:new()
  
  local map = {
    
    atributos = {

    }
    
  }
  setmetatable(map, Map)
  return map
    
end