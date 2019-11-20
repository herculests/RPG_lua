local Equipamento = {}
Equipamento.__index = Equipamento

function Equipamento:new(imgEquipamento, nome, stats)
  
  local equipamento = {
    
    atributos = {
        nome = nome,
        imgEquipamento = imgEquipamento,
        stats = stats,
    }

  }
  setmetatable(equipamento, Equipamento)
  return equipamento
    
end

function Equipamento.get(attr)
    return self.atributos['stats'].get(attr)
end

function Equipamento.set(attr, value)

    self.atributos['stats'].set(attr, value)
end

function getNome()
  return self.atributos['nome']
end

function getImg()
  return self.atributos['imgEquipamento']
end

return Equipamento