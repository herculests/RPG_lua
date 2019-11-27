local mapa = {}
local mapaFog = {}
local matriz = {}
local matrizInventario = {}
local mapar = {}
local aux = {}
local posCol = 2
local posLin = 2
local posColr = 27
local posLinr = 18
local img
local estado = "menu"
local vitalidadeTotal = 300
local xpTotal = 200
local bauEquipamento
local portal = 1
local fundo
local aa
local mensagens = " "
local dano = " "
local danoAtaque = " "


Player = require 'Player'
Stats = require 'Stats'
Equipamento = require 'Equipamento'
Blocks = require 'Blocks'
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

function LoadMapFog(MatrizFog)
    local fileFog = io.open(MatrizFog, "r")
    local x = 1
    for lineFog in fileFog:lines() 
    do
        mapaFog[x] = {}
        for j=1, #lineFog, 1 
        do
            mapaFog[x][j] = lineFog:sub(j,j)
        end
        x = x + 1
    end
    fileFog:close()
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



function atualizaXp(xp)
    playerUm.xp = playerUm.xp + xp

    if playerUm.xp > xpTotal then
        playerUm.xp = playerUm.xp - xpTotal
        playerUm.nivel = playerUm.nivel + 1
        playerUm.stats.ataque = playerUm.stats.ataque + 5
        playerUm.stats.defesa = playerUm.stats.defesa + 4
        playerUm.stats.acuracia = playerUm.stats.acuracia + 3
        playerUm.stats.critico = playerUm.stats.critico + 3
        playerUm.stats.destreza = playerUm.stats.destreza + 1
        xpTotal = xpTotal + 50
        vitalidadeTotal = vitalidadeTotal + 50
        
    end
end

function combatePE()

    plyAtaque = playerUm.stats.ataque + playerUm.arma.stats.ataque + playerUm.armadura.stats.ataque
    plyAcuracia = playerUm.stats.acuracia + playerUm.arma.stats.acuracia + playerUm.armadura.stats.acuracia
    plyCritico = playerUm.stats.critico + playerUm.arma.stats.critico + playerUm.armadura.stats.critico
    critico = 1

    if math.random(1, 3) <= plyCritico then
        critico = 2
    end

    if math.random(1, monstro.stats.destreza) <= plyAcuracia then
        ataque = plyAtaque * critico - monstro.stats.defesa
        ataque = math.max( ataque,0 )
        monstro.vitalidade = monstro.vitalidade - ataque
        mensagens = "Jogador ataca o inimigo"
        dano = "causando dano de "
        danoAtaque = ataque

    else
        mensagens = "Jogador erra ataque."
        dano = " "
        danoAtaque = " "
    end    

end

function combateEP()    

    plyDefesa = playerUm.stats.defesa + playerUm.arma.stats.defesa + playerUm.armadura.stats.defesa
    plyDestreza = playerUm.stats.destreza + playerUm.arma.stats.destreza + playerUm.armadura.stats.destreza
    critico = 1

    if math.random(1, 3) <= monstro.stats.critico then
        critico = 2
    end

    if math.random(1, plyDestreza) <= monstro.stats.acuracia then
        ataque = monstro.stats.acuracia * critico - plyDefesa
        ataque = math.max(ataque, 0)
        playerUm.vitalidade = playerUm.vitalidade - ataque
        mensagens = "Inimigo ataca o jogador"
        dano = "causando dano de "
        danoAtaque = ataque

    else
        mensagens = "Inimigo erra ataque."
        dano = " "
        danoAtaque = " "
    end
    estado = "msg"

end

