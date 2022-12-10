{-# LANGUAGE ViewPatterns #-}
import Data.List
import Data.List.Split

data Instruction = Noop | Addx Int deriving Show

main = do
    file <- readFile "day10input.txt"
    let asLines = lines file
        instructions = [case line of
            "noop" -> Noop
            (stripPrefix "addx " -> Just n) -> Addx $ (read :: String -> Int) n
            | line <- asLines]
        xs = concat $ scanl' (\(last -> x) inst -> case inst of
            Noop -> [x]
            Addx n -> [x, x + n]) [1] instructions
    putStr "Part 1: "
    print $ sum [cycle * xs !! (cycle - 1) | cycle <- take 6 $ iterate (+ 40) 20]
    let image = [if abs (x - pos `mod` 40) <= 1 then '#' else '.' | (x, pos) <- zip xs [0..]]
    print $ xs !! 40
    sequence_ $ map putStrLn $ chunksOf 40 image
