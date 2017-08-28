-- temp copy of https://hackage.haskell.org/package/wai-app-static-3.1.6.1/docs/Network-Wai-Application-Static.html

module Util.WaiStatic where

import qualified Network.Wai as W
-- import qualified Network.HTTP.Types as H
-- import Blaze.ByteString.Builder (toByteString)
-- import Data.FileEmbed (embedFile)
import Data.Text (Text)
-- import qualified Data.Text as T
-- import qualified Data.Text.Encoding as TE
-- 
-- import Network.HTTP.Date (parseHTTPDate, epochTimeToHTTPDate, formatHTTPDate)
-- 
import Util.WaiStatic.Types
-- import Util
-- import WaiAppStatic.Storage.Filesystem
-- import WaiAppStatic.Storage.Embedded
-- import Network.Mime (MimeType)

-- | Settings optimized for a web application. Files will have aggressive
-- caching applied and hashes calculated, and indices and listings are disabled.
defaultFileServerSettings :: FilePath -- ^ root folder to serve from
                      -> StaticSettings
defaultFileServerSettings root = undefined
  -- StaticSettings
  --   { ssLookupFile = webAppLookup hashFileIfExists root
  --   , ssMkRedirect  = defaultMkRedirect
  --   , ssGetMimeType = return . defaultMimeLookup . fromPiece . fileName
  --   , ssMaxAge  = MaxAgeForever
  --   , ssListing = Nothing
  --   , ssIndices = []
  --   , ssRedirectToIndex = False
  --   , ssUseHash = True
  --   , ssAddTrailingSlash = False
  --   , ss404Handler = Nothing
  --   }

-- | Turn a @StaticSettings@ into a WAI application.
staticApp :: StaticSettings -> W.Application
staticApp set req = staticAppPieces set (W.pathInfo req) req

staticAppPieces :: StaticSettings -> [Text] -> W.Application
staticAppPieces = undefined
-- staticAppPieces _ _ req sendResponse
--     | notElem (W.requestMethod req) ["GET", "HEAD"] = sendResponse $ W.responseLBS
--         H.status405
--         [("Content-Type", "text/plain")]
--         "Only GET or HEAD is supported"
-- staticAppPieces _ [".hidden", "folder.png"] _ sendResponse = sendResponse $ W.responseLBS H.status200 [("Content-Type", "image/png")] $ L.fromChunks [$(embedFile "images/folder.png")]
-- staticAppPieces _ [".hidden", "haskell.png"] _ sendResponse = sendResponse $ W.responseLBS H.status200 [("Content-Type", "image/png")] $ L.fromChunks [$(embedFile "images/haskell.png")]
-- staticAppPieces ss rawPieces req sendResponse = liftIO $ do
--     case toPieces rawPieces of
--         Just pieces -> checkPieces ss pieces req >>= response
--         Nothing -> sendResponse $ W.responseLBS H.status403
--             [ ("Content-Type", "text/plain")
--             ] "Forbidden"
--   where
--     response :: StaticResponse -> IO W.ResponseReceived
--     response (FileResponse file ch) = do
--         mimetype <- ssGetMimeType ss file
--         let filesize = fileGetSize file
--         let headers = ("Content-Type", mimetype)
--                     -- Let Warp provide the content-length, since it takes
--                     -- range requests into account
--                     -- : ("Content-Length", S8.pack $ show filesize)
--                     : ch
--         sendResponse $ fileToResponse file H.status200 headers
-- 
--     response NotModified =
--             sendResponse $ W.responseLBS H.status304 [] ""
-- 
--     response (SendContent mt lbs) = do
--             -- TODO: set caching headers
--             sendResponse $ W.responseLBS H.status200
--                 [ ("Content-Type", mt)
--                   -- TODO: set Content-Length
--                 ] lbs
-- 
--     response (Redirect pieces' mHash) = do
--             let loc = (ssMkRedirect ss) pieces' $ toByteString (H.encodePathSegments $ map fromPiece pieces')
--             let qString = case mHash of
--                   Just hash -> replace "etag" (Just hash) (W.queryString req)
--                   Nothing   -> remove "etag" (W.queryString req)
-- 
--             sendResponse $ W.responseLBS H.status301
--                 [ ("Content-Type", "text/plain")
--                 , ("Location", S8.append loc $ H.renderQuery True qString)
--                 ] "Redirect"
-- 
--     response (RawRedirect path) =
--             sendResponse $ W.responseLBS H.status301
--                 [ ("Content-Type", "text/plain")
--                 , ("Location", path)
--                 ] "Redirect"
-- 
--     response NotFound = case (ss404Handler ss) of
--         Just app -> app req sendResponse
--         Nothing  -> sendResponse $ W.responseLBS H.status404
--                         [ ("Content-Type", "text/plain")
--                         ] "File not found"
-- 
--     response (WaiResponse r) = sendResponse r
