-- temp copy of https://hackage.haskell.org/package/wai-app-static-3.1.6.1/docs/Network-Wai-Application-Static.html
{-# LANGUAGE OverloadedStrings #-}

module Util.WaiStatic where

import qualified Network.Wai as W
import qualified Network.HTTP.Types as H
import qualified Network.Mime as M
import Data.Text (Text)
import qualified Data.Text as T
import Data.ByteString.Lazy.Char8 (pack)
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy as LBS --readFile :: FilePath -> IO ByteString
import System.FilePath (joinPath)
import qualified Safe as SF
import qualified System.Directory as DIR


data StaticSettings = StaticSettings FilePath

defaultFileServerSettings :: FilePath -- ^ root folder to serve from
                      -> StaticSettings
defaultFileServerSettings = StaticSettings

staticApp :: StaticSettings -> W.Application
staticApp set req = staticAppPieces set (W.pathInfo req) req

staticAppPieces :: StaticSettings -> [Text] -> W.Application
staticAppPieces (StaticSettings root) pieces req respond = 
     let filePath = joinPath $ map T.unpack (T.pack root : pieces)
         contentType = M.mimeByExt M.defaultMimeMap "application/text" (SF.lastDef "" pieces)
     in do 
        fileExists <- regularFileExistsAndIsReadable filePath
        res <- if fileExists 
               then do
                   contentBody <- LBS.readFile filePath
                   let contentLength = LBS.length contentBody
                   respond $ W.responseLBS H.status200
                            [("Content-Type", contentType), 
                             ("Content-Length", BS.pack $ show $ contentLength)] 
                            contentBody
               else 
                   respond $ W.responseLBS H.status404 
                            [("Content-Type", "text/plain")] 
                            "File not found"
        return res 

regularFileExistsAndIsReadable:: FilePath -> IO Bool
regularFileExistsAndIsReadable filePath = do
     exists <- DIR.doesFileExist filePath
     if exists
     then fmap DIR.readable $ DIR.getPermissions filePath
     else return False
