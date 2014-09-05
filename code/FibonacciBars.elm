module FibonacciBars where

import Fibonacci (..)

color n =
  let colors = [red,orange,yellow,green,blue,purple,brown]
  in drop (n `mod` (length colors)) colors |> head

bar (index,n) = flow right [
  collage (n*20) 20 [filled (color index) (rect (toFloat n * 20) 20)],
  asText n]

main = flow down <| map bar (fibonacciWithIndexes 10)
