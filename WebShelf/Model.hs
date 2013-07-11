{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TemplateHaskell            #-}

module Model where

import           Control.Applicative    ((<$>), (<*>))
import           Data.Aeson             (ToJSON, object, (.=))
import           Data.Text              (Text)
import           Data.Typeable          (Typeable)
import           Database.Persist.Quasi
import           Prelude
import           Yesod

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlOnlySettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")

instance ToJSON Entry where
  toJSON (Entry url) = object [ "url" .= url ]

instance FromJSON Entry where
  parseJSON (Object v) = Entry <$> v .: "url"
