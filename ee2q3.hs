-- Pepise-Cola, Guaraná Polo Norte e Guaraná Quate

-- Cada cliente leva 1000 ms para encher seu copo com o refrigerante.

-- Porém a maquina só pode ser utilizada por uma pessoa por vez.

-- Cada cliente enche seu copo com 300 ml de refrigerante e a máquina suporta apenas
-- 2000 ml de cada refrigerante, ou seja, 6000 ml no total.

-- Para evitar transtorno, sempre que um refrigerante
-- possuir menos que 1000 ml, ele é reposto com um refil de 1000 ml. 

-- Para repor o refrigerante, a máquina não pode estar sendo utilizada por nenhum cliente e 
-- demora 1500 ms para reposição.

-- utilize o conceito de Variáveis Mutáveis em Haskell. 

module Main where
import Control.Concurrent
import Control.Concurrent.MVar

consomeThread :: MVar (Int,Int,Int) -> Int -> String -> IO()
consomeThread maquina nCliente refri = loop
    where 
        loop = do
            (pc,gpn,gq) <- takeMVar maquina
            threadDelay 1000
            let newMaquina = (consomeMaquina (pc,gpn,gq) refri)
            putStrLn ("O cliente "++ show nCliente ++" do refrigerante " ++ refri ++ " está enchenco seu copo")
            putMVar maquina newMaquina
            loop

encheThread :: MVar (Int,Int,Int) -> IO()
encheThread maquina = loop
    where
        loop = do 
            (pc,gpn,gq) <- takeMVar maquina
            let (newPC,newGPN,newGQ) = (encheMaquina pc, encheMaquina gpn, encheMaquina gq)
            let delayEncher = 1500
            if pc /= newPC then do
                putStrLn ("O refrigerante Pepise-Cola foi reabastecido com 1000 ml, e agora possui "++ show newPC ++"ml")
                threadDelay delayEncher
            else
                return ()
            if gpn /= newGPN then do
                putStrLn ("O refrigerante Guaraná Polo Norte foi reabastecido com 1000 ml, e agora possui "++ show newGPN ++"ml")
                threadDelay delayEncher
            else 
                return()
            if gq /= newGQ then do
                putStrLn ("O refrigerante Guaraná Quate foi reabastecido com 1000 ml, e agora possui "++ show newGQ ++"ml")
                threadDelay delayEncher
            else
                return()

            let newMaquina = (newPC,newGPN,newGQ)
            putMVar maquina newMaquina
            loop

consomeMaquina :: (Int,Int,Int) -> String -> (Int,Int,Int)
consomeMaquina (pc,gpn,gq) "Pepise-Cola" = (pc-300,gpn,    gq)
consomeMaquina (pc,gpn,gq) "Guaraná Polo Norte" = (pc,    gpn-300,gq)
consomeMaquina (pc,gpn,gq) "Guaraná Quate" = (pc,    gpn,    gq-300)

encheMaquina :: Int -> Int
encheMaquina x  = if x < 1000 then x+1000 else x

getRefriMls :: (Int,Int,Int) -> String -> Int
getRefriMls (pc,_,_) "Pepise-Cola" =        pc
getRefriMls (_,gpn,_) "Guaraná Polo Norte" = gpn
getRefriMls (_,__,gq) "Guaraná Quate" =      gq


main :: IO()
main = do   maquinaMVar <- newMVar (2000,2000,2000)
            forkIO (encheThread maquinaMVar)

            forkIO (consomeThread maquinaMVar 1 "Pepise-Cola")
            forkIO (consomeThread maquinaMVar 2 "Guaraná Polo Norte")
            forkIO (consomeThread maquinaMVar 3 "Guaraná Quate")

            forkIO (consomeThread maquinaMVar 4 "Pepise-Cola")
            forkIO (consomeThread maquinaMVar 5 "Guaraná Polo Norte")

            forkIO (consomeThread maquinaMVar 6 "Pepise-Cola")

            threadDelay 500000
            return()
