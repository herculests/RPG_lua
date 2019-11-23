local Blocks = {}
Blocks.__index = Blocks

function Blocks:new()
  
  local blocks = {
        X = love.graphics.newImage("imagens/muro.png"),
        Y = love.graphics.newImage("imagens/piso.png"),
        A = love.graphics.newImage("imagens/feno.png"),
        C = love.graphics.newImage("imagens/buraco.png"),
        B = love.graphics.newImage("imagens/baufechado.png"),
        M = love.graphics.newImage("imagens/monstro2.png"),
        BA = love.graphics.newImage("imagens/bauAberto.png"),
        K = love.graphics.newImage("imagens/chaveMapa.png"),
        P = love.graphics.newImage("imagens/portal.png"),
        E = love.graphics.newImage("imagens/entrada.png"),
    
  }
  setmetatable(blocks, Blocks)
  return blocks
    
end

function Blocks:get(attr)
    return blocks[attr]
end

return Blocks