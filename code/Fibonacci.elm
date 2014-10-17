module Fibonacci where

fibonacci : Int -> [Int]
fibonacci n =
  let fibonacci' n acc =
        if n <= 2
        then acc
        else let cadr = tail >> head
                 next = head acc + cadr acc
             in fibonacci' (n-1) (next :: acc)
  in fibonacci' n [1,1] |> reverse

fibonacciWithIndexes : Int -> [(Int,Int)]
fibonacciWithIndexes n = zip [0..n] (fibonacci n)

