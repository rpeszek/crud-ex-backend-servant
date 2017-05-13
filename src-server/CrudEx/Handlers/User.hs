{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Handlers.User
    ( userHandlers
    ) where

import Control.Monad.IO.Class (liftIO, MonadIO)
--import Control.Monad.Trans.Except
import Servant
import CrudEx.Api


userHandlers :: Server UserApi
userHandlers = getUsersH

tempUsers :: [EntityT User]
tempUsers = [ toEntity (fromInternalKey 1) $ User "Alonzo" "Church"
            , toEntity (fromInternalKey 2) $ User "Alan" "Turing"
            ]

getUsersH :: MonadIO m => m [EntityT User]
getUsersH = return tempUsers
    
