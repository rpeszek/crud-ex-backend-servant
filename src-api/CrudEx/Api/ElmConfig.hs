{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE QuasiQuotes #-}
 
module CrudEx.Api.ElmConfig (
   ElmConfig (..)
 , ElmConfigApi
) where

import Servant
import Servant.HTML.Lucid (HTML)
import Lucid
import Data.Aeson
--import Data.Aeson.TH
import qualified Data.Aeson.Encode as AE
import Data.Text (Text)
import Data.Text.Lazy (toStrict)
import Data.Text.Lazy.Builder (toLazyText)
import qualified CrudEx.Api.ElmConfig.Logger as L
import Data.Monoid ((<>))
 

type ElmConfigApi = "elm" :> Get '[HTML] ElmConfig

data ElmConfig = ElmConfig {
      elmProgName :: Text
    , logConfig :: L.LoggerConfig
    , layout :: Text
  } deriving (Show)

--JSON representation is custom, does not include elmProgName
instance ToJSON ElmConfig where
  toJSON (ElmConfig _ lc layout) = object
    [ "logConfig" .= lc
    , "layout"   .= layout
    ]

toJs :: ElmConfig -> Text
toJs = toStrict . toLazyText . AE.encodeToTextBuilder . toJSON

toElmScript :: ElmConfig -> Text
toElmScript elmConfig = 
     let elmProgNm = elmProgName elmConfig
         configJs = toJs elmConfig
     in 
        "var conf = " <> configJs <> ";" <>
        "var node = document.getElementById('elm-div');" <>
        "var app = Elm." <> elmProgNm <> ".embed(node, conf);"

instance ToHtml ElmConfig where
  toHtml elmConfig = html_ $ do
    head_ $ do
      title_ "Elm Crud Example"
      link_ [rel_ "stylesheet",type_ "text/css",href_ "static/css/pure.css"]
      link_ [rel_ "stylesheet",type_ "text/css",href_ "static/css/styles.css"]
    body_ $ do
      div_ [id_ "elm-div"] ""
      script_ [src_ "static/js/elm-app.js"] ""
      script_ (toElmScript elmConfig)

  toHtmlRaw = toHtml
