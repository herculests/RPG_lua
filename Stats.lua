local Stats = {}
Stats.__index = Stats

function Stats:new(ataque, defesa, acuracia, critico, destreza)
  
  local stats = {
      ataque = ataque,
      defesa = defesa,
      acuracia = acuracia,
      critico = critico,
      destreza = destreza

  }
  setmetatable(stats, Stats)
  return stats
    
end

return Stats