local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(stats)
  
    local enemy = {
        stats = stats,
        vitalidade = 200,

        inventario = {
        
        }
    }
    setmetatable(enemy, Enemy)
    return enemy
    
end

return Enemy