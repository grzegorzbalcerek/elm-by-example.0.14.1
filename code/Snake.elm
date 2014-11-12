module Snake where


import SnakeState (..)
import SnakeView (..)


main : Signal Element
main = view <~ stateSignal
