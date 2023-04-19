math.randomseed(19042023)
hp_pikachu = 800
hp_raichu = 1000

function Ataque()
    local n = math.random(1, 20)
    if n >= 1 and n <= 10 then
        return "Choque do trovão", 50
    elseif n >= 11 and n <= 15 then
        return "Calda de ferro", 100
    elseif n >= 16 and n <= 18 then
        return "Investida trovão", 150
    else
        return "Trovão", 200
    end
end

function Turno(pokemon)
    local pokemon = pokemon

    while true do
        print(pokemon)
        
        if pokemon == "Pikachu" and hp_pikachu <= 0 then
            print("está fora de combate! Raichu venceu a batalha!")
            return
        elseif pokemon == "Raichu" and hp_raichu <= 0 then
            print("está fora de combate! Pikachu venceu a batalha!")
            return
        end
        
        print('hp_pikachu:' .. hp_pikachu)
        print('hp_raichu:' .. hp_raichu)
        local nome_atk, dano = Ataque()

        if pokemon == "Pikachu" then
            hp_raichu = math.max(0,hp_raichu - dano)
        else
            hp_pikachu = math.max(0,hp_pikachu - dano)
        end

        print(pokemon .. " usou " .. nome_atk .. " causando " .. dano .. " de dano")
        print()

        if hp_raichu <=0 or hp_pikachu <= 0 then
            return
        end

        -- Suspendemos apenas a corrotina do pikachu pois se suspendessemos ambas, as duas ficariam suspensas
        if pokemon == "Pikachu" then
            coroutine.resume(co_raichu,"Raichu")
        else
            coroutine.resume(co_pikachu, 'Pikachu')
            coroutine.yield()
        end
    end
end

co_pikachu = coroutine.create(Turno)
co_raichu = coroutine.create(Turno)

coroutine.resume(co_pikachu,"Pikachu")