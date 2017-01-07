{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Api.Thing
    ( Thing (..),
      ThingEntity,
      ThingId,
      ThingApi
    ) where

import Data.Aeson
import Data.Aeson.TH
import Servant
import Data.Text (Text)
import Data.Text as T
import CrudEx.Api.Common (Entity(..))

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

type ThingId = Int

data Thing = Thing
  { name :: Text
  , description :: Text
  , userId :: Maybe Int
  } deriving Show

type ThingEntity = Entity ThingId Thing

$(deriveJSON defaultOptions ''Thing)
