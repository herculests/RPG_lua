local mapa = {}
local matriz = {}
local matrizInventario = {}
local mapar = {}
local aux = {}
local posCol = 2
local posLin = 2
local posColr = 27
local posLinr = 18
local img
local linha1 = 1
local coluna1 = 1
local linha2 = 1
local coluna2 = 1
local linha3 = 1
local arma = "V"
local capacete = "V"
local estado = "movimento"
local confirma = "nada" 

Player = require 'Player'

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

function LoadInv(Inventario)
    local file1 = io.open(Inventario, "r")
    local x = 1
    for linha in file1:lines() 
    do
        matrizInventario[x] = {}
        for y=1, #linha, 1 
        do
            matrizInventario[x][y] = linha:sub(y,y)
        end
        x = x + 1
    end
    file1:close()
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

    love.keyboard.setKeyRepeat(true)

    love.window.setMode( 1792, 1000, {resizable=false} )
    LoadMap("RPG_lua/Matriz.txt")
    LoadInv("RPG_lua/Inventario.txt")
    heroi = love.graphics.newImage("imagens/heroi.png")
    bauabertoCorredor = love.graphics.newImage("imagens/bauabertoCorredor.png")
    bauabertoCorredora = love.graphics.newImage("imagens/bauabertoCorredora.png")
    corredorChave = love.graphics.newImage("imagens/corredorChave.png")
    vazio = love.graphics.newImage("imagens/vazio.png")
    capaceteFerro = love.graphics.newImage("imagens/capaceteFerro.png")
    capaceteMadeira = love.graphics.newImage("imagens/capaceteMadeira.png")
    touca = love.graphics.newImage("imagens/touca.png")
    esqueleto = love.graphics.newImage("imagens/esqueleto.png")
    espada = love.graphics.newImage("imagens/espada.png")
    cajado = love.graphics.newImage("imagens/cajado.png")
    machado = love.graphics.newImage("imagens/machado.png")
    pergaminho2 = love.graphics.newImage("imagens/pergaminho2.png")
    corote = love.graphics.newImage("imagens/corote.png")
    coroteAgilidade = love.graphics.newImage("imagens/coroteAgilidade.png")
    coroteVida = love.graphics.newImage("imagens/coroteVida.png")
    chave = love.graphics.newImage("imagens/chave.png")
    heroiW = love.graphics.newImage("imagens/heroiW.png")
    heroiS = love.graphics.newImage("imagens/heroiS.png")
    heroiA = love.graphics.newImage("imagens/heroiA.png")
    heroiD = love.graphics.newImage("imagens/heroiD.png")
    muro = love.graphics.newImage("imagens/muro.png")
    pergaminho = love.graphics.newImage("imagens/pergaminho.png")
    inv = love.graphics.newImage("imagens/inv.png")
    inventario = love.graphics.newImage("imagens/inventario.png")
    portalParede = love.graphics.newImage("imagens/portalParede.png")
    portalaa = love.graphics.newImage("imagens/portalaa.png")
    img = love.graphics.newImage("imagens/imgad.png")
    monstro3 = love.graphics.newImage("imagens/monstro3.png")
    monstro2 = love.graphics.newImage("imagens/monstro2.png")
    corredor2 = love.graphics.newImage("imagens/corredor2.png")
    imgburaco = love.graphics.newImage("imagens/imgburaco.png")
    imgburacoa = love.graphics.newImage("imagens/imgburacoa.png")
    imga = love.graphics.newImage("imagens/imga.png")
    imgaa = love.graphics.newImage("imagens/imgaa.png")
    imga2 = love.graphics.newImage("imagens/imga2.png")
    imgaa2 = love.graphics.newImage("imagens/imgaa2.png")
    imgad = love.graphics.newImage("imagens/imgad.png")
    imgaw = love.graphics.newImage("imagens/imgaw.png")
    imgawwd = love.graphics.newImage("imagens/imgawwd.png")
    imgawwdw = love.graphics.newImage("imagens/imgawwdw.png")
    imgwd = love.graphics.newImage("imagens/imgwd.png")
    imgawd = love.graphics.newImage("imagens/imgawd.png")
    portal = love.graphics.newImage("imagens/portal.png")
    piso = love.graphics.newImage("imagens/piso.png")
    feno = love.graphics.newImage("imagens/feno.png")
    buraco = love.graphics.newImage("imagens/buraco.png")
    bauCorredor = love.graphics.newImage("imagens/bauCorredor.png")
    bauCorredoraa = love.graphics.newImage("imagens/bauCorredoraa.png")
    bauFechado = love.graphics.newImage("imagens/baufechado.png")
    bauAberto = love.graphics.newImage("imagens/bauAberto.png")
    chaveMapa = love.graphics.newImage("imagens/chaveMapa.png")

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
            elseif(mapa[linha][coluna] == "M")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(monstro2, (tamanho*coluna-tamanho) + 3, (tamanho*linha-tamanho) + 3)
            elseif(mapa[linha][coluna] == "BA")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(bauAberto, (tamanho*coluna-tamanho) + 3, (tamanho*linha-tamanho) + 3)
            elseif(mapa[linha][coluna] == "K")
            then
                love.graphics.draw(piso,tamanho*coluna-tamanho, tamanho*linha-tamanho)
                love.graphics.draw(chaveMapa, (tamanho*coluna-tamanho) + 6, (tamanho*linha-tamanho) + 6)
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

    local tamanho2 = 90

    love.graphics.draw(img, 896, 0)
    love.graphics.draw(pergaminho2, 896, 0)
    love.graphics.draw(pergaminho, 0, 613)
    love.graphics.draw(inventario, 1351, 640)
    love.graphics.draw(inv, 1450, 633)
    love.graphics.draw(esqueleto, 1010, 710)

    love.graphics.printf( "COMANDOS", 80, 633, 80, "left", 0, 3, 3, 0, 0, 0, 0 )

    if estado == "movimento"
    then
        love.graphics.printf( "W - mover para frente", 80, 693, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - mover para trás", 80, 733, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "A - mover para esqueda", 80, 773, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "D - mover para direita", 80, 813, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    elseif estado == "bau"
    then
        love.graphics.printf( "K - abre bau", 80, 853, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    end

    if(arma == "V")
    then
        love.graphics.draw(vazio, 1173, 760)
    elseif(arma == "C")
    then
        love.graphics.draw(cajado, 1173, 760)
    elseif(arma == "M")
    then
        love.graphics.draw(machado, 1173, 760)
    elseif(arma == "E")
    then
        love.graphics.draw(espada, 1173, 760)
    end

    if(capacete == "V")
    then
        love.graphics.draw(vazio, 990, 662)
    elseif(capacete == "M")
    then
        love.graphics.draw(capaceteMadeira, 990, 662)
    elseif(capacete == "F")
    then
        love.graphics.draw(capaceteFerro, 990, 662)
    elseif(capacete == "T")
    then
        love.graphics.draw(touca, 990, 662)
    end

    for l=1,3,1
    do
        for c=1,4,1
        do
            if(matrizInventario[l][c] == "V")
            then
                love.graphics.draw(vazio,tamanho2*c + 1292, tamanho2*l + 590)

            elseif(matrizInventario[l][c] == "K")
            then
                love.graphics.draw(chave,tamanho2*c + 1292, tamanho2*l + 590)

            elseif(matrizInventario[l][c] == "C")
            then
                love.graphics.draw(corote,tamanho2*c + 1292, tamanho2*l + 590)

            elseif(matrizInventario[l][c] == "L")
            then
                love.graphics.draw(coroteVida,tamanho2*c + 1292, tamanho2*l + 590)
            
            elseif(matrizInventario[l][c] == "A")
            then
                love.graphics.draw(coroteAgilidade,tamanho2*c + 1292, tamanho2*l + 590)

            end
        end
    end
end

function preencheInventario(item)
    for l=1,3,1
    do
        for c=1,4,1
        do
            if matrizInventario[l][c] == "V"
            then
                matrizInventario[l][c] = item
                return
            end
        end
    end
end

math.randomseed(os.time())

function SORTEIO()
    N = math.random(1,10)
    return N
end

function itensBauArmadura()
    
    for I = 1, 1 do
        x = SORTEIO()
        if x == 1 then
            preencheInventario("C")
        elseif x == 2 then
            preencheInventario("L")
        elseif x == 3 then
            preencheInventario("A")
        elseif x == 4 then
            --if capacete == "V" then
                capacete = "T"
        elseif x == 5 then
            --if arma == "V" then
                arma = "M"
        elseif x == 6 then
            --if capacete == "V" then
                capacete = "F"
        elseif x == 7 then
            --if arma == "V" then
                arma = "C"
        elseif x == 8 then
            --if capacete == "V" then
                capacete = "M"
        elseif x == 9 then
            --if arma == "V" then
                arma = "E"
        end
    end
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
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and
        (matriz[lin][colMaisDois] == "P")
    then
        img = portalaa
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
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and
        (matriz[lin][colMaisDois] == "B")
    then
        img = bauCorredoraa
     elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X") and
        (matriz[lin][colMaisDois] == "BA")
    then
        img = bauabertoCorredora
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "B") and (matriz[linMaisUm][col] == "X")
    then
        estado = "bau"
        img = bauCorredor
        linha1 = linMenosUm
        coluna1 = col
        linha2 = lin
        coluna2 = colMaisUm
        linha3 = linMaisUm
    
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "BA") and (matriz[linMaisUm][col] == "X")
    then
        img = bauabertoCorredor

    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "X") and (matriz[linMaisUm][col] == "Y")
    then
        img = imgaw
    elseif (matriz[linMenosUm][col] == "Y") and (matriz[lin][colMaisUm] == "X") and (matriz[linMaisUm][col] == "X")
    then
        img = imgwd
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "X") and (matriz[linMaisUm][col] == "X")
    then
        img = imgawd
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "P") and (matriz[linMaisUm][col] == "X")
    then
        img = portalParede
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "M") and (matriz[linMaisUm][col] == "X")
    then
        img = monstro3
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "K") and (matriz[linMaisUm][col] == "X")
    then
        img = corredorChave
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][col] == "K") and (matriz[linMaisUm][col] == "X")
    then
        mapa[lin][col] = "Y"
        preencheInventario("K")
        img = imgad
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "Y") and (matriz[linMaisUm][col] == "X")
    then
        if img == imgad
        then
            img = corredor2

        elseif img == corredor2
        then
            img = imgad
        else
            img = imgad
        end
    end
