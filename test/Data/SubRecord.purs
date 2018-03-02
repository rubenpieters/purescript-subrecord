module Test.Data.SubRecord where

import Prelude

import Data.Maybe (Maybe(..))
import Data.SubRecord
import Data.Symbol

import Control.Monad.Eff

import Test.Assert

testUn :: { x :: Int }
testUn = unSubRecord (\_ -> { x: 99 }) (testMk false)

testMk :: Boolean -> SubRecord ( x :: Int )
testMk b = if b
              then mkSubRecord { x: 1 }
              else mkSubRecord {}

testSubRecord :: SubRecord ( x :: Int, y :: String )
testSubRecord = mkSubRecord { x: 42 }

testWithDef :: { x :: Int, y :: String }
testWithDef = withDefaults { x: 99, y: "default" } testSubRecord

main :: Eff _ Unit
main = do
  assert $ testWithDef.x == 42
  assert $ testWithDef.y == "default"
  assert $ get (SProxy :: SProxy "x") testSubRecord == Just 42
  assert $ get (SProxy :: SProxy "y") testSubRecord == Nothing
