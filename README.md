[![Latest release](http://img.shields.io/bower/v/purescript-subrecord.svg)](https://github.com/rubenpieters/purescript-subrecord/releases)
[![Build Status](https://travis-ci.org/rubenpieters/purescript-subrecord.svg?branch=master)](https://travis-ci.org/rubenpieters/purescript-subrecord)

# purescript-subrecord

The `SubRecord` type, for encoding subrecords.

# Installation

```
bower install purescript-subrecord
```

# Overview

A `Record x` *must* contain values at all labels in the row `x`.
For example, a value of type `Record ( x :: Int, y :: String )` must contain an `Int` value at label `x` and a `String` value at label `y`.

This library introduces the type `SubRecord x`. A `SubRecord x` *may* contain values for the labels in row `x`.
For example, a value of type `SubRecord ( x :: Int, y :: String )` could be any of: `{}`, `{ x :: Int }`, `{ y :: String}` or `{ x :: String, y :: String }`.

We can use `mkSubRecord` on a `Record a`, from which it creates a `SubRecord r` if `a` is a subrow of `r`.

```purescript
testMkSubRecord :: SubRecord ( x :: Int, y :: String )
testMkSubRecord = mkSubRecord { x: 42 }
```

If we try to add a wrong label, the compiler will warn us.

```purescript
wrongLabel :: SubRecord ( x :: Int, y :: String )
wrongLabel = mkSubRecord { z: 42 }
             ^^^^^^^^^^^^^^^^^^^^^
   could not match ( z :: Int | r ) with ( x :: Int, y :: String )
```

We can go back to a `Record` by providing default values for all labels in the row.

```purescript
testWithDef :: { x :: Int, y :: String }
testWithDef = withDefaults { x: 0, y: "default" } testMkSubRecord
```

Then `testWithDef.x` evaluates to `42`, set by `testMkSubRecord`, and `testWithDef.y` evaluates to `"default"`, the given default for label `y`.
