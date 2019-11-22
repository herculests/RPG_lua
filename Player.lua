local Player = {}
Player.__index = Player

function Player:new(arma, armadura, stats)
  
  local player = {
      arma = arma,
      armadura = armadura,
      stats = stats,
      pocaoVida = 0,
      pocaoXp = 0,
      pocaoDano = 0,
      vitalidade = 300,
      xp = 0,
      nivel = 1,

      inventario = {

      }
    
  }
  setmetatable(player, Player)
  return player
    
end

return Player