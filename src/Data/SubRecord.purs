module Data.SubRecord (module Data.SubRecord, module Exported) where

import Types (class SubRow, SubRecord) as Exported

import Types (class SubRow, SubRecord)

import Data.Record.Builder as Record

import Unsafe.Coerce (unsafeCoerce)

mkSubRecord :: forall a r.
               SubRow a r =>
               Record a -> SubRecord r
mkSubRecord = unsafeCoerce

foreign import passNullContext :: forall a b. a -> b

unSubRecord :: forall r.
               (forall a.
                Union a r r =>
                Record a -> Record r
               ) ->
               SubRecord r -> Record r
unSubRecord = passNullContext

-- signature commented, because it doesn't seem to compile if explicitly annotated
--withDefaults :: forall a. Record a -> SubRecord a -> Record a
withDefaults defaults = unSubRecord (\r -> Record.build (Record.merge defaults) r)
