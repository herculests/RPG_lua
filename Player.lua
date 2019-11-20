local Player = {}

local Player = {}
Player.__index = Player

function Player:new(arma, armadura, vitalidade, xp, pocoes, nivel, stats)
  
  local player = {
    
    status = {
      arma = arma,
      armadura = armadura,
      stats = stats,
      pocoes = pocoes,
      vitalidade = vitalidade,
      xp = xp,
      nivel = nivel,
    }
    
  }
  setmetatable(player, Player)
  return player
    
end

function getStat(obj, attr)
  return self.status[obj].get(attr)
end

function get(attr)
  return self.status[attr]
end


function setStat(obj, attr, vlr)
  self.status[obj].set(attr, vlr)
end

function set(attr, vlr)
  self.status[attr] = vlr
end

return Player