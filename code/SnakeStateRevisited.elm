module SnakeStateRevisited where

import SnakeModel (..)
import SnakeSignals (..)
import Foldpm
import Foldpm (..)

handleNewGame : Event -> SnakeState -> Maybe SnakeState
handleNewGame event _ = when (event == NewGame) initialState

handleGameOver : Event -> SnakeState -> Maybe SnakeState
handleGameOver _ state = when (state.gameOver) state

handleDirection : Event -> SnakeState -> Maybe SnakeState
handleDirection event state = case event of
  Direction newDelta -> Just { state | delta <- if abs newDelta.dx /= abs state.delta.dx
                                                then newDelta
                                                else state.delta }
  _ -> Nothing

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

step : Event -> SnakeState -> Maybe SnakeState
step = Foldpm.compose [handleNewGame, handleGameOver, handleDirection, handleTick]

stateSignal : Signal SnakeState
stateSignal = foldpm step initialState eventSignal
