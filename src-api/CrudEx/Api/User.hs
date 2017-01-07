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
import CrudEx.Api.Common (Entity(..))

type UserApi = "users" :> Get '[JSON] [UserEntity]

type UserId = Int 

data User = User
  { userFirstName :: Text
  , userLastName  :: Text
  } deriving (Eq, Show)

type UserEntity = Entity UserId User

$(deriveJSON defaultOptions ''User)
