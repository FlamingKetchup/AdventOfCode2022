import Data.List.Split
import Data.List

lineToEndpoints :: String -> ((Integer, Integer), (Integer, Integer))
lineToEndpoints line = let
    elf1:elf2:[] = splitOn "," line
    (start1:end1:[], start2:end2:[]) = (splitOn "-" elf1, splitOn "-" elf2)
    in ((read start1, read end1), (read start2, read end2))

contains :: ((Integer, Integer), (Integer, Integer)) -> Bool
contains ((start1, end1), (start2, end2)) =
    start1 <= start2 && end1 >= end2 || start1 >= start2 && end1 <= end2

main = do
    file <- readFile "day4input.txt"
    let asLines = lines file
        endpoints = map lineToEndpoints asLines
        ranges = [([start1..end1], [start2..end2])
                 |((start1, end1), (start2, end2)) <- endpoints]
    putStr "Part 1: "
    print $ length $ filter contains endpoints
    putStr "Part 2: "
    print $ length $ filter (not . null) $ map (uncurry intersect) ranges
