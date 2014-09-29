module Foldpm where
{-| A library for manipulating state in Elm programs by composing
state-modifying functions of type:

    a -> b -> Maybe b

An example is described in [Chapter 13 of Elm by
example](http://elm-by-example.org/Chapter13SnakeRevisited.html).

-}

{-| Creates a past dependent signal by internally calling `foldp` from
the standard library. The difference between this function and `foldp`
lies in the first argument. The type of the first argument of this function is:

    a -> b -> Maybe b

The type of the first argument of `foldp` is:

    a -> b -> b

This function calls `foldp` passing it the auxiliary `step` function,
defined in the let expression, as its first argument. The `step`
function calls the function passed to `foldpm` as the first argument
and handles the result of that call. If the result is wrapped in
`Just`, that result is simply unwrapped. If the result is `Nothing`,
the `step` function returns its second argument (the state) unchanged.
-}
foldpm : (a -> b -> Maybe b) -> b -> Signal a -> Signal b
foldpm stepm b sa =
  let step event state = case stepm event state of
    Nothing -> state
    Just x -> x
  in foldp step b sa

{-| Wraps its second argument in `Just` if
the first argument is true. Returns `Nothing` otherwise.
-}
when : Bool -> a -> Maybe a
when p result = if p then Just result else Nothing

{-| Takes one argument, which is a list of functions. Returns a
function of the same type. The returned function is a composition of
the input functions. The composed function tries calling each of the
input functions one by one, until it finds one that returned a `Just`
result. That result becomes the final result of the composed
function. If none of the input functions returned `Just`, the composed
function returns `Nothing`.
-}
compose : [a -> b -> Maybe b] -> (a -> b -> Maybe b)
compose steps = case steps of
  [] -> \_ _ -> Nothing
  f::fs -> \a b -> case f a b of
    Nothing -> (compose fs) a b
    Just x -> Just x

