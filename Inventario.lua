local Invetario = {}
Invetario.__index = Invetario

function Invetario:new()
  
    local inventario = {
        
    }
    setmetatable(inventario, Invetario)
    return inventario
    
end

function Invetario:get(attr)
    return inventario[attr]
end

return Invetario