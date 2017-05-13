{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module Main where

import           Elm          (Spec (Spec), specsToDir, toElmDecoderSource,
                               toElmEncoderSource, toElmTypeSource, ElmType (..))

import qualified Elm as E
import           Servant.Elm  (ElmOptions (..), Proxy (Proxy), UrlPrefix (..),
                               defElmImports, defElmOptions,
                               generateElmForAPIWith)
import           CrudEx.Api 
import           GHC.Generics 
import qualified Data.Text as T
--TODO serverURL, get elm names for aid a in Entity aid a

--
-- Generic way to get TypeName, externalize this to a Util
-- https://gist.github.com/nh2/1a03b7873dbed348ef64fe536028776d
--
class TypeName a where
  typename :: Proxy a -> String

  default typename :: (Generic a, GTypeName (Rep a)) => Proxy a -> String
  typename _proxy = gtypename (from (undefined :: a))

class GTypeName f where
  gtypename :: f a -> String

instance (Datatype c) => GTypeName (M1 i c f) where
  gtypename m = datatypeName m

instance TypeName Thing
--
-- End generic type names
--

-- ElmType instances
instance ElmType Thing

--
-- Custom handling of 'Entity Int a' type
-- Elm Entity ThingId Thing is typed as ThingEntity
--
instance forall a aid. (TypeName a, EntityId aid) =>  ElmType (Entity aid a) where
  toElmType ent = 
       let aName = T.pack . typename $ (Proxy :: Proxy a) 
           eName = aName `T.append` "Entity"
       in E.ElmDatatype eName (E.RecordConstructor eName
         (E.Values (E.ElmField "id" (E.ElmPrimitiveRef E.EInt)) 
                   (E.ElmField "entity" (E.ElmRef aName))))

-- unclear why I need that, making ThingId Generic does not resolve the issue --
instance ElmType (ThingId) where
  toElmType _ = E.ElmPrimitive E.EInt

myElmOpts :: ElmOptions
myElmOpts = defElmOptions { urlPrefix = Dynamic }

spec :: Spec
spec = Spec ["FromServant", "ThingApi"]
            (defElmImports
             : toElmTypeSource    (Proxy :: Proxy Thing)
             : toElmTypeSource    (Proxy :: Proxy (Entity ThingId Thing))
             : toElmDecoderSource (Proxy :: Proxy Thing)
             : toElmEncoderSource (Proxy :: Proxy Thing)
             : toElmDecoderSource (Proxy :: Proxy (Entity ThingId Thing))
             : generateElmForAPIWith myElmOpts (Proxy :: Proxy ThingApi))


main :: IO ()
main = specsToDir [spec] "output"
