module Data.SubRecord.Builder
  ( Builder
  , build
  , insert
--  , modify
--  , delete
--  , rename
--  , merge
  ) where

import Prelude

import Types (SubRecord)

import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, SProxy, reflectSymbol)
import Type.Row (class RowLacks)

import Unsafe.Coerce (unsafeCoerce)

foreign import copyRecord :: forall r1. SubRecord r1 -> SubRecord r1
foreign import unsafeInsert :: forall a r1 r2. String -> a -> SubRecord r1 -> SubRecord r2
foreign import unsafeModify :: forall a b r1 r2. String -> (a -> b) -> SubRecord r1 -> SubRecord r2
foreign import unsafeDelete :: forall r1 r2. String -> SubRecord r1 -> SubRecord r2
foreign import unsafeRename :: forall r1 r2. String -> String -> SubRecord r1 -> SubRecord r2
foreign import unsafeMerge :: forall r1 r2 r3. SubRecord r1 -> SubRecord r2 -> SubRecord r3

-- | A `Builder` can be used to `build` a record by incrementally adding
-- | fields in-place, instead of using `insert` and repeatedly generating new
-- | immutable records which need to be garbage collected.
-- |
-- | The `Category` instance for `Builder` can be used to compose builders.
-- |
-- | For example:
-- |
-- | ```purescript
-- | build (insert x (Just 42) >>> insert y (Just "testing")) (mkSubRecord {}) :: SubRecord ( x :: Int, y :: String )
-- | ```
newtype Builder a b = Builder (a -> b)

-- | Build a record, starting from some other record.
build :: forall r1 r2. Builder (SubRecord r1) (SubRecord r2) -> SubRecord r1 -> SubRecord r2
build (Builder b) r1 = b (copyRecord r1)

derive newtype instance semigroupoidBuilder :: Semigroupoid Builder
derive newtype instance categoryBuilder :: Category Builder

-- | Build by inserting a new field.
insert
  :: forall l a r1 r2
   . RowCons l a r1 r2
  => RowLacks l r1
  => IsSymbol l
  => SProxy l
  -> Maybe a
  -> Builder (SubRecord r1) (SubRecord r2)
insert l (Just a) = Builder \r1 -> unsafeInsert (reflectSymbol l) a r1
insert l Nothing = Builder \r1 -> unsafeCoerce r1
