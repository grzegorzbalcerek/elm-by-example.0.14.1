-- -*- coding: utf-8; -*-

import Lib (..)
import Window
import Signal
import Markdown
import Graphics.Element (..)
import Graphics.Collage (..)
import Signal ((<~))

content w = pageTemplate [text1,container w 520 middle picture,text2]
            "Chapter6TimeSignals" "toc" "Chapter8Circles" w
main = Signal.map content Window.width

text1 = Markdown.toElement """

# Chapter 7 Delayed Circles

The next example, *[DelayedCircles.elm](DelayedCircles.elm)*, is a
program displaying several colorful circles. The circles follow the
mouse pointer, but not immediately. There is a time lag associated
with each circle, which is larger for bigger circles. Before
continuing, take a look at the working program
[here](DelayedCircles.html), to have an idea of how it works.

The `DrawCircles` module defines the `drawCircles` function, which
draws the circles given a list of their radiuses.

% DrawCircles.elm
      module DrawCircles where


      import Array as A
      import Color (Color, blue, brown, green, orange, purple, red, yellow)
      import Graphics.Collage (Form, circle, collage, filled, move)
      import Graphics.Element (Element)
      import List (map)
      import Maybe


      color : Int -> Color
      color n =
          let colors =
                  A.fromList [ green, red, blue, yellow, brown, purple, orange ]
              maybeColor = A.get (n % (A.length colors)) colors
          in
              Maybe.withDefault green maybeColor


      circleForm : (Int, (Int, Int)) -> Form
      circleForm (r, (x, y)) =
          circle (toFloat r*5)
              |> filled (color r)
              |> move (toFloat x,toFloat y)


      drawCircles : List (Int, (Int, Int)) -> (Int, Int) -> Element
      drawCircles d (w, h) = collage w h <| map circleForm d

      main =
          drawCircles [
                  (3, (-200, 0)),
                  (4, (-100, 0)),
                  (5, (0, 0)),
                  (7, (100, 0)),
                  (9, (200, 0))
              ]
              (600, 400)

The `color` function takes a number and returns one of the colors from
a predefined list. The argument modulo the length of the list gives
the index of the returned color. In order to retrieve an element from
a given index, the list is transformed into an array using the
`fromList` function of the `Array` module. The `get` function is used
to retrieve the element from the given index.

      get : Int -> Array a -> Maybe a

Its first argument is the index, and the second argument is the
array. However, the result type is not `a` — the type of array
elements — but `Maybe a`. Let’s see what the `get` function returns
depending on the value of the index.

      > import Array as A
      > arr = A.fromList ['a', 'b', 'c', 'd']
      Array.fromList ['a','b','c','d'] : Array.Array Char
      > A.get 0 arr
      Just 'a' : Maybe.Maybe Char
      > A.get 9 arr
      Nothing : Maybe.Maybe Char

 The `Maybe` data type is defined in the `Maybe` module and it is a so
called *union type* and it is a union of two distinct cases. It
represents optional values. An existing value is represented by the
`Just` case, while a non-existing value by `Nothing`. Array elements
are indexed starting with 0, thus 0 is a valid index and the return
value is the first element of our array “wrapped” in `Just`. However,
calling `get` with the index of 9 returns `Nothing`. To get the value
out of the `Maybe` type we can use the `Maybe.withDefault` function.

      > import Maybe (withDefault)
      > withDefault
      <function> : a -> Maybe.Maybe a -> a
      > withDefault 'z' (A.get 0 arr)
      'a' : Char
      > withDefault 'z' (A.get 9 arr)
      'z' : Char

The first argument of `withDefault` is a fallback value — to be used
in case the `Maybe` value is `Nothing`.

The `color` function in the `DrawCircles` module uses `withDefault` to
“unwrap” the color value from the `Maybe` value returned by `get`, but
the fallback value is never used, since the code always calculate a
correct index value when calling `get.

The `circleForm` function returns a `Form` representing a circle drawn
according to the data provided in the first argument. The first
argument is provided as a pair (tuple) of values. The first of them
represents the circle radius. The second one is another pair,
representing its position.

The `drawCircles` method takes a list of values specifying the circle
radiuses and coordinates and creates an element with the drawn
circles. The second argument represent the dimensions of the element.

The `main` function tests the code. You can see its result
[here](DrawCircles.html).

The `DelayedMousePositions` module defines a signal carrying mouse
positions delayed by certain amounts of time. Each event of the signal
is a list of pairs. The first element of each pair is a number
indicating how much time the of mouse position coordinates should be
delayed (the units used are tenths of seconds). The second element of
each pair is the delayed mouse position.

% DelayedMousePositions.elm
      module DelayedMousePositions where


      import List
      import List ((::), foldr, length, repeat)
      import Mouse
      import Signal
      import Signal (Signal, (~), (<~), constant)
      import Text (asText)
      import Time (delay)
      import Window


      combine : List (Signal a) -> Signal (List a)
      combine = foldr (Signal.map2 (::)) (constant [])


      delayedMousePositions : List Int -> Signal (List (Int, (Int, Int)))
      delayedMousePositions rs =
          let adjust (w, h) (x, y) = (x-w//2,h//2-y)
              n = length rs
              position = adjust <~ Window.dimensions ~ Mouse.position
              positions = repeat n position -- List (Signal (Int, Int))
              delayedPositions =            -- List (Signal (Int, (Int, Int))
                  List.map2
                  (\\r pos ->
                      let delayedPosition = delay (toFloat r*100) pos
                      in
                          (\\pos -> (r,pos)) <~ delayedPosition)
                  rs
                  positions
          in
              combine delayedPositions


      main = asText <~ delayedMousePositions [0,10,25]

The `delayedMousePositions` function takes a list of values
representing the delays and returns the signal. The following figure
presents how the signal is built by combining and transforming other
signals.

"""

