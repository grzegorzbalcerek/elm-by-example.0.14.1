-- -*- coding: utf-8; -*-

import System.Environment(getArgs)
import qualified Data.Map.Strict as M
import Control.Monad (forM_)
import Data.Char (isSpace)
import Data.List (groupBy)
import Debug.Trace (traceShow, traceShowId)
import System.IO
import GHC.IO.Encoding
import Control.Monad.Trans.State

type Acc = (M.Map String [String], Maybe String)

step :: Acc -> String -> Acc
step (sources, Nothing) line =
  let sourceFileName = case (groupBy (\a b -> isSpace a == isSpace b) line) of
                         "%" : " " : fileName : _ -> Just fileName
                         _ -> Nothing
  in (sources, sourceFileName)
step (sources, Just fileName) line =
  if (null line || isSpace (head line))
  then (M.alter (\maybeLines -> case maybeLines of
                                  Just lines -> Just (extractLine line:lines)
                                  Nothing -> Just [extractLine line]
                ) fileName sources, Just fileName)
  else (sources, Nothing)

extractLine :: String -> String
extractLine = drop 6 . foldr (\c acc ->
                if not (null acc) && head acc == '\\' && c == '\\' then acc
                else if not (null acc) && head acc == '"' && c == '\\' then acc
                else if c == '‹' then '<':acc
                else if c == '›' then '>':acc
                else c:acc
              ) ""

processLines :: [String] -> Acc
processLines = foldl step (M.empty, Nothing)

process = fst . processLines . lines

writeSources :: M.Map String [String] -> String -> IO ()
writeSources sources destDir = 
  forM_ (M.toList sources) (\(fileName,sourceLines) ->
    do
      houtput <- openFile (destDir ++ "/" ++ fileName) WriteMode
      hSetEncoding houtput utf8
      hPutStr houtput (unlines $ reverse $ dropWhile null sourceLines)
      hClose houtput
   )

main = do
  args <- getArgs
  let sourceFile = head args
  let destDir = head (tail args)
  hinput <- openFile sourceFile ReadMode
  hSetEncoding hinput utf8
  content <- hGetContents hinput
  let sources = process content
  writeSources sources destDir
  hClose hinput
