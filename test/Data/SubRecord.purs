module Test.Data.SubRecord where

import Prelude
import Types

import Data.SubRecord

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

main :: Eff _ Unit
main = do
  assert $ testWithDef.x == 99
