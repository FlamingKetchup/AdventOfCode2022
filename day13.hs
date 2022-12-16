import Data.List.Split
import Data.List
import Data.Char

data Packet = IntVal Int | List [Packet] deriving (Show, Read, Eq)

instance Ord Packet where
    IntVal a `compare` IntVal b = a `compare` b
    List a `compare` List b = a `compare` b
    List a `compare` IntVal b = List a `compare` List [IntVal b]
    IntVal a `compare` List b = List [IntVal a] `compare` List b

readPacket :: String -> Packet
readPacket input = let
    a = split (dropBlanks $ whenElt isDigit) input
    b = concat $ map (split $ dropInitBlank $
                      dropFinalBlank $ dropInnerBlanks $ oneOf "[") a
    c = concat [case x of
        "[" -> "List ["
        _ | isDigit $ head x -> "IntVal " ++ x
        _ -> x
        | x <- b] in read c
        
main = do
    file <- readFile "day13input.txt"
    let asLines = lines file
        linePairs = splitOn [""] asLines
        pairs = [(readPacket a, readPacket b)| a:b:[] <- linePairs]
    putStr "Part 1: "
    print $ sum [n | (n, x) <- zip [1..] $ map (uncurry (<)) pairs, x]
    let dividers = [List [List [IntVal 2]], List [List [IntVal 6]]]
        packets = (map readPacket $ concat linePairs) ++ dividers
    putStr "Part 2: "
    print $ product $ map (+1) $ findIndices (`elem` dividers) $ sort packets
