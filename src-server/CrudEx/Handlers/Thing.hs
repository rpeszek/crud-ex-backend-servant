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
import CrudEx.Api.Common (EntityPack(..), EntityT)
-- import Control.Monad (mapM_)

thingHandlers :: ThingStore -> Server ThingApi
thingHandlers store = getThingsH store
    :<|> postThingH store
    :<|> getThingH store
    :<|> putThingH store
    :<|> deleteThingH store

type ThingStore = StmMap.Map (KeyT Thing) Thing

initThingStore :: IO ThingStore
initThingStore = -- StmMap.newIO
       atomically $ do 
         store <- StmMap.new
         StmMap.insert (Thing "testName1" "testDesc1" Nothing) (fromInternalKey 0) store 
         StmMap.insert (Thing "testName2" "testDesc2" Nothing) (fromInternalKey 1) store 
         return store


pairToEntityIso :: (KeyT Thing, Thing) -> EntityT Thing
pairToEntityIso = uncurry toEntity

--
-- replaced ExceptT ServantErr IO X with MonadIO m => m X
--

getThingsH :: MonadIO m => ThingStore -> m [EntityT Thing]
getThingsH store = liftIO . atomically . fmap (fmap pairToEntityIso) . ListT.toList . StmMap.stream $ store

postThingH :: MonadIO m => ThingStore -> Thing -> m (EntityT Thing)
postThingH store thing = liftIO . atomically $ do
                  count <- StmMap.size store
                  StmMap.insert thing (fromInternalKey count) $ store
                  return $ toEntity (fromInternalKey count) thing

getThingH :: MonadIO m => ThingStore -> KeyT Thing -> m (Maybe Thing)
getThingH store thingId = liftIO . atomically . StmMap.lookup thingId $ store

putThingH :: MonadIO m => ThingStore -> KeyT Thing -> Thing -> m Thing
putThingH store thingId thing = do
           liftIO . atomically . StmMap.insert thing thingId $ store
           return thing

deleteThingH :: MonadIO m => ThingStore -> KeyT Thing -> m ()
deleteThingH store thingId = do 
           liftIO . atomically . StmMap.delete thingId $ store
           return ()
