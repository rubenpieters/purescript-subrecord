module Test.Main where

import Prelude

import Control.Monad.Eff
import Control.Monad.Eff.Console (log)

import Test.Data.SubRecord as Data.SubRecord

main :: Eff _ Unit
main = do
  log "Data.SubRecord"
  Data.SubRecord.main
