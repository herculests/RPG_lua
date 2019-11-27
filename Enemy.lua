local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(stats, img)
  
    local enemy = {
        img = img,
        stats = stats,
        vitalidade = 300,

        inventario = {
        
        }
    }
    setmetatable(enemy, Enemy)
    return enemy
    
end

return Enemy