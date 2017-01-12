{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
-- {-# LANGUAGE DeriveGeneric #-}

module CrudEx.Api.ElmConfig (
   ElmConfig (..)
 , ElmConfigApi
) where

import Data.Aeson
import Data.Aeson.TH
import qualified Data.Aeson.Encode as AE
--import GHC.Generics (Generic)
import Servant
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import Data.Text.Lazy (toStrict)
import Data.Text.Lazy.Builder (toLazyText)
import qualified CrudEx.Api.ElmConfig.Logger as L
import Servant.HTML.Lucid (HTML)
import Lucid

type ElmConfigApi = "elm" :> Get '[HTML] ElmConfig

data ElmConfig = ElmConfig {
      elmProgName :: Text
    , logConfig :: L.LoggerConfig
    , layout :: Text
  } deriving (Show)

instance ToJSON ElmConfig where
  toJSON (ElmConfig _ lc layout) = object
    [ "logConfig" .= lc
    , "layout"   .= layout
    ]

toJs :: ElmConfig -> Text
toJs = toStrict . toLazyText . AE.encodeToTextBuilder . toJSON

toElmScript :: ElmConfig -> Text
toElmScript elmConfig = 
    "var conf = " `T.append` (toJs elmConfig) `T.append`
    "; \nvar node = document.getElementById('elm-div');\n\
     \var app = Elm." `T.append` (elmProgName elmConfig) `T.append` ".embed(node, conf);"

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
