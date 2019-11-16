local mapa = {}
local mapar = {}
local aux = {}
local posCol = 2
local posLin = 2
local posColr = 27
local posLinr = 18
local img

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

function espelhaMatriz()
    if heroi == heroiA
    then
        for l=1,19,1
        do
            mapar[l] = {}
            for c=1,28,1
            do
                mapar[l][c] = mapa[l][29-c]
            end
        end

    elseif heroi == heroiW
    then
        for l=1,28,1
        do
            mapar[l] = {}
            for c=1,19,1
            do
                if (mapa[c][l] == "X") or (mapa[c][l] == "Y") or (mapa[c][l] == "A") or (mapa[c][l] == "C") or (mapa[c][l] == "B") or (mapa[c][l] == "BA") or (mapa[c][l] == "P")
                then
                    mapar[l][c] = mapa[c][l]
                end
            end
        end

        for l=1,28,1
        do
            aux[l] = {}
            for c=1,19,1
            do
                aux[l][c] = mapar[l][c]
            end
        end

        for l=1,28,1
        do
            for c=1,19,1
            do
                mapar[l][c] = aux[l][20-c]
            end
        end
        
    elseif heroi == heroiS
    then
        for l=1,28,1
        do
            mapar[l] = {}
            for c=1,19,1
            do
                if (mapa[c][l] == "X") or (mapa[c][l] == "Y") or (mapa[c][l] == "A") or (mapa[c][l] == "C") or (mapa[c][l] == "B") or (mapa[c][l] == "BA") or (mapa[c][l] == "P")
                then
                    mapar[l][c] = mapa[c][l]
                end
            end
        end
    end

end

function love.load()
    love.window.setMode( 1792, 608, {resizable=false} )
    LoadMap("RPG_lua/Matriz.txt")
    heroi = love.graphics.newImage("heroi.png")
    heroiW = love.graphics.newImage("heroiW.png")
    heroiS = love.graphics.newImage("heroiS.png")
    heroiA = love.graphics.newImage("heroiA.png")
    heroiD = love.graphics.newImage("heroiD.png")
    muro = love.graphics.newImage("muro.png")
    img = love.graphics.newImage("imgad.png")
    imgburaco = love.graphics.newImage("imgburaco.png")
    imgburacoa = love.graphics.newImage("imgburacoa.png")
    imga = love.graphics.newImage("imga.png")
    imgaa = love.graphics.newImage("imgaa.png")
    imga2 = love.graphics.newImage("imga2.png")
    imgaa2 = love.graphics.newImage("imgaa2.png")
    imgad = love.graphics.newImage("imgad.png")
    imgaw = love.graphics.newImage("imgaw.png")
    imgawwd = love.graphics.newImage("imgawwd.png")
    imgawwdw = love.graphics.newImage("imgawwdw.png")
    imgwd = love.graphics.newImage("imgwd.png")
    imgawd = love.graphics.newImage("imgawd.png")
    portal = love.graphics.newImage("portal.png")
    piso = love.graphics.newImage("piso.png")
    feno = love.graphics.newImage("feno.png")
    buraco = love.graphics.newImage("buraco.png")
    bauFechado = love.graphics.newImage("baufechado.png")
    bauAberto = love.graphics.newImage("bauAberto.png")
end

function love.draw()
    local tamanho = 32
    for linha=1,19,1
    do
        for coluna=1,29,1
        do
            
            if(mapa[linha][coluna] == "X")
            then
                love.graphics.draw(muro, tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "Y")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "A")
            then
                love.graphics.draw(feno, tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "C")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(buraco, tamanho*coluna-tamanho, tamanho*linha-tamanho)
            elseif(mapa[linha][coluna] == "B")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(bauFechado, (tamanho*coluna-tamanho) + 3, (tamanho*linha-tamanho) + 3)
            elseif(mapa[linha][coluna] == "BA")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(bauAberto, (tamanho*coluna-tamanho) + 3, (tamanho*linha-tamanho) + 3)
            elseif(mapa[linha][coluna] == "P")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(portal, (tamanho*coluna-tamanho) + 1, (tamanho*linha-tamanho) + 1)
            else
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(heroi, tamanho*posCol-tamanho, tamanho*posLin-tamanho)
            end
        end
    end
    love.graphics.draw(img, 896, 0)
