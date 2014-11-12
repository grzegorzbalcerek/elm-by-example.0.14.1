import System.Environment(getArgs)
import qualified Data.Map.Strict as M
import Control.Monad (forM_)
import Data.Char (isSpace)
import Data.List (groupBy)
import Debug.Trace (traceShow, traceShowId)

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
                                  Just lines -> Just (drop 6 line:lines)
                                  Nothing -> Just [drop 6 line]
                ) fileName sources, Just fileName)
  else (sources, Nothing)

processLines :: [String] -> Acc
processLines = foldl step (M.empty, Nothing)

process = fst . processLines . lines

writeSources :: M.Map String [String] -> IO ()
writeSources sources = 
  forM_ (M.toList sources) (\(fileName,sourceLines) ->
    writeFile ("code/" ++ fileName) (unlines $ reverse $ dropWhile null sourceLines))

main = do
  args <- getArgs
  let srcFile = head args
  content <- readFile srcFile
  let sources = process content
  writeSources sources
