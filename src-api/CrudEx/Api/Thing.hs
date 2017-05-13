{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}

module CrudEx.Api.Thing
    ( Thing (..),
      ThingEntity,
      ThingId,
      ThingApi
    ) where

import Data.Aeson
import Data.Aeson.TH
import GHC.Generics (Generic)  -- only needed (convenient) for Elm compilation
import Servant
import Data.Text (Text)
import Data.Text as T
import CrudEx.Api.Common (Entity(..), EntityId(..))

type ThingApi = "things" :> Get '[JSON] [ThingEntity] 
           :<|> "things" :> ReqBody '[JSON] Thing
                         :> Post '[JSON] ThingEntity
           :<|> "things"  :> Capture "thingId" ThingId 
                         :> Get '[JSON] (Maybe Thing)
           :<|> "things"  :> Capture "thingId" ThingId 
                         :> ReqBody '[JSON] Thing 
                         :> Put '[JSON] Thing 
           :<|> "things"  :> Capture "thingId" ThingId
                         :> Delete '[JSON] ()  

newtype ThingId = ThingId Int
   deriving (Show, Eq)

instance EntityId ThingId where
  toInternal (ThingId id) = id
  fromInternal = ThingId

instance FromHttpApiData ThingId      
    where parseUrlPiece x = fmap fromInternal $ parseUrlPiece x 


data Thing = Thing
  { name :: Text
  , description :: Text
  , userId :: Maybe Int
  } deriving (Show, Eq, Generic)

type ThingEntity = Entity ThingId Thing

$(deriveJSON defaultOptions ''Thing)
