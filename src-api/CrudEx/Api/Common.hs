{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Api.Common
    ( Entity (..)
    , EntityId (..)
    ) where

import Data.Aeson
import Data.Aeson.TH
import Data.Text (Text)
import Data.Text as T

data Entity aid a = Entity
   { id :: aid
   , entity  :: a
   } deriving Show

instance forall aid a . (EntityId aid, ToJSON a) => ToJSON (Entity aid a) where
     toJSON (Entity eid entity) =
        object ["id" .= toInternal eid, "entity" .= entity]

class EntityId a where
  toInternal :: a -> Int 
  fromInternal :: Int -> a
