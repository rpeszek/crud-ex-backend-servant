{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Api.Common
    ( Entity (..)
    ) where

import Data.Aeson
import Data.Aeson.TH
import Data.Text (Text)
import Data.Text as T

data Entity aid a = Entity
   { id :: aid
   , entity  :: a
   } deriving Show

instance forall aid a . (ToJSON aid, ToJSON a) => ToJSON (Entity aid a) where
     toJSON (Entity eid entity) =
        object ["id" .= eid, "entity" .= entity]
