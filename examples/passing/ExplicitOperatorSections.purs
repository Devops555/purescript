module Main where

import Prelude
import Effect.Console (log)

subtractOne :: Int -> Int
subtractOne = (_ - 1)

addOne :: Int -> Int
addOne = (1 + _)

named :: Int -> Int
named = (_ `sub` 1)

main = log "Done"
