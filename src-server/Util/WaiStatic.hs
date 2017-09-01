-- temp copy of https://hackage.haskell.org/package/wai-app-static-3.1.6.1/docs/Network-Wai-Application-Static.html
{-# LANGUAGE OverloadedStrings #-}

module Util.WaiStatic where

import Java
import qualified Network.Wai as W
import qualified Network.HTTP.Types as H
import qualified Network.Mime as M
import Data.Text (Text)
import qualified Data.Text as T
import Data.ByteString.Lazy.Char8 (pack)
import qualified Data.ByteString.Lazy as LBS --readFile :: FilePath -> IO ByteString
import System.FilePath (joinPath)



-- | Temporary hack since directory package currently does not load
foreign import java unsafe "@static patch.Utils.isReadableAndExists"
   isReadableAndExists :: String -> IO Bool

data StaticSettings = StaticSettings FilePath

defaultFileServerSettings :: FilePath -- ^ root folder to serve from
                      -> StaticSettings
defaultFileServerSettings = StaticSettings

staticApp :: StaticSettings -> W.Application
staticApp set req = staticAppPieces set (W.pathInfo req) req

-- | still does not work, needs chunking
staticAppPieces :: StaticSettings -> [Text] -> W.Application
staticAppPieces (StaticSettings root) rawPieces req respond = 
     let filePath = joinPath $ map T.unpack (T.pack root : rawPieces)
         --TODO last is unsafe
         contentType = M.mimeByExt M.defaultMimeMap "application/text" (last rawPieces)
     in do 
        fileExists <- isReadableAndExists filePath
        res <- if fileExists 
               then do
                   contentBody <- LBS.readFile filePath
                   respond $ W.responseLBS H.status200 [("Content-Type", contentType)] contentBody
               else 
                   respond $ W.responseLBS H.status404 [("Content-Type", "text/plain")] "File not found"
        return res 
