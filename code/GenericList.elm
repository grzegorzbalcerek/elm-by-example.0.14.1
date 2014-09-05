module GenericList where

data GenericList a = Nil | Cons a (GenericList a)

listSize : GenericList a -> Int
listSize lst = case lst of
  Nil -> 0
  Cons _ tail -> 1 + listSize tail