end

function love.keypressed(key, scancode, isrepeat)

    if(estado == "movimento")
    then
        if key == "d" then
            heroi = heroiD
            espelhaMatriz()
            if (mapa[posLin][posCol + 1] == "Y") or (mapa[posLin][posCol + 1] == "K")
            then
                posCol = posCol + 1
                posColr =   posColr -1
                background()
            end

        elseif key == "a" then
            heroi = heroiA
            espelhaMatriz()
            if (mapa[posLin][posCol - 1] == "Y") or (mapa[posLin][posCol - 1] == "K")
            then
                posCol = posCol - 1
                posColr = posColr +1
                background()
            end

        elseif key == "s" then
            heroi = heroiS
            espelhaMatriz()
            if (mapa[posLin + 1][posCol] == "Y") or (mapa[posLin + 1][posCol] == "K")
            then
                posLin = posLin + 1
                posLinr = posLinr - 1
                background()
            end

        elseif key == "w" then
            heroi = heroiW
            espelhaMatriz()
            if (mapa[posLin - 1][posCol] == "Y") or (mapa[posLin - 1][posCol] == "K")
            then
                posLin = posLin - 1
                posLinr = posLinr + 1
                background()
            end
        end

    elseif(estado == "bau")
    then
        if key == "k" then
            if (matriz[linha1][coluna1] == "X") and (matriz[linha2][coluna2] == "B") and (matriz[linha3][coluna1] == "X")
            then
                for l=1,3,1
                do
                    for c=1,4,1
                    do
                        if matrizInventario[l][c] == "K"
                        then
                            img = bauabertoCorredor

                            if mapa[posLin-1][posCol] == "B" then
                                mapa[posLin-1][posCol] = "BA"
                            elseif mapa[posLin+1][posCol] == "B" then
                                mapa[posLin+1][posCol] = "BA"
                            elseif mapa[posLin][posCol-1] == "B" then
                                mapa[posLin][posCol-1] = "BA"
                            elseif mapa[posLin][posCol+1] == "B" then
                                mapa[posLin][posCol+1] = "BA"
                            end

                            matrizInventario[l][c] = "V"
                            itensBauArmadura()
                            linha2 = 1
                            coluna2 = 1

                            estado = "movimento"
                            return
                        end
                    end
                end
                estado = "movimento"
            end
        end
    end
end
-- para utilizar 

--Map.idade=10