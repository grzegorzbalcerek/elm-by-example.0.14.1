module Fibonacci where

fibonacci : Int -> [Int]
fibonacci n =
  let fibonacci' n acc =
        if n <= 2
        then acc
        else fibonacci' (n-1) ((head acc + (tail >> head) acc) :: acc)
  in fibonacci' n [1,1] |> reverse

fibonacciWithIndexes : Int -> [(Int,Int)]
fibonacciWithIndexes n = zip [0..n] (fibonacci n)

