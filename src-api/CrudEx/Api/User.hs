{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Api.User
    ( User (..),
      UserEntity,
      UserId,
      UserApi
    ) where

import Data.Aeson
import Data.Aeson.TH
import Servant
import Data.Text (Text)
import Data.Text as T
import CrudEx.Api.Common (Entity(..), EntityId(..))

type UserApi = "users" :> Get '[JSON] [UserEntity]

newtype UserId = UserId Int 
   deriving (Show, Eq)

instance EntityId UserId where
  toInternal (UserId id) = id
  fromInternal = UserId

data User = User
  { userFirstName :: Text
  , userLastName  :: Text
  } deriving (Eq, Show)

type UserEntity = Entity UserId User

$(deriveJSON defaultOptions ''User)
