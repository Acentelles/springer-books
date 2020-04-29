module Lib
  ( downloadBooks,
  )
where

import Data.Char
import Data.List
import Debug.Trace
import Network.HTTP.Download.File
import Network.URI
import Network.Wreq
import System.Directory
import Text.CSV

springerURL :: String
springerURL = "link.springer.com"

downloadBooks :: String -> IO ()
downloadBooks topic = do
  csvE <- parseCSVFromFile "springer-books.csv"
  case csvE of
    Left err -> print err
    Right [] -> print "Empty file"
    Right (_ : csv) -> do
      createDirectoryIfMissing True topic
      mapM_
        ( \(title, bookUrl) -> do
            print bookUrl
            let Just u' = parseURI bookUrl
                u =
                  u'
                    { uriAuthority = Just $ URIAuth "" springerURL "",
                      uriPath = "/content/pdf" ++ uriPath u' ++ ".pdf"
                    }
            downloadFile (show u) Nothing topic (replaceBar title) (Overwrite True)
        )
        (foldl' f [] csv)
  where
    f acc [""] = acc
    f acc record =
      if (toLower <$> topic) `isInfixOf` (toLower <$> (record !! 11))
        then (head record, record !! 17) : acc
        else acc
    replaceBar s = (\c -> if c == '/' then '|' else c) <$> s
