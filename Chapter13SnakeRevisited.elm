-- -*- coding: utf-8; -*-

import Lib (..)
import Window

content w = pageTemplate [content1]
            "Chapter12TicTacToe" "toc" "" w
main = lift content Window.width

content1 = [markdown|

# Chapter 13 Snake Revisited

Chapter 11 presented a program which implemented the game of snake. That
program used a monolitic `step` function, that reacted to each
possible combination of input event and current state. The program
presented in this chapter — *[Snake2.elm](Snake2.elm)* — is a revised
version of that program, in which the state-modifying function is
composed from several smaller functions.

The `SnakeModel`, `SnakeView` and `SnakeSignal` modules are reused and
the `SnakeState` and `Snake` modules are replaced by new modules:
`SnakeState2` and `Snake2`. Additionally, a new auxiliary module
called `Foldpm` is used as well.

Our goal is to replace the previously used monolithic `step` by a set
of smaller functions that are composed together. The `step` function
from the `SnakeState` module had the following signature:

      step : Event -> SnakeState -> SnakeState

Its implementation consisted of a `case` expression, matching
combinations of the event and the `gameOver` member of the current
state. Thus, there were several cases that were considered, but only
one of them was matched during a single function invocation. We want to
keep that semantics. We cannot thus simply split the individual
patterns of the `case` expression into separate functions and compose
those functions using `>>` or `<<`, because that could cause code for
more than one case to be executed. Instead, our new step function will
have the following signature:

      step : Event -> SnakeState -> Maybe SnakeState

We will decompose our old `step` function into several smaller
functions with similar signatures, and the new `step` function will be
a composition of those smaller functions. Let’s first examine the
individual smaller functions. Each of them corresponds to a pattern
from the old `step` function.

The `handleNewGame` function handles the `NewGame` events. It returns
the initial state wrapped in `Just` if that event is being processed,
and `Nothing` otherwise.

      handleNewGame : Event -> SnakeState -> Maybe SnakeState
      handleNewGame event _ = when (event == NewGame) initialState

The auxiliary function `when` wraps its second argument in `Just` if
the first argument is true, and returns `Nothing` otherwise.

      when : Bool -> a -> Maybe a
      when p result = if p then Just result else Nothing

The `handleGameOver` function returns the state unchanged (but wrapped
in `Just`), if `state.gameOver` is true. It returns `Nothing` otherwise.

      handleGameOver : Event -> SnakeState -> Maybe SnakeState
      handleGameOver _ state = when (state.gameOver) state

The `handleDirection` function returns the state wrapped in `Just` with
the `delta` member potentially updated, when a `Direction` event is
received. It returns `Nothing` otherwise.

      handleDirection : Event -> SnakeState -> Maybe SnakeState
      handleDirection event state = case event of
        Direction newDelta -> Just { state | delta <- if abs newDelta.dx /= abs state.delta.dx
                                                      then newDelta
                                                      else state.delta }
        _ -> Nothing

The `handleTick` function handles the `Tick` events, returning the
updated state wrapped in `Just` if that event is being processed, and
`Nothing` otherwise.

      handleTick : Event -> SnakeState -> Maybe SnakeState
      handleTick event state = case event of
        Tick newFood ->
          let state1 = if state.ticks % velocity == 0
                       then { state | gameOver <- collision state }
                       else state
          in if state1.gameOver
             then Just state1
             else let state2 = { state1
                               | snake <-
                                   if state1.ticks % velocity == 0
                                   then moveSnakeForward state1.snake state1.delta state1.food
                                   else state1.snake
                               }
                      state3 = { state2
                               | food <-
                                   case state2.food of
                                     Just f -> 
                                       if state2.ticks % velocity == 0 && head state2.snake.front == f
                                       then Nothing
                                       else state2.food
                                     Nothing ->
                                       if isInSnake state2.snake newFood
                                       then Nothing
                                       else Just newFood
                               }
                  in Just { state3 | ticks <- state3.ticks + 1 }
        _ -> Nothing

The fact that the results of the above functions are wrapped in
`Maybe` gives an additional piece of information. The result of
`Nothing` means the function did not update the state and subsequent
functions (that the `step` function is composed of) may potentially
try to update it. The result of `Just` means that the function has
handled the state update and subsequent functions do not need to be
called.

We create the new `step` function by composing the above
functions. However, since the result is wrapped in `Maybe`, we cannot
use the regular function composition operators: `>>` and `<<`. Thus,
we compose the functions using an auxiliary function `compose`:

      step : Event -> SnakeState -> Maybe SnakeState
      step = Foldpm.compose [handleNewGame, handleGameOver, handleDirection, handleTick]

The `compose` function is defined as follows:

      compose : [a -> b -> Maybe b] -> (a -> b -> Maybe b)
      compose steps = case steps of
        [] -> \_ _ -> Nothing
        f::fs -> \a b -> case f a b of
          Nothing -> (compose fs) a b
          Just x -> Just x

It takes one argument, which is a list of functions. It returns a
function of the same type. The returned function is a composition of
the input functions. The composed function tries calling each of the
input functions one by one, until it finds one that returned a `Just`
result. That result becomes the final result of the composed
function. If none of the input functions returned `Just`, the composed
function returns `Nothing`.

There is one more issue that needs to be solved. The new signature of
`step` does not conform to what the first argument of `foldp` is
supposed to be. Thus, we cannot use `foldp` directly. Instead, we
define the `stateSignal` function using an auxiliary function
`foldpm`.

      stateSignal : Signal SnakeState
      stateSignal = foldpm step initialState eventSignal

The `foldpm` function is defined as follows:

      foldpm : (a -> b -> Maybe b) -> b -> Signal a -> Signal b
      foldpm stepm b sa =
        let step event state = case stepm event state of
          Nothing -> state
          Just x -> x
        in foldp step b sa

It calls `foldp`, passing it in the first argument the auxiliary
`step` function, defined in the let expression. The `step` function
calls the function passed to `foldpm` as the first argument and
handles the result of that call. If the result is wrapped in `Just`,
that result is simply unwrapped. If the result is `Nothing`, the
`step` function returns its second argument (the state) unchanged.

The `handleNewGame`, `handleGameOver`, `handleDirection`,
`handleTick`, `step` and `stateSignal` functions are defined in the
[`SnakeState2`](SnakeState2.elm) module.

The revised game has its own `main` function defined in the
[`Snake2`](Snake2.elm) module:

      module Snake2 where

      import SnakeState2 (..)
      import SnakeView (..)

      main : Signal Element
      main = view <~ stateSignal

You can see that program in action [here](Snake2.html). From the user
point of view it is analogous to the [*Snake.elm*](Snake.html)
program presented in [Chapter 11](Chapter11Snake.html).

The `foldpm`, `when` and `compose` functions are more general and not
specific to the snake program. They are defined in a separate module
called [`Foldpm`](Foldpm.elm).

|]
