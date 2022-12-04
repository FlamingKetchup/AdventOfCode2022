import Data.Char
import Data.List
import Data.List.Split

priority :: Char -> Int
priority item
    | isLower item = ord item - 96
    | isUpper item = ord item - 64 + 26
    | otherwise = error $ "Non alphabetical character '" ++ [item] ++ "'"
        
commonItem :: String -> Char
commonItem rucksack = let
    (compartment1, compartment2) = splitAt (length rucksack `div` 2) rucksack
    in head $ intersect compartment1 compartment2

badge :: [String] -> Char
badge (a:b:c:[]) = head $ a `intersect` b `intersect` c

main = do
    file <- readFile "day3input.txt"
    let asLines = lines file
        groups = chunksOf 3 asLines
    putStrLn $ "Part 1: " ++ (show $ sum $ map (priority . commonItem) asLines)
    putStrLn $ "Part 2: " ++ (show $ sum $ map (priority . badge) groups)
