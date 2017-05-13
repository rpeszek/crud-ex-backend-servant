{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

module CrudEx.Api.User
    ( User (..),
      UserApi
    ) where

import Data.Aeson
import Data.Aeson.TH
import Servant
import Data.Text (Text)
import Data.Text as T
import CrudEx.Api.Common (Entity(..), EntityPack(..), EntityT)

type UserApi = "users" :> Get '[JSON] [EntityT User]

data User = User
  { userFirstName :: Text
  , userLastName  :: Text
  } deriving (Eq, Show)

instance EntityPack User where
  data KeyT User = MkUserId Int deriving (Eq, Show)
  toInternalKey (MkUserId i) = i 
  fromInternalKey = MkUserId 

$(deriveJSON defaultOptions ''User)
