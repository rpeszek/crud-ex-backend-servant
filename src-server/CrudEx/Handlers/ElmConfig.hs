{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Handlers.ElmConfig
    ( elmConfigHandlers
    ) where

--import Control.Monad.Trans.Except
import Control.Monad.IO.Class (MonadIO)
import Servant
import CrudEx.Api
import CrudEx.Config


elmConfigHandlers :: Server ElmConfigApi
elmConfigHandlers = getElmConfigH


getElmConfigH :: MonadIO m => m ElmConfig
getElmConfigH = return elmConfig
    
