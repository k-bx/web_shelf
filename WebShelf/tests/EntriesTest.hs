module EntriesTest
       ( entriesSpecs
       ) where

import           Control.Monad.IO.Class     (liftIO)
import           Data.Aeson                 (decode)
import           Data.ByteString.Lazy.Char8 (pack, putStr)
import           Data.Maybe                 (fromJust)
import           Network.Wai.Test           (simpleBody)
import           Prelude                    hiding (putStr)
import           TestImport

entriesSpecs :: Spec
entriesSpecs = do
    ydescribe "Model.FromJSON" $ do
      yit "parses simple doc" $ do
        liftIO $ putStrLn "Starting fromJSON test"
        let decodedEntry = decode $ pack "{\"url\": \"http://haskell.org\"}" :: Maybe Entry
        liftIO $ putStrLn $ "decodedEntry: "
        liftIO $ print $ decodedEntry
        assertEqual "Entry decode failed" decodedEntry (Just (Entry "http://haskell.org"))
        let decoded = (decode $ pack "[{\"value\":{\"url\":\"http://haskell.org\"},\"key\":1}]") :: Maybe [Entity Entry]
        assertEqual "decode failed" decoded (Just [Entity (Key (PersistInt64 1)) (Entry "http://haskell.org")])

    ydescribe "/entries/ API tests" $ do
      yit "gets empty list of entries" $ do
        get EntriesR
        statusIs 200
        maybeResponse <- getResponse
        let response = fromJust maybeResponse
        let body = simpleBody response
        liftIO $ putStrLn $ "Response was:"
        liftIO $ putStr body
        liftIO $ putStrLn ""
        let decoded = decode body :: Maybe [Entity Entry]
        assertEqual "list is not empty" (fromJust decoded) []
        return ()

      yit "gets single entry" $ do
        entryId <- runDB $ insert $ Entry "http://haskell.org"
        liftIO $ putStrLn $ "EntryId is: "
        liftIO $ print entryId
        get EntriesR
        statusIs 200
        maybeResponse <- getResponse
        liftIO $ putStrLn $ "getting response"
        let response = fromJust maybeResponse
        let body = simpleBody response
        liftIO $ putStrLn $ "Response was:"
        liftIO $ putStr body
        liftIO $ putStrLn ""
        let decoded = decode body :: Maybe [Entity Entry]
        liftIO $ putStrLn $ "printing result:"
        assertEqual "list doesn't have one item" (fromJust decoded) [Entity entryId (Entry "http://haskell.org")]
