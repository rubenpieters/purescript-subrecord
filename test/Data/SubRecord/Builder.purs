module Test.Data.SubRecord.Builder where

import Prelude
import Types

import Data.Maybe
import Data.SubRecord
import Data.SubRecord.Builder as SubRecord
import Data.Symbol

import Control.Monad.Eff

import Test.Assert

testInsert :: SubRecord ( x :: Int, y :: String )
testInsert =
  SubRecord.build
    (SubRecord.insert (SProxy :: SProxy "x") (Just 42) >>>
     SubRecord.insert (SProxy :: SProxy "y") Nothing
    ) (mkSubRecord {})

testInsertWithDef :: { x :: Int, y :: String}
testInsertWithDef = withDefaults { x: 1, y: "default"} testInsert



main :: Eff _ Unit
main = do
  assert $ testInsertWithDef.x == 42
  assert $ testInsertWithDef.y == "default"
