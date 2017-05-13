{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}

module CrudEx.Api.Common
    ( Entity (..)
     , EntityPack (..)
     , EntityT
    ) where

import Data.Aeson
import Data.Aeson.TH
import Data.Text (Text)
import Data.Text as T
import Data.Hashable as H
import Servant as S

data Entity aid a = Entity
   { id :: aid
   , entity  :: a
   } deriving Show

--TODO remove
instance forall a . (ToJSON a) => ToJSON (Entity Int a) where
     toJSON (Entity eid entity) =
        object ["id" .= eid, "entity" .= entity]

class EntityPack a where
  data KeyT a 
  -- type EntityT a = Entity (KeyT a) a
  toInternalKey :: KeyT a -> Int 
  fromInternalKey :: Int -> KeyT a
  toEntity :: KeyT a -> a -> Entity (KeyT a) a
  toEntity key x = Entity key x

instance (EntityPack a, ToJSON a) => ToJSON (Entity (KeyT a) a) where
    toJSON (Entity eid entity) =
       object ["id" .= toInternalKey eid, "entity" .= entity]

instance (EntityPack a) => H.Hashable (KeyT a) where 
   hashWithSalt salt key = hashWithSalt salt (toInternalKey key)

instance (EntityPack a) => S.FromHttpApiData (KeyT a)      
    where parseUrlPiece x = fmap fromInternalKey $ parseUrlPiece x 

type family EntityT a
type instance EntityT a = Entity (KeyT a) a
