import Data.List

addPos :: (Int, Int) -> (Int, Int) -> (Int, Int)
addPos (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

moveTowards :: (Int, Int) -> (Int, Int) -> (Int, Int)
moveTowards (tx, ty) (hx, hy) = let (dx, dy) = (hx - tx, hy - ty) in
    let move x | x >= 1 = 1
               | x <= -1 = -1
               | otherwise = 0 in
    if abs dx > 1 || abs dy > 1 then
    (move dx + tx, move dy + ty)
    else (tx, ty)

main = do
    file <- readFile "day9input.txt"
    let asLines = lines file
        movements = concat [let steps = read stepsStr :: Int in
            case dir of
                'U' -> replicate steps (0, 1)
                'D' -> replicate steps (0, -1)
                'L' -> replicate steps (-1, 0)
                'R' -> replicate steps (1, 0)
            | dir:' ':stepsStr <- asLines]
        headPos = scanl addPos (0, 0) movements
        trailingPos = tail $ take 10 $ iterate (scanl' moveTowards (0, 0)) headPos
    putStr "Part 1: "
    print $ length $ nub $ head trailingPos
    putStr "Part 2: "
    print $ length $ nub $ last trailingPos
