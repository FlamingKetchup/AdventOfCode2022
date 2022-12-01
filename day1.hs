import Data.List.Split
import Data.List

main = do
    file <- readFile "day1input.txt"
    a <- return $ lines file
    b <- return $ splitOn [""] a
    c <- return $ (map $ map (read :: String -> Int)) b
    -- Part 1 print $ maximum $ map sum c
    print $ sum $ take 3 $ reverse $ sort $ map sum c
    
