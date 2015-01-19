import System.Environment(getArgs)
import Data.List (isInfixOf, isPrefixOf)
import Data.Char (chr)
import Control.Monad (join)
import System.IO
import GHC.IO.Encoding

startsWithPercent ('%':_) = True
startsWithPercent _ = False

process = unlines . filter (not . startsWithPercent) . lines

main = do
  args <- getArgs
  let srcFile = head args
  let targetFile = "src/" ++ srcFile
  hinput <- openFile srcFile ReadMode
  hSetEncoding hinput utf8
  houtput <- openFile targetFile WriteMode
  hSetEncoding houtput utf8
  content <- hGetContents hinput
  hPutStr houtput (process content)
  hClose houtput
  hClose hinput
