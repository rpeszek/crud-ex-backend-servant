module Main where

-- import qualified Data.List as L
import System.Environment
import Data.Maybe (maybe)

import CrudEx.Server (runApp)

main :: IO ()
main = do
   port <- fmap readPort $ lookupEnv "SERVANT_PORT"
   env  <- fmap (maybe defaultEnv id) $ lookupEnv "SERVANT_APP_ENV"
   putStrLn $ "Running on port (SERVANT_PORT) " ++ show port
   putStrLn $ "Env (SERVANT_APP_ENV) is set to " ++ env
   if env == defaultEnv 
   then putStrLn $ "Running with CORS enabled"
   else putStrLn $ "Running with CORS disabled"
   runApp port (env == defaultEnv)


readMaybe :: Read a => String -> Maybe a
readMaybe s = case reads s of
                  [(val, "")] -> Just val
                  _           -> Nothing

defaultEnv :: String
defaultEnv = "DEV"

defaultPort :: Int 
defaultPort = 3000

readPort :: Maybe String -> Int 
readPort portM = case portM of 
        Nothing -> defaultPort
        Just portS -> maybe defaultPort id (readMaybe portS)
