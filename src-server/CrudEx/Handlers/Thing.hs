{-# LANGUAGE OverloadedStrings #-}

module CrudEx.Handlers.Thing
    (  thingHandlers
     , initThingStore
     , ThingStore
    ) where

import Control.Concurrent.STM
import Control.Monad.Trans.Except
import Servant
import CrudEx.Api
import STMContainers.Map as StmMap
import ListT
import Control.Monad.IO.Class (liftIO, MonadIO)
import CrudEx.Api.Common (EntityId(..))

-- import Control.Monad (mapM_)

thingHandlers :: ThingStore -> Server ThingApi
thingHandlers store = getThingsH store
    :<|> postThingH store
    :<|> getThingH store
    :<|> putThingH store
    :<|> deleteThingH store

type ThingStore = StmMap.Map Int Thing

initThingStore :: IO ThingStore
initThingStore = -- StmMap.newIO
       atomically $ do 
         store <- StmMap.new
         StmMap.insert (Thing "testName1" "testDesc1" Nothing) 0 store 
         StmMap.insert (Thing "testName2" "testDesc2" Nothing) 1 store 
         return store


pairToThingEntityIso :: (Int, Thing) -> ThingEntity
pairToThingEntityIso (thingId, thing) = Entity (fromInternal thingId) thing

--
-- replaced ExceptT ServantErr IO X with MonadIO m => m X
--

getThingsH :: MonadIO m => ThingStore -> m [ThingEntity]
getThingsH store = liftIO . atomically . fmap (fmap pairToThingEntityIso) . ListT.toList . StmMap.stream $ store

postThingH :: MonadIO m => ThingStore -> Thing -> m ThingEntity
postThingH store thing = liftIO . atomically $ do
                  count <- StmMap.size store
                  StmMap.insert thing count $ store
                  return $ Entity (fromInternal count) thing

getThingH :: ThingStore -> ThingId -> ExceptT ServantErr IO (Maybe Thing)
getThingH store thingId = liftIO . atomically . StmMap.lookup (toInternal thingId) $ store

putThingH :: MonadIO m => ThingStore -> ThingId -> Thing -> m Thing
putThingH store thingId thing = do
           liftIO . atomically . StmMap.insert thing (toInternal thingId) $ store
           return thing

deleteThingH :: MonadIO m => ThingStore -> ThingId -> m ()
deleteThingH store thingId = do 
           liftIO . atomically . StmMap.delete (toInternal thingId) $ store
           return ()