end

function background()

    if heroi == heroiA
    then
        matriz = mapar
        lin = posLin
        linMaisUm = posLin -1
        linMenosUm = posLin +1

        col = posColr
        colMaisUm = posColr +1
        colMaisDois = posColr +2

    elseif heroi == heroiD
    then
        matriz = mapa
        lin = posLin
        linMaisUm = posLin +1
        linMenosUm = posLin -1

        col = posCol
        colMaisUm = posCol +1
        colMaisDois = posCol +2

    elseif heroi == heroiS
    then
        matriz = mapar
        lin = posCol
        linMaisUm = posCol -1
        linMenosUm = posCol +1

        col = posLin
        colMaisUm = posLin +1
        colMaisDois = posLin +2
        
    elseif heroi == heroiW
    then
        matriz = mapar
        lin = posCol
        linMaisUm = posCol +1
        linMenosUm = posCol -1

        col = posLinr
        colMaisUm = posLinr +1
        colMaisDois = posLinr +2

    end
    

    if (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and 
       (matriz[linMaisUm][colMaisUm] == "Y")  and (matriz[linMenosUm][colMaisUm] == "X")  and (matriz[lin][colMaisDois] == "Y")
    then
        img = imga
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and 
        (matriz[linMaisUm][colMaisUm] == "X")  and (matriz[linMenosUm][colMaisUm] == "Y")  and (matriz[lin][colMaisDois] == "Y")
     then
         img = imga2
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and 
        (matriz[linMaisUm][colMaisUm] == "X")  and (matriz[linMenosUm][colMaisUm] == "Y")  and (matriz[lin][colMaisDois] == "X")
    then
        img = imgawwdw
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and 
        (matriz[linMaisUm][colMaisUm] == "Y")  and (matriz[linMenosUm][colMaisUm] == "X")  and (matriz[lin][colMaisDois] == "X")
    then
        img = imgawwd
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "Y") 
    then
        img = imgaa
    elseif (matriz[linMenosUm][col] == "Y") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") 
    then
        img = imgaa2
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "C") and (matriz[linMaisUm][col] == "X") and
        (matriz[lin][colMaisDois] == "Y")
    then
        img = imgburaco
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "C") and (matriz[linMaisUm][col] == "X") and
        (matriz[lin][colMaisDois] == "X")
    then
        img = imgburacoa
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "X") and (matriz[linMaisUm][col] == "Y")
    then
        img = imgaw
    elseif (matriz[linMenosUm][col] == "Y") and (matriz[lin][colMaisUm] == "X") and (matriz[linMaisUm][col] == "X")
    then
        img = imgwd
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "X") and (matriz[linMaisUm][col] == "X")
    then
        img = imgawd
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X")
    then
        img = imgad
    end
end

function love.keypressed(key, scancode, isrepeat)
    
    if key == "d" then
        heroi = heroiD
        if mapa[posLin][posCol + 1] == "Y"
        then
            posCol = posCol + 1
            posColr =   posColr -1
            background()
        end
        if mapa[posLin][posCol +1] == "B"
        then
            mapa[posLin][posCol +1] = "BA"
        end
    elseif key == "a" then
        heroi = heroiA
        espelhaMatriz()
        if mapa[posLin][posCol - 1] == "Y"
        then
            posCol = posCol - 1
            posColr = posColr +1
            background()
        end
        if mapa[posLin][posCol -1] == "B"
        then
            mapa[posLin][posCol -1] = "BA"
        end
    elseif key == "s" then
        heroi = heroiS
        espelhaMatriz()
        if mapa[posLin + 1][posCol] == "Y"
        then
            posLin = posLin + 1
            posLinr = posLinr - 1
            background()
        end
        if mapa[posLin +1][posCol] == "B"
        then
            mapa[posLin +1][posCol] = "BA"
        end
    elseif key == "w" then
        heroi = heroiW
        espelhaMatriz()
        if mapa[posLin - 1][posCol] == "Y"
        then
            posLin = posLin - 1
            posLinr = posLinr + 1
            background()
        end
        if mapa[posLin -1][posCol] == "B"
        then
            mapa[posLin -1][posCol] = "BA"
        end
    end
 end