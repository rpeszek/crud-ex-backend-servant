{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Config (
     elmConfig
) where

import CrudEx.Api.ElmConfig (ElmConfig(..))
import CrudEx.Api.ElmConfig.Logger 
  
elmConfig :: ElmConfig
elmConfig = ElmConfig {
      elmProgName = "App.Main"
    , logConfig = LoggerConfig { 
           logLevel = Std
         , logFlags = [LApp, LOut, LMsg]
      }
   , layout = ""
 }
