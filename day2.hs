import Data.List.Split
import Data.List

data Shape = R | P | S deriving (Eq, Show)

toShape :: Char -> Shape
toShape char = case char of
    'A' -> R
    'B' -> P
    'C' -> S
{- Part 1    'X' -> R
    'Y' -> P
    'Z' -> S-}
    _ -> error $ "Invalid Character: " ++ [char]

shapeForOutcome :: Shape -> Char -> Shape
shapeForOutcome shape outcome = case (shape, outcome) of
    (R, 'X') -> S -- Lose vs.
    (P, 'X') -> R
    (S, 'X') -> P
    (R, 'Z') -> P -- Win vs.
    (P, 'Z') -> S
    (S, 'Z') -> R
    (a, 'Y') -> a -- Draw
outcome :: (Shape, Shape) -> Integer
outcome pairing = case pairing of
    (R, P) -> 6
    (R, S) -> 0
    (P, S) -> 6
    (P, R) -> 0
    (S, R) -> 6
    (S, P) -> 0
    (a, b) | a == b -> 3

shapeScore :: Shape -> Integer
shapeScore shape = case shape of
    R -> 1
    P -> 2
    S -> 3

main = do
    file <- readFile "day2input.txt"
    let asLines = lines file
        shapes = [(toShape x, shapeForOutcome (toShape x) y) | (x:_:y:[]) <- asLines]
        scores = [outcome (opponent, you) + shapeScore you | (opponent, you) <- shapes]
    print $ sum scores
