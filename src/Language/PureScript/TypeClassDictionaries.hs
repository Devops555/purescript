-----------------------------------------------------------------------------
--
-- Module      :  Language.PureScript.TypeClassDictionaries
-- Copyright   :  (c) 2014 Phil Freeman
-- License     :  MIT
--
-- Maintainer  :  Phil Freeman <paf31@cantab.net>
-- Stability   :  experimental
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

{-# LANGUAGE DeriveDataTypeable #-}

module Language.PureScript.TypeClassDictionaries where

import Data.Data

import Language.PureScript.Names
import Language.PureScript.Types

-- |
-- Data representing a type class dictionary which is in scope
--
data TypeClassDictionaryInScope
  = TypeClassDictionaryInScope {
    -- | The identifier with which the dictionary can be accessed at runtime
      tcdName :: Qualified Ident
    -- | How to obtain this instance via superclass relationships
    , tcdPath :: [(Qualified ProperName, Integer)]
    -- | The name of the type class to which this type class instance applies
    , tcdClassName :: Qualified ProperName
    -- | The types to which this type class instance applies
    , tcdInstanceTypes :: [Type]
    -- | Type class dependencies which must be satisfied to construct this dictionary
    , tcdDependencies :: Maybe [Constraint]
    -- | The type of this dictionary
    , tcdType :: TypeClassDictionaryType
    } deriving (Show, Read, Data, Typeable)

-- |
-- The type of a type class dictionary
--
data TypeClassDictionaryType
  -- |
  -- A regular type class dictionary
  --
  = TCDRegular
  -- |
  -- A type class dictionary which is an alias for an imported dictionary from another module
  --
  | TCDAlias (Qualified Ident) deriving (Show, Read, Eq, Data, Typeable)

-- |
-- A simplified representation of expressions which are used to represent type
-- class dictionaries at runtime, which can be compared for equality
--
data DictionaryValue
  -- |
  -- A dictionary which is brought into scope by a local constraint
  --
  = LocalDictionaryValue (Qualified Ident)
  -- |
  -- A dictionary which is brought into scope by an instance declaration
  --
  | GlobalDictionaryValue (Qualified Ident)
  -- |
  -- A dictionary which depends on other dictionaries
  --
  | DependentDictionaryValue (Qualified Ident) [DictionaryValue]
  -- |
  -- A subclass dictionary
  --
  | SubclassDictionaryValue DictionaryValue (Qualified ProperName) Integer
  deriving (Show, Read, Ord, Eq)

-- |
-- Find the original dictionary which a type class dictionary in scope refers to
--
canonicalizeDictionary :: TypeClassDictionaryInScope -> Qualified Ident
canonicalizeDictionary (TypeClassDictionaryInScope { tcdType = TCDRegular, tcdName = nm }) = nm
canonicalizeDictionary (TypeClassDictionaryInScope { tcdType = TCDAlias nm }) = nm