function love.load()
    LoadMap("RPG_lua/Matriz.txt")
    LoadMapFog("RPG_lua/Fog.txt")

    blocks = Blocks:new()

    --                     (ataque, defesa, acuracia, critico, destreza)
    ststsEspada = Stats:new(10, 00, 20, 4, 7)
    ststsCajado = Stats:new(05, 00, 26, 3, 10)
    ststsMachado = Stats:new(08, 00, 14, 1, 7)
    ststsArmFerro = Stats:new(3, 13, 13, 3, 6)
    ststsArmMadeira = Stats:new(2, 7, 13, 2, 9)
    ststsArmPano = Stats:new(00, 4, 18, 5, 16)

    ststsMonstro = Stats:new(30, 14, 19, 13, 21)
    ststsMonstroA = Stats:new(25, 11, 22, 12, 16)
    ststsMonstroB = Stats:new(22, 12, 32, 9, 22)
    ststsMonstroC = Stats:new(19, 10, 30, 7, 10)
    ststsVazio = Stats:new(0, 0, 0, 0, 0)

    ststsPlayer = Stats:new(37, 15, 46, 12, 37)


    --                      (nome, img, stats, tipo)
    espada = Equipamento:new("Espada", "imagens/espada.png", ststsEspada, "arma")
    cajado = Equipamento:new("Cajado", "imagens/cajado.png", ststsCajado, "arma")
    machado = Equipamento:new("Machado", "imagens/machado.png", ststsMachado, "arma")
    ArmFerro = Equipamento:new("ArmaduraFerro", "imagens/capaceteFerro.png", ststsArmFerro, "armadura")
    ArmMadeira = Equipamento:new("ArmaduraMadeira", "imagens/capaceteMadeira.png", ststsArmMadeira, "armadura")
    ArmPano = Equipamento:new("ArmaduraFragil", "imagens/touca.png", ststsArmPano, "armadura")
    vazio = Equipamento:new("vazio", "imagens/vazio.png", ststsVazio, "aleatório")


    --                   (arma, armadura, stats)
    playerUm = Player:new(vazio, vazio, ststsPlayer)

    imonstroB = love.graphics.newImage("imagens/monstroB.png")
    imonstroA = love.graphics.newImage("imagens/monstroA.png")
    imonstroC = love.graphics.newImage("imagens/monstroC.png")
    imonstro3 = love.graphics.newImage("imagens/monstro3.png")


    --                  (stats,img) 
    monstroD = Enemy:new(ststsMonstro,imonstro3)
    monstroA = Enemy:new(ststsMonstroA,imonstroA)
    monstroB = Enemy:new(ststsMonstroB,imonstroB)
    monstroC = Enemy:new(ststsMonstroC,imonstroC)

    love.keyboard.setKeyRepeat(true)

    love.window.setMode( 1792, 1000, {resizable=false} )
    
    LoadInv("RPG_lua/Inventario.txt")

    heroi = love.graphics.newImage("imagens/heroi.png")
    bauabertoCorredor = love.graphics.newImage("imagens/bauabertoCorredor.png")
    bauabertoCorredora = love.graphics.newImage("imagens/bauabertoCorredora.png")
    corredorChave = love.graphics.newImage("imagens/corredorChave.png")
    vazio1 = love.graphics.newImage("imagens/vazio.png")
    aa = love.graphics.newImage("imagens/vazio.png")
    esqueleto = love.graphics.newImage("imagens/esqueleto.png")
    pergaminho2 = love.graphics.newImage("imagens/pergaminho2.png")
    corote = love.graphics.newImage("imagens/corote.png")
    coroteAgilidade = love.graphics.newImage("imagens/coroteAgilidade.png")
    coroteVida = love.graphics.newImage("imagens/coroteVida.png")
    chave = love.graphics.newImage("imagens/chave.png")
    fim = love.graphics.newImage("imagens/fim.png")
    fundo = love.graphics.newImage("imagens/fundo.png")
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
    fog = love.graphics.newImage("imagens/fog.png")
    menu = love.graphics.newImage("imagens/menu.png")
    morte = love.graphics.newImage("imagens/morte.png")
    

    sound = love.audio.newSource("musicas/Deserto.ogg", "stream")
    mmenu = love.audio.newSource("musicas/mmenu.mp3", "stream")
    morteFim = love.audio.newSource("musicas/morteFim.wav", "stream")
    mmonstro = love.audio.newSource("musicas/monstro.wav", "stream")
    love.audio.play(mmenu)
    final = love.audio.newSource("musicas/final.ogg", "stream")
    mportal = love.audio.newSource("musicas/mportal.wav", "stream")
    pegarItem = love.audio.newSource("musicas/pegarItem.wav", "stream")
    beber = love.audio.newSource("musicas/beber.wav", "stream")
    cair = love.audio.newSource("musicas/cair.ogg", "stream")
    bauAbrindo = love.audio.newSource("musicas/bauAbrindo.wav", "stream")

    normal =love.graphics.newFont(18)
    font = love.graphics.newFont("fonte.ttf", 25)
    love.graphics.setFont(font)

