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
local estado = "movimento"
local vitalidadeTotal = 300
local xpTotal = 200


Player = require 'Player'
Stats = require 'Stats'
Equipamento = require 'Equipamento'
Blocks = require 'Blocks'
Map = require 'Map'
Enemy = require 'Enemy'

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
    if heroi == heroiA then
        for l=1,19,1 do
            mapar[l] = {}
            for c=1,28,1 do
                mapar[l][c] = mapa[l][29-c]
            end
        end

    elseif heroi == heroiW then
        for l=1,28,1 do
            mapar[l] = {}
            for c=1,19,1 do
                 mapar[l][c] = mapa[c][l]
            end
        end

        for l=1,28,1 do
            aux[l] = {}
            for c=1,19,1 do
                aux[l][c] = mapar[l][c]
            end
        end

        for l=1,28,1 do
            for c=1,19,1 do
                mapar[l][c] = aux[l][20-c]
            end
        end
        
    elseif heroi == heroiS then
        for l=1,28,1 do
            mapar[l] = {}
            for c=1,19,1 do
                mapar[l][c] = mapa[c][l]
            end
        end
    end

end

function combatePE()

    plyAtaque = playerUm.stats.ataque + playerUm.arma.ataque + playerUm.armadura.ataque
    plyAcuracia = playerUm.stats.acuracia + playerUm.arma.acuracia + playerUm.armadura.acuracia
    plyCritico = playerUm.stats.critico + playerUm.arma.critico + playerUm.armadura.critico
    critico = 1

    if math.random(1, 3) <= plyCritico then
        critico = 2
    end

    if math.random(1, monstro.stats.destreza) <= plyAcuracia then
        ataque = plyAtaque * critico - monstro.stats.defesa
        ataque = math.max( ataque,0 )
        monstro.vitalidade = monstro.vitalidade - ataque
        print("Jogador ataca o inimigo, causando ", ataque," damage")

    else
        print("Jogador erra ataque.")
    end

end

function combateEP()

    plyDefesa = playerUm.stats.defesa + playerUm.arma.defesa + playerUm.armadura.defesa
    plyDestreza = playerUm.stats.destreza + playerUm.arma.destreza + playerUm.armadura.destreza
    critico = 1

    if math.random(1, 3) <= monstro.stats.critico then
        critico = 2
    end

    if math.random(1, plyDestreza) <= monstro.stats.acuracia then
        ataque = monstro.atats.acuracia * critico - plyDefesa
        ataque = math.max(ataque, 0)
        playerUm.vitalidade = playerUm.vitalidade - ataque
        print("Inimigo ataca o jogador, causando ", ataque," damage")

    else
        print("Inimigo erra ataque.")
    end

end

