{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}

module CrudEx.Api
    ( User (..),
      UserApi,
      Thing (..),
      Entity (..),
      EntityPack (..),
      EntityT,
      ThingApi,
      ElmConfig(..),
      ElmConfigApi,
      StaticApi,
      API
    ) where

import Servant
import CrudEx.Api.User
import CrudEx.Api.Thing
import CrudEx.Api.ElmConfig
import CrudEx.Api.Common

type StaticApi = "static" :> Raw

type API = UserApi       :<|> 
           ThingApi      :<|>
           ElmConfigApi  :<|>
           StaticApi
