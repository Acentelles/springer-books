module Main where

import Lib
import System.Environment

main :: IO ()
main = do
  [topic] <- getArgs
  downloadBooks topic
