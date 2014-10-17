-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Chapter10Calculator" "toc" "Chapter12Paddle") Window.width

content = [markdown|

# Chapter 11 Keyboard Signals

The `Keyboard` module defines functions for dealing with keyboard
input. Elm defines the `KeyCode` type as an alias for `Int` and
keyboard input values are expressed using that type. We can use the
`toChar` and `fromChar` functions from the `Char` module to convert
between `KeyCode` values and characters (`Char` values). Bear in mind
though that the `toCode` function returns the codes of the uppercase
ASCII letters, regardless of whether you provide the lowercase or
uppercase character as argument.

      > import Char (toCode, fromCode)
      > import Keyboard (..)
      > toCode 'a'
      65 : Int
      > toCode 'A'
      65 : Int
      > toCode '2'
      50 : Int
      > fromCode 65
      "A" : Char
      > fromCode 97
      "a" : Char

The `Keyboard` module defines functions which create keyboard related
signals. The `keysDown` function creates a signal which informs what
keys are currently being pressed. The signal value is a list of key
codes. [Try](KeyboardSignals1.html) the
*[KeyboardSignals1.elm](KeyboardSignals1.elm)* program to see it in
action:

      import Keyboard
      main = lift asText Keyboard.keysDown

The `lastPressed` function returns a signal which provides the code of
the last pressed key — even when the key is not currently being
pressed any more. Check it out using the
*[KeyboardSignals2.elm](KeyboardSignals2.elm)* program
[here](KeyboardSignals2.html):

      import Keyboard
      main = lift asText Keyboard.lastPressed

The `isDown` function takes a key code as its argument and returns a
boolean signal indicating whether the given key is currently being
pressed. There are also helper functions defined in terms of `isDown`
for certain special keys: `shift`, `ctrl`, `space` and
`enter`. [Run](KeyboardSignals3.html) the
*[KeyboardSignals3.elm](KeyboardSignals3.elm)* program and try
pressing the *A* key:

      import Keyboard
      main = lift asText (Keyboard.isDown (toCode 'A'))

The `directions` function is useful for building games. It takes
four key codes as arguments and returns a signal of `{ x: Int, y: Int
}` records. The arguments are interpreted as keys representing four
directions in the following order: up, down, left, right. Pressing the
up and down keys affect the `y` values in the output record as
follows:

 * when the *up* key is pressed and the *down* key is not, then `y` has the value of 1
 * when the *down* key is pressed and the *up* key is not, then `y` has the value of -1
 * when both *up* and *down* keys are pressed or none of them, then `y` has the value of 0

Pressing the *left* and *right* keys affects the values of the `x`
member in a similar way. [Run](KeyboardSignals4.html) the
*[KeyboardSignals4.elm](KeyboardSignals4.elm)* program and try
pressing the *Q*, *A*, *O* and *P* keys in various combinations:

      import Keyboard
      main = lift asText (Keyboard.directions 81 65 79 80)

There are also two helper functions defined in terms of `directions`:
`wasd` and `arrows`.

The [next](Chapter12Paddle.html) chapter presents a game which uses
keyboard as input.

|]
