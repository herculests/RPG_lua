local Stats = {}
Stats.__index = Stats

function Stats:new(forca, defesa, acuracia, critico, destreza)
  
  local stats = {
    
    atributos = {
      forca = forca,
      defesa = defesa,
      acuracia = acuracia,
      critico = critico,
      destreza = destreza,
    }

  }
  setmetatable(stats, Stats)
  return stats
    
end

function get(attr)
    return self.atributos[attr]
end

function set(attr, value)
    self.atributos[attr] = value
end

return Stats