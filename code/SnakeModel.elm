module SnakeModel where

import Set
import Maybe (maybe)

type Position = { x: Int, y: Int }
type Delta = { dx: Int, dy: Int }
type Snake = { front: [Position], back: [Position] }
type SnakeState = { snake: Snake, delta: Delta, food: Maybe Position, ticks: Int, gameOver: Bool }

initialSnake = { front = [{x = 0, y = 0}, {x = 0, y = -1}, {x = 0, y = -2}, {x = 0, y = -3}], back = [] }
initialDelta = { dx = 0, dy = 1 }
initialFood = Nothing
initialState = { snake = initialSnake, delta = initialDelta, food = initialFood, ticks = 0, gameOver = False }

data Event = Tick Position | Direction Delta | NewGame | Ignore

boardSize = 15
boxSize = boardSize + boardSize + 1
velocity = 50

nextPosition : Snake -> Delta -> Position
nextPosition snake {dx,dy} =
  let headPosition = head snake.front
  in { x = headPosition.x + dx, y = headPosition.y + dy }

moveSnakeForward : Snake -> Delta -> Maybe Position -> Snake
moveSnakeForward snake delta food =
  let next = nextPosition snake delta
      tailFunction = maybe tail (\f -> if next == f then identity else tail) food
  in
    if isEmpty snake.back
    then { front = [next]
         , back = (tailFunction << reverse) snake.front }
    else { front = next :: snake.front
         , back = tailFunction snake.back }

isInSnake : Snake -> Position -> Bool
isInSnake snake position =
  let frontSet = Set.fromList <| map show snake.front
      backSet = Set.fromList <| map show snake.back
  in Set.member (show position) frontSet || Set.member (show position) backSet

collision : SnakeState -> Bool 
collision state = 
  let next = nextPosition state.snake state.delta
  in if abs next.x > boardSize || abs next.y > boardSize || isInSnake state.snake next
     then True
     else False

step : Event -> SnakeState -> SnakeState
step event state =
    case (event,state.gameOver) of
      (NewGame,_) -> initialState
      (_,True) -> state
      (Direction newDelta,_) -> { state | delta <- if abs newDelta.dx /= abs state.delta.dx
                                                   then newDelta
                                                   else state.delta }
      (Tick newFood, _) -> { state
                           | ticks <- state.ticks + 1
                           , snake <- if state.ticks % velocity == 0
                                      then moveSnakeForward state.snake state.delta state.food
                                      else state.snake
                           , gameOver <- if state.ticks % velocity == 0 then collision state else False
                           , food <- maybe
                                     (if isInSnake state.snake newFood then Nothing else Just newFood)
                                     (\f -> if state.ticks % velocity == 0 && head state.snake.front == f then Nothing else state.food)
                                     state.food
                           }
      (Ignore,_) -> state
