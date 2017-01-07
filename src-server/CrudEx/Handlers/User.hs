{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Handlers.User
    ( userHandlers
    ) where

import Control.Monad.Trans.Except
import Servant
import CrudEx.Api


userHandlers :: Server UserApi
userHandlers = getUsersH

tempUsers :: [UserEntity]
tempUsers = [ Entity 1 $ User "Alonzo" "Church"
            , Entity 2 $ User "Alan" "Turing"
            ]

getUsersH :: ExceptT ServantErr IO [UserEntity]
getUsersH = return tempUsers
    
