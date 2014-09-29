module SnakeSignals where

import SnakeModel (..)
import SnakeView (..)
import Keyboard
import Random
import Char

timeSignal : Signal Float
timeSignal = fps <| 50

xSignal : Signal Int
xSignal = Random.range -boardSize boardSize timeSignal

ySignal : Signal Int
ySignal = Random.range -boardSize boardSize timeSignal

tickSignal : Signal Event
tickSignal =
  let combine x y = Tick { x = x, y = y }
  in combine <~ xSignal ~ ySignal

directionSignal : Signal Event
directionSignal =
  let arrowsToDelta {x,y} =
        if | x == 0 && y == 0 -> Ignore
           | x /= 0           -> Direction { dx = x, dy = 0 }
           | otherwise        -> Direction { dx = 0, dy = y }          
  in lift arrowsToDelta Keyboard.arrows

newGameSignal : Signal Event
newGameSignal =
 always NewGame <~ (keepIf identity False <| Keyboard.isDown (Char.toCode 'N'))

eventSignal : Signal Event
eventSignal = merges [tickSignal, directionSignal, newGameSignal]

