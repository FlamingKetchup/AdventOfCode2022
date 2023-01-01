{-# LANGUAGE QuasiQuotes #-}
import qualified Data.HashMap.Strict as Map
import qualified Data.BitSet.Dynamic as BitSet
import Data.BitSet.Dynamic hiding (map, filter, foldl')
import Data.List (foldl')
import Data.List.Split
import Text.Scanf

lineMatcher =
    scanf [fmt|Valve%c%chaflowrate=%d;tunnelleadtovalve%s|] . 
        filter (`notElem` [' ', 's'])

main = do
    file <- readFile "day16input.txt"
    let asLines = lines file
        valves = Map.fromList [([namePart1, namePart2],
                               (flowRate, splitOn "," tunnels))
            |Just (namePart1 :+ namePart2 :+ flowRate :+ tunnels :+ ()) <-
             map lineMatcher asLines]
        pressure :: Maybe String -> [String] -> Int -> String -> BitSet Int
        pressure _ _ 0 _ = singleton 0
        -- timeRemaining is the time remaining after the action of the 
        -- current call to pressure
        -- Thus, if 30 minutes remain, it would be 29 after the action
        pressure cameFrom openedValves timeRemaining currentValve =
            let (flowRate, tunnels) = valves Map.! currentValve
                usefulTunnels = case cameFrom of
                    Just x -> filter (/= x) tunnels
                    Nothing -> tunnels
                movementActions =
                    (foldl' union empty $ map (pressure (Just currentValve)
                        openedValves (timeRemaining - 1)) usefulTunnels) in
            if flowRate > 0 && currentValve `notElem` openedValves then
                (BitSet.map (+ (flowRate * timeRemaining)) $ pressure Nothing
                    (currentValve:openedValves)
                    (timeRemaining - 1) currentValve) `union` movementActions
            else movementActions
    putStr "Part 1: "
    print $ BitSet.foldl' max 0 $ pressure Nothing [] 29 "AA"
    {-
    pressure2 :: Maybe String -> [String] -> Int -> String -> BitSet Int
    pressure _ _ 0 _ = singleton 0
    pressure2 youCameFrom elephantCameFrom openedValves
              timeRemaining yourCurrentValve, elephantCurrentValve =
        let (flowRate, tunnels) = valves Map.! currentValve
            usefulTunnels = case cameFrom of
                Just x -> filter (/= x) tunnels
                Nothing -> tunnels
            movementActions =
                (foldl' union empty $ map (pressure (Just currentValve)
                    openedValves (timeRemaining - 1)) usefulTunnels) in
        if flowRate > 0 && currentValve `notElem` openedValves then
            (BitSet.map (+ (flowRate * timeRemaining)) $ pressure Nothing
                (currentValve:openedValves)
                (timeRemaining - 1) currentValve) `union` movementActions
        else movementActions-}
