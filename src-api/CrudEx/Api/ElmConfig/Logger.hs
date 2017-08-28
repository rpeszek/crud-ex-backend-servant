{-# LANGUAGE DeriveGeneric #-}

module CrudEx.Api.ElmConfig.Logger where

import Data.Aeson
--import Data.Aeson.TH
import GHC.Generics (Generic)
import Servant
-- import Data.Text (Text)
-- import Data.Text as T

data LoggerFlag = 
     LApp 
   | LIn 
   | LOut 
   | LUpdate
   | LView
   | LInit 
   | LNav 
   | LMsg 
   | LModel 
   | LNavLoc  -- like Nav model
   | LHtml 
   | LSub 
   | LFlags 
 deriving (Show, Generic)

instance FromJSON LoggerFlag
instance ToJSON LoggerFlag

data LoggerLevel = 
      Info
    | Std
    | Crit
 deriving (Show, Generic)

instance FromJSON LoggerLevel
instance ToJSON LoggerLevel

data LoggerConfig = LoggerConfig {
    logLevel :: LoggerLevel
  , logFlags :: [LoggerFlag]
} deriving (Show, Generic)

instance FromJSON LoggerConfig
instance ToJSON LoggerConfig
