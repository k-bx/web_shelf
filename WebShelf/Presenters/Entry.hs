module Presenters.Entry
       ( EntryPresentation(..),
         makeEntryPresentation
       ) where

import           Data.Data     (Data)
import           Data.Eq       (Eq)
import           Data.Typeable (Typeable)
import           Prelude       (Integer, Maybe, String)
import           Text.Show

data EntryPresentation = EntryPresentation { id  :: Integer
                                           , url :: String }
                       deriving (Data,Typeable,Show,Eq)

makeEntryPresentation :: Integer -> String -> EntryPresentation
makeEntryPresentation id' url' = EntryPresentation { id=id', url=url' }
