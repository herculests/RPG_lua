local mapa = {}
local tile_grass
local tile_water
local tile_sand

function LoadMap(Matriz)
    local file = io.open(Matriz, "r")
    local i = 1
    for line in file:lines() 
    do
        mapa[i] = {}
        for j=1, #line, 1 
        do
            mapa[i][j] = line:sub(j,j)
        end
        i = i + 1
    end
    file:close()
end

function love.load()
    love.window.setMode( 1184, 608, {resizable=false} )
    LoadMap("projeto/Matriz.txt")
    peda = love.graphics.newImage("peda.png")
    portal = love.graphics.newImage("portal.png")
    pedaChao = love.graphics.newImage("pedaChao.png")
    alface = love.graphics.newImage("alface.png")
    oco = love.graphics.newImage("oco.png")
    bauFechado = love.graphics.newImage("baufechado.png")
end

function love.draw()
    local tamanho = 32
    for linha=1,19,1
    do
        for coluna=1,37,1
        do
            if(mapa[linha][coluna] == "X")
            then
                love.graphics.draw(peda, tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "A")
            then
                love.graphics.draw(alface, tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "C")
            then
                love.graphics.draw(pedaChao,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(oco, tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "B")
            then
                love.graphics.draw(pedaChao,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(bauFechado, (tamanho*coluna-tamanho) + 3, (tamanho*linha-tamanho) + 3)
            elseif(mapa[linha][coluna] == "P")
            then
                love.graphics.draw(pedaChao,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(portal, (tamanho*coluna-tamanho) + 1, (tamanho*linha-tamanho) + 1)
            else
                love.graphics.draw(pedaChao,tamanho*coluna-tamanho, tamanho*linha-tamanho)
            end
        end
    end
end
    