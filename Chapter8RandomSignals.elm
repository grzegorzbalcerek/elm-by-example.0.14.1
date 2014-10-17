-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Chapter7DelayedCircles" "toc" "Chapter9Circles") Window.width

content = [markdown|

# Chpater 8 Random Signals

The `Random` module defines functions producing signals carrying
random numbers.

The `float` function creates a signal of float numbers between 0
(including) and 1 (excluding). The signal returned by this, and the
two other functions presented below, outputs a new event for each
event from the input signal, which is passed as the function
argument. Observe [here](RandomSignals1.html) the values produced for
each mouse click by the *[RandomSignals1.elm](RandomSignals1.elm)*
program, presented below.

      import Random
      import Mouse
      main = asText <~ Random.float Mouse.clicks

The `range` function creates a signal of integer numbers from within a
range specifed by the first two arguments. Observe
[here](RandomSignals2.html) the values produced for each mouse click
by the *[RandomSignals2.elm](RandomSignals2.elm)* program.

      import Random
      import Mouse
      main = asText <~ Random.range 10 20 Mouse.clicks

The `floatList` function creates a signal of lists of floating point
numbers. The input signal passed to the function as its first argument
must be a signal of type `Signal Int`. The length of the output list
is equal to the value carried by the input
signal. Observe [here](RandomSignals3.html) the values produced by the
*[RandomSignals3.elm](RandomSignals3.elm)* program as you move your
mouse.

      import Random
      import Mouse
      lengthSignal = lift (\x -> 1 + x // 100) Mouse.x
      main = asText  <~ Random.floatList lengthSignal

Our programs so far did not have any state. Yet state is
important. The [next](Chapter9Circles.html) chapter shows how to deal
with state in Elm programs.

|]