sigBox a b c w x line = signalFunctionBox 14 18 50 a b c w x (line*100-300)
sigVertU line x = sigVerticalLine 25 x (line*100-238)
sigVertD line x = sigVerticalLine 25 x (line*100-238-25)
sigVert line x = sigVerticalLine 50 x (line*100-250)
sigHoriz w line x = sigHorizontalLine w x (line*100-250)
sigArr line x = sigDownwardArrow x (line*100-265)
sigVertArr line x = group [sigVert line x, sigArr line x ]

picture = collage 600 510
  [ sigBox "Signal (Int,Int)" "Window.dimensions" "" 170 -100 5
  , sigBox "Signal (Int,Int)" "Mouse.position" "" 170 100 5
  , sigVertArr 4 -45
  , sigVertArr 4 45
  , sigBox "Signal (Int,Int)" "position" "adjust" 140 0 4
  , sigVertArr 3 0
  , sigBox "[Signal (Int,Int)]" "positions" "repeat" 140 0 3
  , sigVertArr 2 0
  , sigBox "[Signal (Int,(Int,Int))]" "delayedPositions" "delay" 140 0 2
  , sigVertArr 1 0
  , sigBox "Signal [(Int,(Int,Int))]" "mousePositions" "combine" 140 0 1
  ]

text2 = Markdown.toElement """

The `Window.dimensions` and `Mouse.positions` signals are the basic
signals from the standard library, that are transformed into the
output signal.

The first transformation is performed by the `position` function,
which returns a signal of the mouse positions represented in a
coordinate system suitable for drawing. The `Mouse.position` values
are using the coordinate system with the origin in the top-left corner
and with coordinates increasing to the right and downwards. The
`position` signal values use the center of the screen as the
origin. The coordinate values increase as mouse pointer moves to the
right and upwards.

The `positions` function returns the `position` signal repeated `n`
times, where `n` is the length of the input list. Thus the `positions`
function returns a list of type `List (Signal (Int,Int))`.

The `delayedPositions` returns a list of signals, each of which
carries pairs of values — the function return type is `[Signal
(Int,(Int,Int))]`. The first value of the pair is one of the values
from the list provided as the input argument. The second value of the
pair is a pair of mouse pointer coordinates delayed by a given amount
of time. The `delay` function from the `Time` module is used to obtain
a delayed signal.

      > delay
      <function: delay> : Float -> Signal.Signal a -> Signal.Signal a

The returned signal is produced using the `combine` function, which
turns a list of signals into a signal of a list of values.

Again, the `main` function is used for testing. You can see its result
[here](DelayedMousePositions.html).

The [*DelayedCircles.elm*](DelayedCircles.html) program combines the
`delayedMousePositions` with the `drawCircles` function. The outcome
is a series of circles, each of which follow the mouse pointer, but
with a time lag proportional to the size of the circle.

% DelayedCircles.elm
      module DelayedCircles where


      import DelayedMousePositions (delayedMousePositions)
      import DrawCircles (drawCircles)
      import Fibonacci (fibonacci)
      import List (reverse, tail)
      import Signal ((~), (<~))
      import Window


      main =
          drawCircles
              <~ delayedMousePositions (fibonacci 8 |> tail |> reverse)
              ~ Window.dimensions

The sizes of the circles are calculated by the `fibonacci` function
from the `Fibonacci` module described in [Chapter
2](Chapter2FibonacciBars.html).

The [next](Chapter8Circles.html) chapter presents signals used
for generating random numbers.

"""
