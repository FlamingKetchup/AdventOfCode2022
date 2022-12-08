import Data.List

parseInput :: [String] -> [[Integer]]
parseInput = map (map ((read :: String -> Integer) . (:[])))

greaterThanPrevL :: [Integer] -> [Bool]
greaterThanPrevL xs = snd $ mapAccumL (\a b -> (max a b, a < b)) (-1) xs

greaterThanPrevR :: [Integer] -> [Bool]
greaterThanPrevR xs = snd $ mapAccumR (\a b -> (max a b, a < b)) (-1) xs

matrixBiMap :: (a -> a -> a) -> [[a]] -> [[a]] -> [[a]]
matrixBiMap f = curry $ map (map (uncurry f) . uncurry zip) . uncurry zip

viewingDistancesR :: [Integer] -> [Int]
viewingDistancesR line = [case findIndex (>= tree) rightOf of
    Just x -> x + 1
    Nothing -> length rightOf
    | tree:rightOf <- init $ tails line]

viewingDistancesL :: [Integer] -> [Int]
viewingDistancesL = reverse . viewingDistancesR . reverse

main = do
    file <- readFile "day8input.txt"
    let asLines = lines file
        matrix = parseInput asLines
        left = map greaterThanPrevL matrix
        right = map greaterThanPrevR matrix
        top = transpose $ map greaterThanPrevL $ transpose matrix
        bottom = transpose $ map greaterThanPrevR $ transpose matrix
        combined = foldr1 (matrixBiMap (||)) [left, right, top, bottom]
    putStr "Part 1: "
    print $ length $ filter id $ concat combined
    let toLeft = map viewingDistancesL matrix
        toRight = map viewingDistancesR matrix
        toTop = transpose $ map viewingDistancesL $ transpose matrix
        toBot = transpose $ map viewingDistancesR $ transpose matrix
        scenicScores = foldr1 (matrixBiMap (*)) [toLeft, toRight, toTop, toBot]
    putStr "Part 2: "
    print $ maximum $ concat scenicScores
