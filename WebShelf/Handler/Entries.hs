{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies     #-}

module Handler.Entries where

import           Data.Aeson         (Value, object, toJSON, (.=))
import qualified Data.Aeson.Generic as AesonGeneric
import           Import
-- import           Presenters.Entry   (makeEntryPresentation)

getEntriesR :: Handler Value
getEntriesR = do
  entries <- runDB $ selectList [] ([] :: [SelectOpt Entry])
  return $ toJSON (entries :: [Entity Entry])

-- return $ AesonGeneric.toJSON [makeEntryPresentation 1 "http://google.com"]

postEntriesR :: Handler Html
postEntriesR = error "Not yet implemented: postEntriesR"

putEntriesR :: Handler Html
putEntriesR = error "Not yet implemented: putEntriesR"

deleteEntriesR :: Handler Html
deleteEntriesR = error "Not yet implemented: deleteEntriesR"
