-- Temporary patch implementing parts of
-- https://github.com/haskell-servant/servant/blob/master/servant-server/src/Servant/Utils/StaticFiles.hs

module Util.StaticFiles 
 ( --serveDirectoryWebApp
  -- , serveDirectoryWebAppLookup
    serveDirectoryFileServer
  -- , serveDirectoryEmbedded
  , serveDirectoryWith
  , -- * Deprecated
    serveDirectory
  ) where

import           Util.WaiStatic
import           Data.ByteString                (ByteString)
import           Servant.API.Raw                (Raw)
import           Servant.Server                 (Server, Tagged (..))
import           System.FilePath                (addTrailingPathSeparator)

-- | Same as 'serveDirectoryWebApp', but uses `defaultFileServerSettings`.
serveDirectoryFileServer :: FilePath -> Server Raw
serveDirectoryFileServer = serveDirectoryWith . defaultFileServerSettings . fixPath

-- | Alias for 'staticApp'. Lets you serve a directory
--   with arbitrary 'StaticSettings'. Useful when you want
--   particular settings not covered by the four other
--   variants. This is the most flexible method.
serveDirectoryWith :: StaticSettings -> Server Raw
serveDirectoryWith = Tagged . staticApp

-- | Same as 'serveDirectoryFileServer'. It used to be the only
--   file serving function in servant pre-0.10 and will be kept
--   around for a few versions, but is deprecated.
serveDirectory :: FilePath -> Server Raw
serveDirectory = serveDirectoryFileServer
{-# DEPRECATED serveDirectory "Use serveDirectoryFileServer instead" #-}

fixPath :: FilePath -> FilePath
fixPath = addTrailingPathSeparator
-- #if MIN_VERSION_wai_app_static(3,1,0)
--    addTrailingPathSeparator
-- #else
--    decodeString . addTrailingPathSeparator
-- #endif

-- TODOs 
-- OS specific decodeString 
