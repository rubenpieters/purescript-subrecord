module Types where

import Prelude

-- | `Union a b c` means a ∪ b = c
-- | `SubRow a b` means a is a subrow of b
-- | or: there exists an x for which `Union a x b` holds
class SubRow (a :: # Type) (b :: # Type)
instance subRow :: Union a x b => SubRow a b


-- | A `SubRecord x` is a record which may contain values for labels in x
-- | as opposed to a `Record x` which must contain values for labels in x
foreign import data SubRecord :: # Type -> Type