function love.load()
    LoadMap("RPG_lua/Matriz.txt")
    mapa2 = Map:new("Pesadelo", 1, mapa)

    blocks = Blocks:new()


    --                     (ataque, defesa, acuracia, critico, destreza)
    ststsEspada = Stats:new(50, 65, 32, 12, 21)
    ststsCajado = Stats:new(50, 65, 32, 12, 21)
    ststsMachado = Stats:new(50, 65, 32, 12, 21)
    ststsArmFerro = Stats:new(50, 65, 32, 12, 21)
    ststsArmMadeira = Stats:new(50, 65, 32, 12, 21)
    ststsArmPano = Stats:new(50, 65, 32, 12, 21)
    ststsMonstro = Stats:new(50, 65, 32, 12, 21)
    ststsVazio = Stats:new(0, 0, 0, 0, 0)
    ststsPlayer = Stats:new(24, 34, 52, 12, 32)


    --                      (nome, img, stats)
    espada = Equipamento:new("espada", "imagens/espada.png", ststsEspada)
    cajado = Equipamento:new("cajado", "imagens/cajado.png", ststsCajado)
    machado = Equipamento:new("machado", "imagens/machado.png", ststsMachado)
    ArmFerro = Equipamento:new("ArmFerro", "imagens/capaceteFerro.png", ststsArmFerro)
    ArmMadeira = Equipamento:new("ArmMadeira", "imagens/capaceteMadeira.png", ststsArmMadeira)
    ArmPano = Equipamento:new("ArmPano", "imagens/touca.png", ststsArmPano)
    vazio = Equipamento:new("vazio", "imagens/vazio.png", ststsVazio)


    --                   (arma, armadura, stats)
    playerUm = Player:new(vazio, vazio, ststsPlayer)


    --                  (stats)
    monstro = Enemy:new(ststsMonstro)

    love.keyboard.setKeyRepeat(true)

    love.window.setMode( 1792, 1000, {resizable=false} )
    
    LoadInv("RPG_lua/Inventario.txt")

    heroi = love.graphics.newImage("imagens/heroi.png")
    bauabertoCorredor = love.graphics.newImage("imagens/bauabertoCorredor.png")
    bauabertoCorredora = love.graphics.newImage("imagens/bauabertoCorredora.png")
    corredorChave = love.graphics.newImage("imagens/corredorChave.png")
    vazio1 = love.graphics.newImage("imagens/vazio.png")
    esqueleto = love.graphics.newImage("imagens/esqueleto.png")
    pergaminho2 = love.graphics.newImage("imagens/pergaminho2.png")
    corote = love.graphics.newImage("imagens/corote.png")
    coroteAgilidade = love.graphics.newImage("imagens/coroteAgilidade.png")
    coroteVida = love.graphics.newImage("imagens/coroteVida.png")
    chave = love.graphics.newImage("imagens/chave.png")
    heroiW = love.graphics.newImage("imagens/heroiW.png")
    heroiS = love.graphics.newImage("imagens/heroiS.png")
    heroiA = love.graphics.newImage("imagens/heroiA.png")
    heroiD = love.graphics.newImage("imagens/heroiD.png")
    pergaminho = love.graphics.newImage("imagens/pergaminho.png")
    inv = love.graphics.newImage("imagens/inv.png")
    inventario = love.graphics.newImage("imagens/inventario.png")
    portalParede = love.graphics.newImage("imagens/portalParede.png")
    portalaa = love.graphics.newImage("imagens/portalaa.png")
    img = love.graphics.newImage("imagens/imgad.png")
    monstro3 = love.graphics.newImage("imagens/monstro3.png")
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
    bauCorredor = love.graphics.newImage("imagens/bauCorredor.png")
    bauCorredoraa = love.graphics.newImage("imagens/bauCorredoraa.png")


end

