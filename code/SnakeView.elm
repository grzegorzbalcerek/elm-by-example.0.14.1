module SnakeView where

import Text
import Maybe (maybe)
import SnakeModel (..)
import SnakeModel
type Position = SnakeModel.Position

unit = 15
innerSize = unit * boxSize
outerSize = unit * (boxSize+1)

box = collage outerSize outerSize [
  filled black <| rect outerSize outerSize,
  filled white <| rect innerSize innerSize ]

drawPosition : Color -> Position -> Form
drawPosition color position =
  filled color (rect unit unit) |>
  move (toFloat (unit*position.x), toFloat (unit*position.y))

drawPositions : Color -> [Position] -> Element
drawPositions color positions = collage outerSize outerSize (map (drawPosition color) positions)

drawFood : Position -> Element
drawFood position = drawPositions green [position]

gameOver : Element
gameOver =
    Text.toText "Game Over" |>
    Text.color red |>
    Text.bold |>
    Text.height 60 |>
    Text.centered |>
    container outerSize outerSize middle

instructions : Element
instructions =
  plainText "Press the arrows to change the snake move direction.\nPress N to start a new game." |>
  container outerSize (outerSize+3*unit) midBottom

view state =
  layers [ box
         , instructions
         , drawPositions blue state.snake.front
         , drawPositions blue state.snake.back
         , maybe empty drawFood state.food
         , if state.gameOver then gameOver else empty ]

main = view initialState
