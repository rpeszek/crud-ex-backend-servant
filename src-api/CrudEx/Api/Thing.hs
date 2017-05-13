{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}

module CrudEx.Api.Thing
    ( Thing (..),
      ThingApi
    ) where

import Data.Aeson
import Data.Aeson.TH
import GHC.Generics (Generic)  -- only needed (convenient) for Elm compilation
import Servant
import Data.Text (Text)
import Data.Text as T
import CrudEx.Api.Common (Entity(..), EntityPack(..), EntityT)

type ThingApi = "things" :> Get '[JSON] [EntityT Thing] 
           :<|> "things" :> ReqBody '[JSON] Thing
                         :> Post '[JSON] (EntityT Thing)
           :<|> "things"  :> Capture "thingId" (KeyT Thing) 
                         :> Get '[JSON] (Maybe Thing)
           :<|> "things"  :> Capture "thingId" (KeyT Thing) 
                         :> ReqBody '[JSON] Thing 
                         :> Put '[JSON] Thing 
           :<|> "things"  :> Capture "thingId" (KeyT Thing)
                         :> Delete '[JSON] ()  


data Thing = Thing
  { name :: Text
  , description :: Text
  , userId :: Maybe Int
  } deriving (Show, Eq, Generic)

instance EntityPack Thing where
  data KeyT Thing = MkThingId Int deriving (Eq, Show)
  toInternalKey (MkThingId i) = i 
  fromInternalKey = MkThingId 
  
$(deriveJSON defaultOptions ''Thing)
