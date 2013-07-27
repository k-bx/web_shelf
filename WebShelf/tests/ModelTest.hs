module ModelTest where

import           Control.Monad.IO.Class     (liftIO)
import           Data.Aeson                 (decode)
import           Data.ByteString.Lazy.Char8 (pack)
import           TestImport

modelSpecs :: Spec
modelSpecs =
    ydescribe "Model.FromJSON" $ do
      yit "parses simple doc" $ do
        liftIO $ putStrLn "Starting fromJSON test"
        let decodedEntry = decode $ pack "{\"url\": \"http://haskell.org\"}" :: Maybe Entry
        liftIO $ putStrLn $ "decodedEntry: "
        liftIO $ print $ decodedEntry
        assertEqual "Entry decode failed" decodedEntry (Just (Entry "http://haskell.org"))
        let decoded = ((decode $ pack s) :: Maybe [Entity Entry])
              where s = "[{\"value\":{\"url\":\"http://haskell.org\"},\"key\":1}]"
        assertEqual "decode failed" decoded (Just [Entity (Key (PersistInt64 1)) (Entry "http://haskell.org")])
