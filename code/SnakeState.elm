module SnakeState where

import SnakeModel (..)
import SnakeSignals (..)

stateSignal : Signal SnakeState
stateSignal = foldp step initialState eventSignal

step : Event -> SnakeState -> SnakeState
step event state =
    case (event,state.gameOver) of
      (NewGame,_) -> initialState
      (_,True) -> state
      (Direction newDelta,_) ->
        { state | delta <- if abs newDelta.dx /= abs state.delta.dx
                           then newDelta
                           else state.delta }
      (Tick newFood, _) ->
        let state1 = if state.ticks % velocity == 0
                     then { state | gameOver <- collision state }
                     else state
        in if state1.gameOver
           then state1
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
                in { state3 | ticks <- state3.ticks + 1 }
      (Ignore,_) -> state

