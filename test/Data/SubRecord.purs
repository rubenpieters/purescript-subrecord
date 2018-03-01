module Test.Data.SubRecord where

import Prelude
import Types

import Data.Maybe
import Data.SubRecord
import Data.SubRecord.Builder as SubRecord
import Data.Symbol

import Control.Monad.Eff

import Test.Assert

testUn :: { x :: Int }
testUn = unSubRecord (\_ -> { x: 99 }) (testMk false)

testMk :: Boolean -> SubRecord ( x :: Int )
testMk b = if b
              then mkSubRecord { x: 1 }
              else mkSubRecord {}

testWithDef :: { x :: Int }
testWithDef = withDefaults { x: 99 } (testMk false)

testInsert :: SubRecord ( x :: Int, y :: String)
testInsert =
  SubRecord.build
    (SubRecord.insert (SProxy :: SProxy "x") (Just 42) >>>
     SubRecord.insert (SProxy :: SProxy "y") Nothing
    ) (mkSubRecord {})

testInsertSRWithDef :: { x :: Int, y :: String}
testInsertSRWithDef = withDefaults { x: 1, y: "default"} testInsert

main :: Eff _ Unit
main = do
  assert $ testWithDef.x == 99
  assert $ testInsertSRWithDef.x == 42
  assert $ testInsertSRWithDef.y == "default"
