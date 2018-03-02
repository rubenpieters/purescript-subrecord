module Test.Main where

import Prelude

import Control.Monad.Eff
import Control.Monad.Eff.Console (log)

import Test.Data.SubRecord as Data.SubRecord
import Test.Data.SubRecord.Builder as Data.SubRecord.Builder

main :: Eff _ Unit
main = do
  log "Data.SubRecord"
  Data.SubRecord.main
  Data.SubRecord.Builder.main
