{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import           Application             (makeFoundation)
import           Control.Monad           (when)
import           Database.Persist.Sql    (runMigration)
import           Database.Persist.Sqlite (runSqlite)
import           Import
import           System.Directory        (doesFileExist, removeFile)
import           Test.Hspec              (hspec, before)
import           Yesod.Default.Config
import           Yesod.Test

-- import           HomeTest
import           EntriesTest
import           ModelTest

main :: IO ()
main = do
    hspec $ (before removeDb) $ do
        yesodSpecWithSiteGenerator getSiteAction $ do
            -- homeSpecs
            entriesSpecs
            modelSpecs

getSiteAction :: IO App
getSiteAction = do
    conf <- Yesod.Default.Config.loadConfig $ (configSettings Testing)
                { csParseExtra = parseExtra
                }
    foundation <- makeFoundation conf
    return foundation

removeDb :: IO ()
removeDb = do
  -- path <- canonicalizePath "WebShelf_test.sqlite3"
  let path = "WebShelf_test.sqlite3"
  isExist <- doesFileExist path
  when isExist (recreateDbWhenExists path)

recreateDbWhenExists :: FilePath -> IO ()
recreateDbWhenExists path = do
  putStrLn $ "Path is: " ++ path
  removeFile "WebShelf_test.sqlite3"
  runSqlite "WebShelf_test.sqlite3" $ do
    (runMigration migrateAll)
  return ()
