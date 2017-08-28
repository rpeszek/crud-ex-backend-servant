{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Server
    ( runApp
    ) where

import Control.Monad.Trans.Except
import Network.Wai
import Network.Wai.Servlet.Handler.Jetty
--import Network.Wai.Handler.Warp (run)
--import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Network.Wai.Middleware.Cors (CorsResourcePolicy(..), cors, simpleHeaders)
import Servant
import CrudEx.Handlers (handlers, initStore, AppStore)
import CrudEx.Api (API)


app :: AppStore -> Application
app appStore = serve api $ handlers appStore

api :: Proxy API
api = Proxy

runApp :: Int -> Bool -> IO ()
runApp port cors = 
  let corsMiddlewhere = if cors then developerCors else id
  in do
     appStore <- initStore
     run port $ corsMiddlewhere {- $ logStdoutDev -} $ app appStore

developerCors :: Middleware
developerCors = cors $ const (Just developerResourcePolicy)

developerResourcePolicy :: CorsResourcePolicy
developerResourcePolicy =
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
