-- -*- coding: utf-8; -*-

import Lib (..)
import Window

content w = pageTemplate [content1]
            "Chapter11KeyboardSignals" "toc" "Chapter13TicTacToe" w
main = lift content Window.width

content1 = [markdown|

# Chapter 12 Paddle

Now that we know keyboard signals, we will use them to create a game.
The *[Paddle.elm](Paddle.elm)* program is a game. The player uses the
keyboard arrows to move the paddle left or right to keep the moving
ball within the area limited by the blue walls.  Before continuing,
try the game [here](Paddle.html), to have an idea of how it works.

The code starts with the `Paddle` module declaration and a list of imports.

      module Paddle where

      import Window
      import Text as T
      import Keyboard

After the imports, four functions which draw various elements of the
game view are defined. The `borders` function draws the blue wall by
drawing a blue square and a slightly smaller white rectangle on top of
it.

      borders : Form
      borders = group
        [ rect 440 440 |> filled blue
        , rect 400 420 |> filled white |> moveY -10
        ]

The `paddle` function draws the green paddle, given its horizontal
position passed as the parameter.

      paddle : Float -> Form
      paddle x =
        rect (toFloat 100) (toFloat 20) |>
        filled green |>
        move (x,-210)

The `ball` function takes the coordinates of the ball as arguments and
draws an orange circle.

      ball : Float -> Float -> Form
      ball x y = filled orange (circle 10) |> move (x,y)

Finally the `gameOver` function draws the “Game Over” text presented
to the user when the game is over.

      gameOver : Element
      gameOver =
          T.toText "Game Over" |>
          T.color red |>
          T.bold |>
          T.height 60 |>
          T.centered |>
          container 440 440 middle

The `State` type represents the state of the game.

      type State = { x: Float
                   , y: Float
                   , dx: Float
                   , dy: Float
                   , paddlex: Float
                   , paddledx: Float
                   , isOver: Bool
                   }

The `x` and `y` members are the coordinates of the ball. The `dx` and
`dy` members represent the horizontal and vertical velocity of the
ball. The `paddlex` and `paddledx` represent the horizontal position
and velocity of the paddle (the vertical position is fixed and does
not have to be part of the state). The `isOver` flag holds the
information whether the game is over or not.

The `initialState` function creates the initial state of the game.

      initialState : State
      initialState = { x = 0
                     , y = 0
                     , dx = 0.14
                     , dy = 0.2
                     , paddlex = 0
                     , paddledx = 0
                     , isOver = False
                     }

The `view` function takes the state value as argument and draws the
game view using the functions described above.

      view : State -> Element
      view s = layers [
        collage 440 440
        [ borders
        , paddle s.paddlex
        , ball s.x s.y
        ]
        , if s.isOver then gameOver else empty
        ]

The state of the game will change in response to a time-based signal —
for moving the ball — and to a keyboard-based signal — for moving the
paddle. Both signals will be merged. In order to do that, we will need
a data type representing events from both signals. The `Event` data
type represents the events.

      data Event = Tick Time | PaddleDx Int

The `Tick` constructor takes a `Time` value as parameter and creates
an event representing a time-based tick. The `PaddleDx` constructor
takes a numeric value and creates a keyboard-based event representing
the new value of the horizontal paddle velocity.

The `clockSignal` function creates a signal of ticks using the
standard library `fps` function.

      clockSignal : Signal Event
      clockSignal = lift Tick <| fps 100

The `keyboardSignal` function uses the `Keyboard.arrows` signal to
create a signal of keyboard-based events. Only the `x` members from
the values produced by the `Keyboard.arrows` signal are needed in our
game. The numeric values carried by the `PaddleDx` events will only
have one of three possible values coming from the `Keyboard.arrows`
events: `-1`, `0`, or `1`.

      keyboardSignal : Signal Event
      keyboardSignal = lift (.x >> PaddleDx) Keyboard.arrows

The `eventSignal` merges both signal into one combined signal.

      eventSignal : Signal Event
      eventSignal = merge clockSignal keyboardSignal

The `gameSignal` function creates a signal representing how the game
state changes over time by folding (`foldp`) the `eventSignal`
events using the `step` function.

      gameSignal : Signal State
      gameSignal = foldp step initialState <| eventSignal

The `foldp` function takes three arguments. The first one is the
`step` function — it is a function that takes two arguments (the
current event and the current state) and produces the new state. The
second argument is the initial state, returned by the `initialState`
function. The third one is the signal of input events (returned by
`eventSignal`).

The `step` function combines an event and the current game state to
produce a new game state.

      step : Event -> State -> State
      step event s =
        if s.isOver
        then s
        else case event of
          Tick time ->
             { s
             | x <- s.x + s.dx*time
             , y <- s.y + s.dy*time
             , dx <- if (s.x >= 190 && s.dx > 0)  ||
                        (s.x <= -190 && s.dx < 0)
                     then -1*s.dx
                     else s.dx
             , dy <- if (s.y >= 190 && s.dy > 0) ||
                        (s.y <= -190 && s.dy < 0 &&
                         s.x >= s.paddlex - 50 &&
                         s.x <= s.paddlex + 50)
                     then -1*s.dy
                     else s.dy
             , paddlex <- ((s.paddlex + s.paddledx*time) `max` -150) `min` 150
             , isOver <- s.y < -200
             }
          PaddleDx dx -> { s | paddledx <- 0.1 * toFloat dx }

The function first verifies whether the game is over already. If it
is, the state is returned unchanged. Otherwise, the event is
pattern-matched agains the possible constructors.

The `Tick` event triggers an update of almost all of the state
member. The ball coordinates `x` and `y` are changed by adding the
current velocity (`dx` and `dy`) multiplied by the amount of time
carried by the tick event. Since the tick events are generated by the
`fps` function, the `time` value represents the time elapsed since the
previous event was generated. Likewise, the `paddlex` value is
updated, but the code makes sure that the new value stays withing the
range of -150 to 150.

The `step` functions also verifies whether changes are required to the
values of the vertical and horizontal ball velocity, and if they are,
the velocity values are negated. The horizontal velocity is changed
when the ball hits the left or right wall. The vertical velocity is
changed when the ball hits the top wall or the paddle.

If the ball misses the paddle and its vertical coordinate falls below
-200, the game is over and the `isOver` value is updated accordingly.

The `PaddleDx` event only results in setting a new value of the
horizontal paddle velocity `paddledx`.

The `main` function lifts the `view` function into the `gameSignal`
producing the final game signal that is rendered on the screen.

      main : Signal Element
      main = lift view gameSignal

In order to transform the game state, we have used a monolitic `step`
function, that reacts to each possible combination of input event and
current state. The solution works, but it has the disadvantage that
the function which transforms the state may become big and difficult
to maintain for larger programs. We will explore alternatives to that
approach in the subsequent chapters. The
[next](Chapter13TicTacToe.html) chapter presents a program which uses
an alternative approach.

|]
