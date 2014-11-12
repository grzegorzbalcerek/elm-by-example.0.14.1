-- -*- coding: utf-8; -*-

import Lib (..)
import Window

content w = pageTemplate [text1,container w 520 middle picture,text2]
            "Chapter6TimeSignals" "toc" "Chapter8RandomSignals" w
main = lift content Window.width

text1 = [markdown|

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


      color : Int -> Color
      color n =
          let colors =
                  A.fromList [ green, red, blue, yellow, brown, purple, orange ]
          in
              A.getOrElse black (n % (A.length colors)) colors


      circleForm : (Int, (Int, Int)) -> Form
      circleForm (r, (x, y)) =
          circle (toFloat r*5)
              |> filled (color r)
              |> move (toFloat x,toFloat y)


      drawCircles : [(Int, (Int, Int))] -> (Int, Int) -> Element
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
`fromList` function of the `Array` module. The `getOrElse` function
returns the element from the given index. Its first argument is a
fallback value, in case the index provided in the second argument does
not exist in the array (it is never used in our case, since we always
calculate a correct index value).

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


      import Mouse
      import Window


      delayedMousePositions : [Int] -> Signal [(Int, (Int, Int))]
      delayedMousePositions rs =
          let adjust (w, h) (x, y) = (x-w//2,h//2-y)
              n = length rs
              position = adjust <~ Window.dimensions ~ Mouse.position
              positions = repeat n position -- [Signal (Int, Int)]
              delayedPositions =            -- [Signal (Int, (Int, Int))]
                  zipWith
                  (\r pos ->
                      let delayedPosition = delay (toFloat r*100) pos
                      in
                          lift (\pos -> (r,pos)) delayedPosition)
                  rs
                  positions
          in
              combine delayedPositions


      main = asText <~ delayedMousePositions [0,10,25]

The `delayedMousePositions` function takes a list of values
representing the delays and returns the signal. The following figure
presents how the signal is built by combining and transforming other
signals.

|]

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
  , sigBox "Signal (Int,Int)" "position" "lift adjust" 140 0 4
  , sigVertArr 3 0
  , sigBox "[Signal (Int,Int)]" "positions" "repeat" 140 0 3
  , sigVertArr 2 0
  , sigBox "[Signal (Int,(Int,Int))]" "delayedPositions" "delay" 140 0 2
  , sigVertArr 1 0
  , sigBox "Signal [(Int,(Int,Int))]" "mousePositions" "combine" 140 0 1
  ]

text2 = [markdown|

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
function returns a list of type `[Signal (Int,Int)]`.

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

      > combine
      <function> : [Signal.Signal a] -> Signal.Signal [a]

Again, the `main` function is used for testing. You can see its result
[here](DelayedMousePositions.html).

The [*DelayedCircles.elm*](DelayedCircles.html) program combines the
`delayedMousePositions` with the `drawCircles` function. The outcome
is a series of circles, each of which follow the mouse pointer, but
with a time lag proportional to the size of the circle.

% DelayedCircles.elm
      import Window
      import Fibonacci (fibonacci)
      import DrawCircles (drawCircles)
      import DelayedMousePositions (delayedMousePositions)


      main =
          drawCircles
              <~ delayedMousePositions (fibonacci 8 |> tail |> reverse)
              ~ Window.dimensions

The sizes of the circles are calculated by the `fibonacci` function
from the `Fibonacci` module described in [Chapter
2](Chapter2FibonacciBars.html).

The [next](Chapter8RandomSignals.html) chapter presents signals used
for generating random numbers.

|]
