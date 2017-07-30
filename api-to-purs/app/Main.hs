{-# LANGUAGE AutoDeriveTypeable    #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Main where

import           Control.Monad.Reader.Class
import           Control.Applicative
import           Control.Lens
import           Data.Aeson
import           Data.Monoid
import           Data.Proxy
import qualified Data.Set                           as Set
import           Data.Text                          (Text)
import qualified Data.Text                          as T
import qualified Data.Text.Encoding                 as T
import qualified Data.Text.IO                       as T
import           Language.PureScript.Bridge
import           Language.PureScript.Bridge.PSTypes
import           Servant.API
import           Servant.PureScript
import           Servant.Subscriber.Subscribable

import           CrudEx.Api 


{-
 Work in progress.
 This needs work, currently servant-purescript generated purescript 10.x code.
 I want to play with purescript 11

 In PureScript
  data KeyT a = KeyT {id: Int}
-}

-- CrudEx.Api.Common contains Entity and KeyT and these are currently will be ignored (replaced)
--
-- keyTBridge :: BridgePart
-- keyTBridge = typeName ^== "KeyT" >> psKeyT
-- psKeyT :: MonadReader BridgeData m => m PSType
-- psKeyT = TypeInfo "purescript-keyt" "CrudEx.Api.Base" "KeyT" <$> psTypeParameters
--
-- entityBridge :: BridgePart
-- entityBridge = typeName ^== "Entity" >> psEntity
-- psEntity :: MonadReader BridgeData m => m PSType
-- psEntity = TypeInfo "purescript-entity" "CrudEx.Api.Common" "Entity" <$> psTypeParameters

--myBridge :: BridgePart
--myBridge = defaultBridge <|> keyTBridge <|> entityBridge

psClientType :: MonadReader BridgeData m => m PSType
psClientType = do
  inType <- view haskType
  params <- psTypeParameters
  return TypeInfo {
    _typePackage = ""
  , _typeModule  = "CrudEx.Api.Common"
  , _typeName = inType ^. typeName
  , _typeParameters = params
  }

-- This custom bridge does not really do much now
myBridge :: BridgePart
myBridge = defaultBridge
  <|> (typeName ^== "KeyT" >> psClientType)
  <|> (typeName ^== "Entity" >> psClientType)

data MyBridge

myBridgeProxy :: Proxy MyBridge
myBridgeProxy = Proxy

instance HasBridge MyBridge where
  languageBridge _ = buildBridge myBridge

thingSumType :: SumType 'Haskell
thingSumType = mkSumType (Proxy :: Proxy Thing)
entitySumType :: SumType 'Haskell
entitySumType = mkSumType (Proxy :: Proxy (Entity (KeyT Thing) Thing))

myTypes :: [SumType 'Haskell]
myTypes =  [
            thingSumType
          , entitySumType
          ]

mySettings :: Settings
mySettings = (addReaderParam "AuthToken" defaultSettings & apiModuleName .~ "CrudEx.Api") {
  _generateSubscriberAPI = False
  }

thingAPI :: Proxy ThingApi
thingAPI = Proxy

main :: IO ()
main = do
  let frontEndRoot = "output-purs"
  writeAPIModuleWithSettings mySettings frontEndRoot myBridgeProxy thingAPI
  writePSTypes frontEndRoot (buildBridge myBridge) myTypes
