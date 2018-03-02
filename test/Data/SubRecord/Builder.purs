module Test.Data.SubRecord.Builder where

import Control.Monad.Eff
import Data.Maybe
import Data.SubRecord
import Data.Symbol
import Prelude
import Test.Assert
import Types

import Data.SubRecord.Builder (build, modify)
import Data.SubRecord.Builder as SubRecord

x :: SProxy "x"
x = SProxy
y :: SProxy "y"
y = SProxy
a :: SProxy "a"
a = SProxy
b :: SProxy "b"
b = SProxy

testInsert :: SubRecord ( x :: Int, y :: String )
testInsert =
  SubRecord.build
    ( SubRecord.insert x (Just 42) >>>
      SubRecord.insert y Nothing
    ) (mkSubRecord {})

testModify :: SubRecord ( x :: String, y :: String )
testModify =
  SubRecord.build
    ( SubRecord.insert x (Just 42) >>>
      SubRecord.insert y (Nothing :: Maybe Int) >>>
      SubRecord.modify x show >>>
      SubRecord.modify y show
    ) (mkSubRecord {})

testDelete1 :: SubRecord ( y :: String )
testDelete1 =
  SubRecord.build
    ( SubRecord.delete x
    ) (mkSubRecord {})

testDelete2 :: SubRecord ( y :: String )
testDelete2 =
  SubRecord.build
    ( SubRecord.delete x
    ) (mkSubRecord { x: 42 })

testRename :: SubRecord ( a :: Int, b :: String )
testRename =
  SubRecord.build
    ( SubRecord.rename x a >>>
      SubRecord.rename y b
    ) (mkSubRecord { x: 42 })

mergeDefaults  :: SubRecord ( x :: Int, y :: String, a :: Int, b :: String )
mergeDefaults = mkSubRecord { a: 1,  b: "default" }

testMerge :: SubRecord ( x :: Int, y :: String, a :: Int, b :: String )
testMerge =
  SubRecord.build
    ( SubRecord.merge (mkSubRecord { a: 1 } :: SubRecord ( a :: Int, b :: String))
    ) (mkSubRecord { x: 42 } :: SubRecord ( x :: Int, y :: String ))

main :: Eff _ Unit
main = do
  assert $ get x testInsert == Just 42
  assert $ get y testInsert == Nothing
  assert $ get x testModify == Just "42"
  assert $ get y testModify == Nothing
  assert $ get y testDelete1 == Nothing
  assert $ get y testDelete2 == Nothing
  assert $ get a testRename == Just 42
  assert $ get b testRename == Nothing
  assert $ get x testMerge == Just 42
  assert $ get y testMerge == Nothing
  assert $ get a testMerge == Just 1
  assert $ get b testMerge == Nothing
