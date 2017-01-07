{-# LANGUAGE TypeOperators   #-}

module CrudEx.Handlers
    ( handlers
    , AppStore
    , initStore
    ) where

import Servant
import CrudEx.Api (API)
import CrudEx.Handlers.User as UserH
import CrudEx.Handlers.Thing as ThingH

type AppStore = ThingH.ThingStore

initStore :: IO AppStore
initStore = ThingH.initThingStore

handlers :: AppStore -> Server API
handlers thingStore = UserH.userHandlers :<|> ThingH.thingHandlers thingStore
