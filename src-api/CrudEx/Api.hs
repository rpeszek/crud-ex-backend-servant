{-# LANGUAGE TypeOperators   #-}

module CrudEx.Api
    ( User (..),
      UserEntity,
      UserId,
      UserApi,
      Thing (..),
      Entity (..),
      ThingEntity,
      ThingId,
      ThingApi,
      API
    ) where

import Servant
import CrudEx.Api.User
import CrudEx.Api.Thing
import CrudEx.Api.Common


type API = UserApi :<|> ThingApi