end

function love.draw()
    local tamanho = 32

    for linha=1,19,1 do
        for coluna=1,28,1 do
            love.graphics.draw(Blocks:get("Y"), tamanho*coluna-tamanho, tamanho*linha-tamanho)
            love.graphics.draw(Blocks:get(mapa[linha][coluna]), tamanho*coluna-tamanho, tamanho*linha-tamanho)
        end
    end

    for linha=1,19,1 do
        for coluna=1,28,1 do
            if mapaFog[linha][coluna] == "F" then
                love.graphics.draw(fog, tamanho*coluna-tamanho, tamanho*linha-tamanho)

            elseif mapaFog[linha][coluna] == "V" then
                love.graphics.draw(vazio1, tamanho*coluna-tamanho, tamanho*linha-tamanho)

            end
        end
    end

    love.graphics.draw(heroi, tamanho*posCol-tamanho, tamanho*posLin-tamanho)

    local tamanho2 = 90

    love.graphics.draw(img, 896, 0)
    love.graphics.draw(pergaminho2, 896, 0)
    love.graphics.draw(pergaminho, 0, 613)
    love.graphics.draw(inventario, 1351, 640)
    love.graphics.draw(inv, 1413, 628)
    love.graphics.draw(esqueleto, 1080, 710)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Vitalidade: "..playerUm.vitalidade.." / "..vitalidadeTotal, 933, 43, 300, "left")
    love.graphics.printf("Pocões: "..playerUm.pocaoDano + playerUm.pocaoVida + playerUm.pocaoXp, 933, 83, 300, "left")
    love.graphics.printf("Nível: "..playerUm.nivel, 1553, 43, 300, "left")
    love.graphics.printf( "XP: "..playerUm.xp.." / ".. xpTotal, 1553, 83, 300, "left")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Vitalidade: "..playerUm.vitalidade.." / "..vitalidadeTotal, 930, 40, 300, "left")
    love.graphics.printf("Pocões: "..playerUm.pocaoDano + playerUm.pocaoVida + playerUm.pocaoXp, 930, 80, 300, "left")
    love.graphics.printf("Nível: "..playerUm.nivel, 1550, 40, 300, "left")
    love.graphics.printf( "XP: "..playerUm.xp.." / ".. xpTotal, 1550, 80, 300, "left")


    love.graphics.printf( "STATUS", 482, 675, 400, "left")
    love.graphics.printf( "ARMA    ".."ROUPA     ".."BASE", 732, 685, 500, "left")
    love.graphics.printf( "Forca:       "..playerUm.arma.stats.ataque + playerUm.armadura.stats.ataque + playerUm.stats.ataque.." pts            ".."+"..playerUm.arma.stats.ataque.."                 +"..playerUm.armadura.stats.ataque.."                  "..playerUm.stats.ataque, 482, 725, 700, "left")
    love.graphics.printf( "Defesa:     "..playerUm.arma.stats.defesa + playerUm.armadura.stats.defesa + playerUm.stats.defesa.." pts            ".."+"..playerUm.arma.stats.defesa.."                 +"..playerUm.armadura.stats.defesa.."                  "..playerUm.stats.defesa, 482, 765, 700, "left")
    love.graphics.printf( "Acurácia:  "..playerUm.arma.stats.acuracia + playerUm.armadura.stats.acuracia + playerUm.stats.acuracia.." pts            ".."+"..playerUm.arma.stats.acuracia.."                 +"..playerUm.armadura.stats.acuracia.."                  "..playerUm.stats.acuracia, 482, 805, 700, "left")
    love.graphics.printf( "Destreza:  "..playerUm.arma.stats.destreza + playerUm.armadura.stats.destreza + playerUm.stats.destreza.." pts            ".."+"..playerUm.arma.stats.destreza.."                 +"..playerUm.armadura.stats.destreza.."                  "..playerUm.stats.destreza, 482, 845, 700, "left")
    love.graphics.printf( "Crítico:     "..playerUm.arma.stats.critico + playerUm.armadura.stats.critico + playerUm.stats.critico.." pts             ".."+"..playerUm.arma.stats.critico.."                 +"..playerUm.armadura.stats.critico.."                  "..playerUm.stats.critico, 482, 885, 700, "left")
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf( "STATUS", 480, 673, 400, "left")
    love.graphics.printf( "ARMA    ".."ROUPA     ".."BASE", 730, 683, 500, "left")
    love.graphics.printf( "Forca:       "..playerUm.arma.stats.ataque + playerUm.armadura.stats.ataque + playerUm.stats.ataque.." pts            ".."+"..playerUm.arma.stats.ataque.."                 +"..playerUm.armadura.stats.ataque.."                  "..playerUm.stats.ataque, 480, 723, 700, "left")
    love.graphics.printf( "Defesa:     "..playerUm.arma.stats.defesa + playerUm.armadura.stats.defesa + playerUm.stats.defesa.." pts            ".."+"..playerUm.arma.stats.defesa.."                 +"..playerUm.armadura.stats.defesa.."                  "..playerUm.stats.defesa, 480, 763, 700, "left")
    love.graphics.printf( "Acurácia:  "..playerUm.arma.stats.acuracia + playerUm.armadura.stats.acuracia + playerUm.stats.acuracia.." pts            ".."+"..playerUm.arma.stats.acuracia.."                 +"..playerUm.armadura.stats.acuracia.."                  "..playerUm.stats.acuracia, 480, 803, 700, "left")
    love.graphics.printf( "Destreza:  "..playerUm.arma.stats.destreza + playerUm.armadura.stats.destreza + playerUm.stats.destreza.." pts            ".."+"..playerUm.arma.stats.destreza.."                 +"..playerUm.armadura.stats.destreza.."                  "..playerUm.stats.destreza, 480, 843, 700, "left")
    love.graphics.printf( "Crítico:     "..playerUm.arma.stats.critico + playerUm.armadura.stats.critico + playerUm.stats.critico.." pts             ".."+"..playerUm.arma.stats.critico.."                 +"..playerUm.armadura.stats.critico.."                  "..playerUm.stats.critico, 480, 883, 700, "left")
    love.graphics.setColor(1, 1, 1)

    if estado == "movimento"
    then
        love.graphics.printf( "COMANDOS", 82, 675, 500, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "COMANDOS", 80, 673, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "W - Mover para frente", 80, 723, 500, "left")
        love.graphics.printf( "S - Mover para trás", 80, 763, 500, "left")
        love.graphics.printf( "A - Mover para esqueda", 80, 803, 500, "left")
        love.graphics.printf( "D - Mover para direita", 80, 843, 500, "left")
        love.graphics.printf( "I - Abrir Inventario", 80, 883, 500, "left")
    elseif estado == "inventario"
    then
        love.graphics.printf( "COMANDOS", 82, 675, 500, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "COMANDOS", 80, 673, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "X - Usar pocão de XP", 80, 723, 500, "left")
        love.graphics.printf( "V - Usar pocão de vida", 80, 763, 500, "left")
        love.graphics.printf( "A - Usar pocão de forca", 80, 803, 500, "left")
        love.graphics.printf( "S - Sair do inventario", 80, 843, 500, "left")
    elseif estado == "bau"
    then
        love.graphics.printf( "COMANDOS", 82, 675, 500, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "COMANDOS", 80, 673, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "K - abrir bau", 80, 723, 500, "left")
        love.graphics.printf( "S - sair ", 80, 763, 500, "left")
    elseif estado == "bauSemChave"
    then
        love.graphics.printf( "Você não possui chave para abrir o bau!!", 80, 673, 300, "left")
        love.graphics.printf( "S - sair para procurar uma chave", 80, 763, 500, "left")
    elseif estado == "combate"
    then
        love.graphics.printf( "MONSTROOOO!!!", 82, 675, 500, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "MONSTROOOO!!!", 80, 673, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "Z - Atacar", 80, 723, 500, "left")
        love.graphics.printf( "X - Fugir", 80, 763, 500, "left")

    elseif estado == "ataquePlayer"
    then
        love.graphics.printf( "BATALHAA!!", 82, 675, 500, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "BATALHAA!!", 80, 673, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "K - Avancar turno", 80, 723, 500, "left")
        love.graphics.printf( "Vitalidade monstro:"..monstro.vitalidade, 80, 883, 500, "left")
        love.graphics.printf( mensagens, 80, 763, 500, "left")
        love.graphics.printf( dano, 80, 803, 500, "left")
        love.graphics.setColor(255, 0, 0)
        love.graphics.printf( danoAtaque, 290, 803, 500, "left")
        love.graphics.setColor(1, 1, 1)

    elseif estado == "ataqueMonstro"
    then
        love.graphics.printf( "BATALHAA!!", 82, 675, 500, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "BATALHAA!!", 80, 673, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "K - Avancar turno", 80, 723, 500, "left")
        love.graphics.printf( "Vitalidade monstro:"..monstro.vitalidade, 80, 883, 500, "left")
        love.graphics.printf( mensagens, 80, 763, 500, "left")
        love.graphics.printf( dano, 80, 803, 500, "left")
        love.graphics.setColor(255, 0, 0)
        love.graphics.printf( danoAtaque, 290, 803, 500, "left")
        love.graphics.setColor(1, 1, 1)
            

    elseif estado == "vitoria"
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
        img = imgad
        love.graphics.printf( "Você ganhou a batalha!!", 80, 673, 500, "left")
    
    elseif estado == "semPocao"
    then
        love.graphics.printf( "Você esta sem esse tipo de pocão!!", 80, 673, 500, "left")
        love.graphics.printf( "S - Continuar", 80, 763, 500, "left")
    
    elseif estado == "portal"
    then
        love.audio.play(mportal)

    elseif estado == "bauEquipamento"
    then
        love.graphics.printf( "Você encontrou um novo equipamento!!", 82, 675, 300, "left")
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf( "Você encontrou um novo equipamento!!", 80, 673, 300, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( bauEquipamento.nome, 80, 743, 500, "left")
        love.graphics.setColor(255, 0, 0)
        love.graphics.printf( "Forca:      "..bauEquipamento.stats.ataque, 82, 775, 500, "left")
        love.graphics.printf( "Defesa:    "..bauEquipamento.stats.defesa, 82, 798, 500, "left")
        love.graphics.printf( "Acuracia: "..bauEquipamento.stats.acuracia, 82, 821, 500, "left")
        love.graphics.printf( "Critico:    "..bauEquipamento.stats.critico, 82, 844, 500, "left")
        love.graphics.printf( "Destreza: "..bauEquipamento.stats.destreza, 82, 867, 500, "left")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf( "Forca:      "..bauEquipamento.stats.ataque, 80, 773, 500, "left")
        love.graphics.printf( "Defesa:    "..bauEquipamento.stats.defesa, 80, 796, 500, "left")
        love.graphics.printf( "Acuracia: "..bauEquipamento.stats.acuracia, 80, 819, 500, "left")
        love.graphics.printf( "Critico:    "..bauEquipamento.stats.critico, 80, 842, 500, "left")
        love.graphics.printf( "Destreza: "..bauEquipamento.stats.destreza, 80, 865, 500, "left")
        love.graphics.printf( "X - Para equipar                                                 S - Para sair.", 80, 898, 500, "left")
    
    elseif estado == "menu"
    then
        love.graphics.draw(menu, 0, 0)

    end

    

    love.graphics.draw(playerUm.arma.imgEquipamento, 1243, 760)

    love.graphics.draw(playerUm.armadura.imgEquipamento, 1060, 662)

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
    if estado == "portal" then
        if portal == 3 then
            estado = "fim"
            aa = fim

        else
            aa = fundo
            love.graphics.draw(aa, 0, 0)
        end
    elseif estado == "fim" then
        sound:setVolume(0)
        love.audio.play(final)
        love.graphics.draw(aa, 0, 0)

    elseif estado == "derrota"
    then
        sound:setVolume(0)
        love.audio.play(morteFim)
        love.graphics.draw(morte, 0, 0)

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

math.randomseed(os.clock())

function SORTEIO(ate)
    N = math.random(1,ate)
    return N
end

function itensBauArmadura()
    
    x = SORTEIO(3)
    if x == 1 then
        preencheInventario("C")
        playerUm.pocaoXp = playerUm.pocaoXp + 1
        estado = "movimento"
    elseif x == 2 then
        preencheInventario("L")
        playerUm.pocaoVida = playerUm.pocaoVida + 1
        estado = "movimento"
    elseif x == 3 then
        preencheInventario("A")
        playerUm.pocaoDano = playerUm.pocaoDano + 1
        estado = "movimento"
    end
    love.audio.play(pegarItem)
    x = SORTEIO(6)
    if x == 1 then
        bauEquipamento = ArmPano
        estado = "bauEquipamento"
    elseif x == 2 then
        bauEquipamento = machado
        estado = "bauEquipamento"
    elseif x == 3 then
        bauEquipamento = ArmFerro
        estado = "bauEquipamento"
    elseif x == 4 then
        bauEquipamento = cajado
        estado = "bauEquipamento"
    elseif x == 5 then
        bauEquipamento = ArmMadeira
        estado = "bauEquipamento"
    elseif x == 6 then
        bauEquipamento = espada
        estado = "bauEquipamento"
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
    elseif (mapa[posLin][posCol]) == "P" then
        estado = "portal"
    elseif (mapa[posLin][posCol]) == "C" then
        estado = "derrota"
        love.audio.play(cair)
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
        n = SORTEIO(3)
        if n == 1 then
            monstro = monstroA
        elseif n == 2 then
            monstro = monstroB
        elseif n == 3 then
            monstro = monstroC
        elseif n == 4 then
            monstro = monstroD
        end

        love.audio.play(mmonstro)
        img = monstro.img
        estado = "combate"

    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][colMaisUm] == "K") and (matriz[linMaisUm][col] == "X")
    then
        img = corredorChave
    elseif (matriz[linMenosUm][col] == "X") and (matriz[lin][col] == "K") and (matriz[linMaisUm][col] == "X")
    then
        love.audio.play(pegarItem)
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
            if (mapa[posLin][posCol + 1] == "Y") or (mapa[posLin][posCol + 1] == "K") or (mapa[posLin][posCol + 1] == "P") or (mapa[posLin][posCol + 1] == "C")
            then
                posCol = posCol + 1
                posColr =   posColr -1
                background()
            end

        elseif key == "a" then
            heroi = heroiA
            espelhaMatriz()
            if (mapa[posLin][posCol - 1] == "Y") or (mapa[posLin][posCol - 1] == "K") or (mapa[posLin][posCol - 1] == "C")
            then
                posCol = posCol - 1
                posColr = posColr +1
                background()
            end

        elseif key == "s" then
            heroi = heroiS
            espelhaMatriz()
            if (mapa[posLin + 1][posCol] == "Y") or (mapa[posLin + 1][posCol] == "K") or (mapa[posLin + 1][posCol] == "C")
            then
                posLin = posLin + 1
                posLinr = posLinr - 1
                background()
            end

        elseif key == "w" then
            heroi = heroiW
            espelhaMatriz()
            if (mapa[posLin - 1][posCol] == "Y") or (mapa[posLin - 1][posCol] == "K") or (mapa[posLin - 1][posCol] == "C")
            then
                posLin = posLin - 1
                posLinr = posLinr + 1
                background()
            end

        elseif key == "i" then
            estado = "inventario"
        end
        mapaFog[posLin][posCol] = "V"
        mapaFog[posLin+1][posCol] = "V"
        mapaFog[posLin-1][posCol] = "V"

        mapaFog[posLin][posCol+1] = "V"
        mapaFog[posLin+1][posCol+1] = "V"
        mapaFog[posLin-1][posCol+1] = "V"

        mapaFog[posLin][posCol-1] = "V"
        mapaFog[posLin+1][posCol-1] = "V"
        mapaFog[posLin-1][posCol-1] = "V"

    elseif(estado == "bau") then
        if key == "k" then
            for l=1,3,1 do
                for c=1,4,1 do
                    if matrizInventario[l][c] == "K" then
                        love.audio.play(bauAbrindo)
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
                        return

                    else
                        estado = "bauSemChave"
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
                love.audio.play(beber)
                atualizaXp(30)
                playerUm.pocaoXp = playerUm.pocaoXp - 1
                removeItem("C")
            else
                estado = "semPocao"
            end

        elseif key == "v" then
            if playerUm.pocaoVida > 0 then
                love.audio.play(beber)
                playerUm.vitalidade = vitalidadeTotal
                playerUm.pocaoVida = playerUm.pocaoVida - 1
                removeItem("L")
            else
                estado = "semPocao"
            end

        elseif key == "a" then
            if playerUm.pocaoDano > 0 then
                love.audio.play(beber)
                playerUm.stats.ataque = playerUm.stats.ataque + 12
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
            estado = "ataquePlayer"

        elseif key == "x" then
            w = SORTEIO(100)
            if w < 50 then
                estado = "ataqueMonstro"
                
            else
                estado = "movimento"
            end   
        end

    elseif estado == "ataquePlayer" then
        if key == "k" then
            combatePE()

            if monstro.vitalidade <= 0 then
                atualizaXp(50)
                estado = "vitoria"
                mensagens = " "
                dano = " "
                danoAtaque = " "

            else
                estado = "ataqueMonstro"
            end
        end

    elseif estado == "ataqueMonstro" then
        if key == "k" then
            combateEP()

            if playerUm.vitalidade <= 0 then
                estado = "derrota"

            else
                estado = "ataquePlayer"
            end
        end

    elseif estado == "vitoria"
    then
         
        estado = "movimento"

    elseif(estado == "derrota")
    then
        
        if key == "s" then
            love.event.quit()
        
        elseif key == "r" then
            love.event.quit( "restart" )
        end

    elseif(estado == "fim")
    then
        if key == "s" then
            love.event.quit()
        
        elseif key == "r" then
            love.event.quit( "restart" )
        end
    
    elseif(estado == "portal")
    then
        
        if key == "return" then
            if portal == 2 then
                LoadMap("RPG_lua/Matriz2.txt")
                LoadMapFog("RPG_lua/Fog.txt")
            else
                LoadMap("RPG_lua/Matriz3.txt")
                LoadMapFog("RPG_lua/Fog.txt")
            end
            
            posCol = 2
            posLin = 2
            posColr = 27
            posLinr = 18
            portal = portal + 1
            aa = vazio1
            estado = "movimento"
            img = imgad
        
        elseif key == "s" then
            estado = "movimento"
        end

    elseif(estado == "bauEquipamento")
    then
        if key == "x" then
            love.audio.play(pegarItem)
            if bauEquipamento.tipo == "arma" then
                playerUm.arma = bauEquipamento
            else
                playerUm.armadura = bauEquipamento
            end
            estado = "movimento"
        elseif key == "s" then
            estado = "movimento"
        end

    elseif(estado == "menu")
    then
        if key == "return" then
            
            estado = "movimento"
            mmenu:setVolume(0)
            love.audio.play(sound)
            sound:setVolume(0.5)
            menu = vazio1
        end

    end
end