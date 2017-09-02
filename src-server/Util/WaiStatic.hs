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
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy as LBS --readFile :: FilePath -> IO ByteString
import System.FilePath (joinPath)
import qualified Safe as SF



-- | Temporary hack since directory package currently does not build for me
foreign import java unsafe "@static patch.Utils.isReadableAndExists"
   jIsReadableAndExists :: String -> IO Bool
-- | Temporary hack LBS.length errors out
foreign import java unsafe "@static patch.Utils.fileSize"
   jFileSize :: String -> IO Int64

data StaticSettings = StaticSettings FilePath

defaultFileServerSettings :: FilePath -- ^ root folder to serve from
                      -> StaticSettings
defaultFileServerSettings = StaticSettings

staticApp :: StaticSettings -> W.Application
staticApp set req = staticAppPieces set (W.pathInfo req) req

-- | this now works but prints exceptions
staticAppPieces :: StaticSettings -> [Text] -> W.Application
staticAppPieces (StaticSettings root) pieces req respond = 
     let filePath = joinPath $ map T.unpack (T.pack root : pieces)
         contentType = M.mimeByExt M.defaultMimeMap "application/text" (SF.lastDef "" pieces)
     in do 
        -- current problems with building directory package, use Java instead:
        fileExists <- jIsReadableAndExists filePath
        res <- if fileExists 
               then do
                   contentBody <- LBS.readFile filePath
                   -- currently this exceptions:
                   -- let contentLength = LBS.length contentBody
                   -- use Java instead: 
                   contentLength <- jFileSize filePath
                   respond $ W.responseLBS H.status200 
                            [("Content-Type", contentType), 
                             ("Content-Length", BS.pack $ show $ contentLength)] 
                            contentBody
               else 
                   respond $ W.responseLBS H.status404 
                            [("Content-Type", "text/plain")] 
                            "File not found"
        return res 
