module SnakeRevisited where

import SnakeStateRevisited (..)
import SnakeView (..)

main : Signal Element
main = view <~ stateSignal
