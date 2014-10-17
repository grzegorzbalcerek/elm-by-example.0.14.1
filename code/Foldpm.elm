module Foldpm where

foldpm : (a -> b -> Maybe b) -> b -> Signal a -> Signal b
foldpm stepm b sa =
  let step event state = case stepm event state of
    Nothing -> state
    Just x -> x
  in foldp step b sa

when : Bool -> a -> Maybe a
when p result = if p then Just result else Nothing

compose : [a -> b -> Maybe b] -> (a -> b -> Maybe b)
compose steps = case steps of
  [] -> \_ _ -> Nothing
  f::fs -> \a b -> case f a b of
    Nothing -> (compose fs) a b
    Just x -> Just x

