-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Chapter5Eyes" "toc" "Chapter7DelayedCircles") Window.width

content = [markdown|

# Chapter 6 Time Signals

The `Time` module from the standard library defines functions and
signals related to working with time.  Elm defines the `Time` type as
an alias for `Float`. A value of that type denotes a given number of
milliseconds. However, we do not have to remember that the time values
are expressed in milliseconds. The `Time` modules provides functions
returning units of time: `millisecond`, `second`, `minute`,
`hour`. You can multiply their results by a given number to get the
requested duration:

      > import Time (..)
      > millisecond
      1 : Float
      > 2*second
      2000 : Float
      > 4*minute
      240000 : Float
      > hour
      3600000 : Float

There are also functions which convert values in the opposite direction:

      > inSeconds 2000
      2 : Float
      > inMinutes 90000
      1.5 : Float
      > inHours 7200000
      2 : Float
      > inMilliseconds 4
      4 : Float

Besides the above functions, the `Time` module defines functions which
create time related signals. The *[TimeSignals.elm](TimeSignals.elm)*
program (a working example is available [here](TimeSignals.html)),
presents a few examples of their use.

      import Time
      import Mouse

      showsignals a b c d e f =
       flow down <| map plainText
       [ "every (5*second): " ++ show a
       , "since (2*second) Mouse.clicks: " ++ show b
       , "timestamp Mouse.isDown: " ++ show c
       , "delay second Mouse.position: " ++ show d
       , "fps 200: " ++ show e
       , "fpsWhen 200 Mouse.isDown: " ++ show f
       ]

      main = showsignals <~ every (5*second)
                          ~ since (2*second) Mouse.clicks
                          ~ timestamp Mouse.isDown
                          ~ delay second Mouse.position
                          ~ fps 200
                          ~ fpsWhen 200 Mouse.isDown

The first signal, `every second`, outputs the current timestamp every
5 seconds.

The second signal is a boolean signal, that is `True` for 2 seconds
after every mouse click. The `since` function takes a `Time` value `t`
and another signal and outputs a `Boolean` signal which is true during
time `t` after every event from the input signal.

The third signal outputs pairs of values: the first element of the
pair is the current timestamp, and the second one is the value of the
`Mouse.isDown` signal.

The fourth signal outputs `Mouse.position` delayed by one second. The
`delay` function takes a `Time` value and a signal, and creates
another signal which outputs the same events as the input signal, but
delayed by the given time.

The fifth signal outputs events as fast as possible, but no more than
200 per second (on fast computers it will be approximately 200 events
per second, but on slower computers it may be less than that). The
value emmitted as each event, is the time difference the time the
current event is emitted and the time the previous event was emitted.

The last signal is like the previous one, but it only emits events
when the mouse button is pressed.

The [next](Chapter7DelayedCircles.html) chapter presents an example
program that is using one of the functions presented above.

|]

