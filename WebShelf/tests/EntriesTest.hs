module EntriesTest where

import           Control.Monad.IO.Class     (liftIO)
import           Data.Aeson                 (decode)
import           Data.ByteString.Lazy.Char8 (putStr)
import           Data.Maybe                 (fromJust)
import           Network.Wai.Test           (simpleBody)
import           Prelude                    hiding (putStr)
import           TestImport

entriesSpecs :: Spec
entriesSpecs = do
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
            assertEqual "list doesn't have one item"
                        (fromJust decoded)
                        [Entity entryId (Entry "http://haskell.org")]

        yit "gets two entries" $ do
            _ <- runDB $ insert $ Entry "http://haskell.org"
            _ <- runDB $ insert $ Entry "http://haskell.org"
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
            assertEqual "len(list entries) != 2"
                        (length (fromJust decoded))
                        2
