local Equipamento = {}
Equipamento.__index = Equipamento

function Equipamento:new(nome, img, stats)
  
  local equipamento = {
        nome = nome,
        imgEquipamento = love.graphics.newImage(img),
        stats = stats,

  }
  setmetatable(equipamento, Equipamento)
  return equipamento
    
end

return Equipamento