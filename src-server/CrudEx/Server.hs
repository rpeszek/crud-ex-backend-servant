{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Server
    ( startApp
    ) where

import Control.Monad.Trans.Except
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Cors -- (simpleCors)
import Servant
import CrudEx.Handlers (handlers, initStore, AppStore)
import CrudEx.Api (API)


app :: AppStore -> Application
app appStore = serve api $ handlers appStore

api :: Proxy API
api = Proxy

startApp :: Int -> IO ()
startApp port = do
       appStore <- initStore
       run port $ elmReactorCors $ app appStore -- run port app thingStore

elmReactorCors :: Middleware
elmReactorCors = cors $ const (Just elmReactorResourcePolicy)

elmReactorResourcePolicy :: CorsResourcePolicy
elmReactorResourcePolicy =
    CorsResourcePolicy
        { corsOrigins = Nothing -- gives you /*
        , corsMethods = ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTION"]
        , corsRequestHeaders = simpleHeaders -- adds "Content-Type" to defaults
        , corsExposedHeaders = Nothing
        , corsMaxAge = Nothing
        , corsVaryOrigin = False
        , corsRequireOrigin = False
        , corsIgnoreFailures = False
        }
