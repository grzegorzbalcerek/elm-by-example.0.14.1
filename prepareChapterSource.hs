import System.Environment(getArgs)
import Data.List (isInfixOf, isPrefixOf)
import Data.Char (chr)
import Control.Monad (join)

startsWithPercent ('%':_) = True
startsWithPercent _ = False

process = unlines . filter (not . startsWithPercent) . lines

main = do
  args <- getArgs
  let srcFile = head args
  let targetFile = "src/" ++ srcFile
  content <- readFile srcFile
  writeFile targetFile (process content)
