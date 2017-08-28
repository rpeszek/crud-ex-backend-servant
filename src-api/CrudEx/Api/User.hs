{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DeriveGeneric     #-}

module CrudEx.Api.User
    ( User (..),
      UserApi
    ) where

import Data.Aeson
--import Data.Aeson.TH
import Servant
import Data.Text (Text)
import Data.Text as T
import CrudEx.Api.Common (Entity(..), EntityPack(..), EntityT)
import GHC.Generics

type UserApi = "users" :> Get '[JSON] [EntityT User]

data User = User
  { userFirstName :: Text
  , userLastName  :: Text
  } deriving (Eq, Show, Generic)

instance EntityPack User where
  data KeyT User = MkUserId Int deriving (Eq, Show)
  toInternalKey (MkUserId i) = i 
  fromInternalKey = MkUserId 

instance FromJSON User
instance ToJSON User
-- $(deriveJSON defaultOptions ''User)