function love.draw()
    local tamanho = 32

    for linha=1,19,1 do
        for coluna=1,28,1 do
            love.graphics.draw(Blocks:get("Y"), tamanho*coluna-tamanho, tamanho*linha-tamanho)
            love.graphics.draw(Blocks:get(mapa[linha][coluna]), tamanho*coluna-tamanho, tamanho*linha-tamanho)
        end
    end

    love.graphics.draw(heroi, tamanho*posCol-tamanho, tamanho*posLin-tamanho)

    local tamanho2 = 90

    love.graphics.draw(img, 896, 0)
    love.graphics.draw(pergaminho2, 896, 0)
    love.graphics.draw(pergaminho, 0, 613)
    love.graphics.draw(inventario, 1351, 640)
    love.graphics.draw(inv, 1450, 633)
    love.graphics.draw(esqueleto, 1010, 710)

    love.graphics.printf("Vitalidade:        /", 930, 40, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.vitalidade, 1060, 40, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( vitalidadeTotal, 1140, 40, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf("Poções: ", 930, 80, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( (playerUm.pocaoDano + playerUm.pocaoVida + playerUm.pocaoXp), 1030, 80, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf("Nível: ", 1550, 40, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.nivel, 1620, 40, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( "XP:        /", 1550, 80, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.xp, 1600, 80, 80, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( xpTotal, 1665, 80, 80, "left", 0, 2, 2, 0, 0, 0, 0 )

    love.graphics.printf( "STATUS", 480, 673, 81, "left", 0, 3, 3, 0, 0, 0, 0 )
    love.graphics.printf( "Força:            pts     +          +", 480, 723, 200, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( "Defesa:          pts     +          +", 480, 763, 200, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( "Acurácia:       pts     +          +", 480, 803, 200, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( "Destreza:       pts     +          +", 480, 843, 200, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( "Crítico:           pts    +          +", 480, 883, 200, "left", 0, 2, 2, 0, 0, 0, 0 )

    love.graphics.printf( playerUm.arma.stats.ataque + playerUm.armadura.stats.ataque + playerUm.stats.ataque, 605, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.defesa + playerUm.armadura.stats.defesa + playerUm.stats.defesa, 605, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.acuracia + playerUm.armadura.stats.acuracia + playerUm.stats.acuracia, 605, 803, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.destreza + playerUm.armadura.stats.destreza + playerUm.stats.destreza, 605, 843, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.critico + playerUm.armadura.stats.critico + playerUm.stats.critico, 605, 883, 150, "left", 0, 2, 2, 0, 0, 0, 0 )

    love.graphics.printf( "ARMA", 730, 683, 81, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.ataque, 750, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.defesa, 750, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.acuracia, 750, 803, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.destreza, 750, 843, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.arma.stats.critico, 750, 883, 150, "left", 0, 2, 2, 0, 0, 0, 0 )

    love.graphics.printf( "ROUPA", 830, 683, 81, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.armadura.stats.ataque, 850, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.armadura.stats.defesa, 850, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.armadura.stats.acuracia, 850, 803, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.armadura.stats.destreza, 850, 843, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.armadura.stats.critico, 850, 883, 150, "left", 0, 2, 2, 0, 0, 0, 0 )

    love.graphics.printf( "BASE", 940, 683, 81, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.stats.ataque, 960, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.stats.defesa, 960, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.stats.acuracia, 960, 803, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.stats.destreza, 960, 843, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    love.graphics.printf( playerUm.stats.critico, 960, 883, 150, "left", 0, 2, 2, 0, 0, 0, 0 )

    if estado == "movimento"
    then
        love.graphics.printf( "COMANDOS", 80, 673, 80, "left", 0, 3, 3, 0, 0, 0, 0 )
        love.graphics.printf( "W - Mover para frente", 80, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - Mover para trás", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "A - Mover para esqueda", 80, 803, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "D - Mover para direita", 80, 843, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "I - Abrir Inventario", 80, 883, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    elseif estado == "inventario"
    then
        love.graphics.printf( "COMANDOS", 80, 673, 80, "left", 0, 3, 3, 0, 0, 0, 0 )
        love.graphics.printf( "X - Usar poção de XP", 80, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "V - Usar poção de vida", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "A - Usar poção de ataque", 80, 803, 170, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - Sair do inventario", 80, 843, 170, "left", 0, 2, 2, 0, 0, 0, 0 )
    elseif estado == "bau"
    then
        love.graphics.printf( "COMANDOS", 80, 673, 80, "left", 0, 3, 3, 0, 0, 0, 0 )
        love.graphics.printf( "K - abrir bau", 80, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - sair ", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    elseif estado == "bauSemChave"
    then
        love.graphics.printf( "Você não possui chave para abrir o bau!!", 80, 673, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - sair para procurar uma chave", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    elseif estado == "combate"
    then
        love.graphics.printf( "BATALHA!!!", 80, 673, 80, "left", 0, 3, 3, 0, 0, 0, 0 )
        love.graphics.printf( "Z - Atacar", 80, 723, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "X - Fugir", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "C - Usar poção", 80, 803, 150, "left", 0, 2, 2, 0, 0, 0, 0 )

    elseif estado == "vitoria"
    then
        love.graphics.printf( "Você ganhou a batalha!!", 80, 673, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - sair para o labirinto", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    
    elseif estado == "semPocao"
    then
        love.graphics.printf( "Você esta sem esse tipo de poção!!", 80, 673, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
        love.graphics.printf( "S - continuar", 80, 763, 150, "left", 0, 2, 2, 0, 0, 0, 0 )
    end
    

    love.graphics.draw(playerUm.arma.imgEquipamento, 1173, 760)

    love.graphics.draw(playerUm.armadura.imgEquipamento, 990, 662)

    for l=1,3,1
    do
        for c=1,4,1
        do
            if(matrizInventario[l][c] == "V")
            then
                love.graphics.draw(vazio1,tamanho2*c + 1292, tamanho2*l + 590)

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
            playerUm.pocaoXp = playerUm.pocaoXp + 1
        elseif x == 2 then
            preencheInventario("L")
            playerUm.pocaoVida = playerUm.pocaoVida + 1
        elseif x == 3 then
            preencheInventario("A")
            playerUm.pocaoDano = playerUm.pocaoDano + 1
        elseif x == 4 then
                playerUm.armadura = ArmPano
        elseif x == 5 then
                playerUm.arma = machado
        elseif x == 6 then
                playerUm.armadura = ArmFerro
        elseif x == 7 then
                playerUm.arma = cajado
        elseif x == 8 then
                playerUm.armadura = ArmMadeira
        elseif x == 9 then
                playerUm.arma = espada
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
        estado = "combate"

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

function removeItem(item)

    for l=1,3,1 do
        for c=1,4,1 do
            if matrizInventario[l][c] == item
            then
                matrizInventario[l][c] = "V"
                return
            end
        end
    end
end

function love.keypressed(key, scancode, isrepeat)

    if(estado == "movimento") then
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

        elseif key == "i" then
            estado = "inventario"
        end

    elseif(estado == "bau") then
        if key == "k" then
            if (matriz[linha1][coluna1] == "X") and (matriz[linha2][coluna2] == "B") and (matriz[linha3][coluna1] == "X") then
                for l=1,3,1 do
                    for c=1,4,1 do
                        if matrizInventario[l][c] == "K" then
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
                        else
                            estado = "bauSemChave"
                        end
                    end
                end
            end
        elseif key == "s" then
            estado = "movimento"
        end

    elseif(estado == "bauSemChave")
    then
        if key == "s" then
            estado = "movimento"
        end

    elseif estado == "inventario" then
        if key == "x" then
            if playerUm.pocaoXp > 0 then
                playerUm.xp = playerUm.xp + 30
                playerUm.pocaoXp = playerUm.pocaoXp - 1
                removeItem("C")
            else
                estado = "semPocao"
            end

        elseif key == "v" then
            if playerUm.pocaoVida > 0 then
                playerUm.vitalidade = vitalidadeTotal
                playerUm.pocaoVida = playerUm.pocaoVida - 1
                removeItem("L")
            else
                estado = "semPocao"
            end

        elseif key == "a" then
            if playerUm.pocaoDano > 0 then
                playerUm.stats.ataque = playerUm.stats.ataque + 30
                playerUm.pocaoDano = playerUm.pocaoDano -1
                removeItem("A")
            else
                estado = "semPocao"
            end

        elseif key == "s" then
            estado = "movimento"
        end


    elseif(estado == "semPocao") then
        if key == "s" then
            estado = "inventario"
        end

    elseif(estado == "combate")
    then
        if key == "z" then
            while (playerUm.vitalidade > 0) or (monstro.vitalidade > 0) do
                combatePE()
                if monstro.vitalidade > 0 then
                    combateEP()
                end
            end

            if monstro.vitalidade <= 0 then
                estado = "vitoria"
            else
                estado = "derrota"
            end

        elseif key == "x" then
            while (playerUm.vitalidade > 0) or (monstro.vitalidade > 0) do
                combateEP()
                if monstro.vitalidade > 0 then
                    combatePE()
                end
            end

            if monstro.vitalidade <= 0 then
                estado = "vitória"
            else
                estado = "derrota"
            end
        end

    elseif(estado == "vitorio")
    then
        if mapa[posLin-1][posCol] == "M" then
            mapa[posLin-1][posCol] = "Y"
        elseif mapa[posLin+1][posCol] == "M" then
            mapa[posLin+1][posCol] = "Y"
        elseif mapa[posLin][posCol-1] == "M" then
            mapa[posLin][posCol-1] = "Y"
        elseif mapa[posLin][posCol+1] == "M" then
            mapa[posLin][posCol+1] = "Y"
        end
        if key == "s" then
            estado = "movimento"
        end
    end
end