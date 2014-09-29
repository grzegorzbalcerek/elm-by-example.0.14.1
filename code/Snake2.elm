module Snake2 where

import SnakeState2 (..)
import SnakeView (..)

main : Signal Element
main = view <~ stateSignal
