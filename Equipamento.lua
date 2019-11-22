local Equipamento = {}
Equipamento.__index = Equipamento

function Equipamento:new(nome, img, stats, tipo)
  
  local equipamento = {
        nome = nome,
        imgEquipamento = love.graphics.newImage(img),
        stats = stats,
        tipo = tipo,

  }
  setmetatable(equipamento, Equipamento)
  return equipamento
    
end

return Equipamento