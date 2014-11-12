module TicTacToe where


import TicTacToeModel (..)
import TicTacToeView (..)
import Mouse


clickSignal : Signal (Int,Int)
clickSignal = sampleOn Mouse.clicks Mouse.position


newGameButtonSignal : Signal ()
newGameButtonSignal = newGameInput.signal


undoButtonSignal : Signal ()
undoButtonSignal = undoInput.signal


newGameSignal : Signal (GameState -> GameState)
newGameSignal = always (always initialState) <~ newGameButtonSignal


undoSignal : Signal (GameState -> GameState)
undoSignal = always undoMoves <~ undoButtonSignal


moveSignal : Signal (GameState -> GameState)
moveSignal = processClick <~ clickSignal


inputSignal : Signal (GameState -> GameState)
inputSignal = merges [ moveSignal, newGameSignal, undoSignal ]


gameStateSignal : Signal GameState
gameStateSignal = foldp (<|) initialState inputSignal


main : Signal Element
main = lift view gameStateSignal
